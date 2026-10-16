import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/utils.dart';
import '../split_bill_vm.dart';
import '../widgets/add_participant_sheet.dart';

class InputSplitScreen extends ConsumerStatefulWidget {
  const InputSplitScreen({super.key});

  @override
  ConsumerState<InputSplitScreen> createState() => _InputSplitScreenState();
}

class _InputSplitScreenState extends ConsumerState<InputSplitScreen> {
  SplitAllocationMode _mode = SplitAllocationMode.equal;
  late List<TextEditingController> _amountControllers;
  late List<TextEditingController> _percentageControllers;
  late List<SplitParticipant> _participants;
  late double _totalBill;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(splitDraftProvider);
    _totalBill = draft.amount > 0 ? draft.amount : 500000.0;
    _mode = draft.allocationMode;

    _participants = List.from(draft.participants.isNotEmpty
        ? draft.participants
        : [
            const SplitParticipant(
              id: "p_you",
              name: "You",
              username: "@kelvin",
              phone: "+234 802 000 1122",
              avatarInitial: "K",
              amount: 0.0,
              status: ParticipantSplitStatus.paid,
              isYou: true,
            ),
            const SplitParticipant(
              id: "p_amara",
              name: "Amara Williams",
              username: "@amara",
              phone: "+234 813 456 7890",
              avatarInitial: "A",
              avatarColor: Color(0xFF6C5CE7),
              amount: 0.0,
              status: ParticipantSplitStatus.pending,
            ),
            const SplitParticipant(
              id: "p_tunde",
              name: "Tunde Bakare",
              username: "@tundeb",
              phone: "+234 809 112 3344",
              avatarInitial: "T",
              avatarColor: Color(0xFF00B894),
              amount: 0.0,
              status: ParticipantSplitStatus.pending,
            ),
          ]);

    _initControllers();
    _recalculateAllocation();
  }

  void _initControllers() {
    _amountControllers = List.generate(
      _participants.length,
      (_) => TextEditingController(),
    );
    _percentageControllers = List.generate(
      _participants.length,
      (_) => TextEditingController(),
    );
  }

  void _recalculateAllocation() {
    if (_participants.isEmpty) return;

    if (_mode == SplitAllocationMode.equal) {
      final share = _totalBill / _participants.length;
      final pct = 100.0 / _participants.length;
      for (int i = 0; i < _participants.length; i++) {
        _amountControllers[i].text = CurrencyFormatter.format(share).replaceFirst("₦", "").trim();
        _percentageControllers[i].text = pct.toStringAsFixed(1);
      }
    } else if (_mode == SplitAllocationMode.percentage) {
      // Percentage mode: Amount follows %
      for (int i = 0; i < _participants.length; i++) {
        final pctVal = double.tryParse(_percentageControllers[i].text) ?? (100.0 / _participants.length);
        final amt = (_totalBill * pctVal) / 100.0;
        _amountControllers[i].text = CurrencyFormatter.format(amt).replaceFirst("₦", "").trim();
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (final c in _amountControllers) {
      c.dispose();
    }
    for (final c in _percentageControllers) {
      c.dispose();
    }
    super.dispose();
  }

  double get _allocatedTotal {
    double total = 0.0;
    for (final c in _amountControllers) {
      final clean = c.text.replaceAll(",", "").trim();
      total += double.tryParse(clean) ?? 0.0;
    }
    return total;
  }

  double get _remainingAmount => _totalBill - _allocatedTotal;

  double get _totalPercentage {
    double total = 0.0;
    for (final c in _percentageControllers) {
      total += double.tryParse(c.text.trim()) ?? 0.0;
    }
    return total;
  }

  void _onAmountChanged(int index, String val) {
    final clean = val.replaceAll(",", "").trim();
    final amt = double.tryParse(clean) ?? 0.0;
    final pct = _totalBill > 0 ? (amt / _totalBill) * 100.0 : 0.0;
    _percentageControllers[index].text = pct.toStringAsFixed(1);
    setState(() {});
  }

  void _onPercentageChanged(int index, String val) {
    final pct = double.tryParse(val.trim()) ?? 0.0;
    final amt = (_totalBill * pct) / 100.0;
    _amountControllers[index].text = CurrencyFormatter.format(amt).replaceFirst("₦", "").trim();
    setState(() {});
  }

  void _distributeRemainingEvenly() {
    final rem = _remainingAmount;
    if (_participants.isEmpty || rem == 0) return;
    final extraPerPerson = rem / _participants.length;

    for (int i = 0; i < _participants.length; i++) {
      final cur = double.tryParse(_amountControllers[i].text.replaceAll(",", "").trim()) ?? 0.0;
      final newAmt = cur + extraPerPerson;
      _amountControllers[i].text = CurrencyFormatter.format(newAmt).replaceFirst("₦", "").trim();
      final pct = _totalBill > 0 ? (newAmt / _totalBill) * 100.0 : 0.0;
      _percentageControllers[i].text = pct.toStringAsFixed(1);
    }
    setState(() {});
  }

  void _autoBalancePercentage() {
    final curTotal = _totalPercentage;
    final remPct = 100.0 - curTotal;
    if (_participants.isEmpty || remPct.abs() < 0.1) return;
    final addPerPerson = remPct / _participants.length;

    for (int i = 0; i < _participants.length; i++) {
      final cur = double.tryParse(_percentageControllers[i].text.trim()) ?? 0.0;
      final newPct = (cur + addPerPerson).clamp(0.0, 100.0);
      _percentageControllers[i].text = newPct.toStringAsFixed(1);
      final amt = (_totalBill * newPct) / 100.0;
      _amountControllers[i].text = CurrencyFormatter.format(amt).replaceFirst("₦", "").trim();
    }
    setState(() {});
  }

  void _addParticipant(SplitParticipant p) {
    setState(() {
      _participants.add(p);
      _amountControllers.add(TextEditingController());
      _percentageControllers.add(TextEditingController());
    });
    ref.read(splitDraftProvider.notifier).setParticipants(_participants);
    _recalculateAllocation();
  }

  void _removeParticipant(int index) {
    if (_participants.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A split bill requires at least 2 participants")),
      );
      return;
    }
    setState(() {
      _amountControllers[index].dispose();
      _percentageControllers[index].dispose();
      _amountControllers.removeAt(index);
      _percentageControllers.removeAt(index);
      _participants.removeAt(index);
    });
    ref.read(splitDraftProvider.notifier).setParticipants(_participants);
    _recalculateAllocation();
  }

  void _openAddParticipantModal() {
    AddSplitParticipantSheet.show(
      context: context,
      currentParticipants: _participants,
      onParticipantAdded: _addParticipant,
    );
  }

  void _confirmAndCreate() {
    final draft = ref.read(splitDraftProvider);
    final notifier = ref.read(splitBillProvider.notifier);

    // Build final participants list
    final List<SplitParticipant> finalList = [];
    for (int i = 0; i < _participants.length; i++) {
      final clean = _amountControllers[i].text.replaceAll(",", "").trim();
      final allocated = double.tryParse(clean) ?? 0.0;
      final pct = double.tryParse(_percentageControllers[i].text.trim()) ?? 0.0;
      final original = _participants[i];

      finalList.add(original.copyWith(
        amount: allocated,
        percentage: pct,
        status: original.isYou ? ParticipantSplitStatus.paid : ParticipantSplitStatus.pending,
        paidAt: original.isYou ? "Just now" : null,
      ));
    }

    final newBill = SplitBillItem(
      id: "sb_${DateTime.now().millisecondsSinceEpoch}",
      title: draft.title.isNotEmpty ? draft.title : "Dinner & Hangout",
      category: draft.category.isNotEmpty ? draft.category : "Dining",
      merchantName: draft.merchantResolvedName.isNotEmpty ? draft.merchantResolvedName : "RSVP Restaurant Lagos",
      merchantBank: draft.merchantBank,
      merchantAccount: draft.merchantAccount,
      totalAmount: _totalBill,
      date: "Just now",
      note: draft.note,
      status: "Active",
      isCreatedByYou: true,
      participants: finalList,
    );

    notifier.addBill(newBill);
    ref.read(splitDraftProvider.notifier).reset();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2ED573),
        content: Text(
          "Split Bill '${newBill.title}' created and requests sent to all friends!",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );

    context.pushReplacementNamed(AppRouter.splitBillDetailScreen);
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(splitDraftProvider);

    final isAmountBalanced = _remainingAmount.abs() < 1.0;
    final isPercentageBalanced = (_totalPercentage - 100.0).abs() < 0.5;
    final canProceed = (_mode == SplitAllocationMode.equal) ||
        (_mode == SplitAllocationMode.customAmount && isAmountBalanced) ||
        (_mode == SplitAllocationMode.percentage && isPercentageBalanced);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0D0C0A) : const Color(0xFFFAF7F2);
    final buttonBg = isDark ? const Color(0xFF1E1D1A) : const Color(0xFFEDE4D4);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E1A14);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              decoration: BoxDecoration(
                color: buttonBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: textPrimary,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          "Split Allocation",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill Overview Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF171512),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      color: Color(0xFFE5A93C),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          draft.title.isNotEmpty ? draft.title : "Weekend Hangout Bill",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "${draft.merchantResolvedName.isNotEmpty ? draft.merchantResolvedName : 'Merchant'} • ${draft.merchantBank}",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(_totalBill),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFE5A93C),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Mode Selector: Equal, Manual Figure, Percentage
            Text(
              "How would you like to split?",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1815),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  _buildModeTab("Split Equally", SplitAllocationMode.equal),
                  _buildModeTab("Manual Figure", SplitAllocationMode.customAmount),
                  _buildModeTab("Percentage", SplitAllocationMode.percentage),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Live Balance / Validation Banner
            if (_mode == SplitAllocationMode.customAmount) ...[
              _buildAmountBalanceCard(isAmountBalanced),
              const SizedBox(height: 16),
            ] else if (_mode == SplitAllocationMode.percentage) ...[
              _buildPercentageBalanceCard(isPercentageBalanced),
              const SizedBox(height: 16),
            ],

            // Participants Header + Add Friend Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Participants (${_participants.length})",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: _openAddParticipantModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person_add_rounded, size: 14, color: Color(0xFFE5A93C)),
                        const SizedBox(width: 4),
                        Text(
                          "Add Friend",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE5A93C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Allocation Cards per Participant
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _participants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final p = _participants[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF171512),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: p.isYou
                          ? const Color(0xFFE5A93C).withValues(alpha: 0.4)
                          : Colors.white10,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: p.avatarColor,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              p.avatarInitial.isNotEmpty ? p.avatarInitial : p.name[0],
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        p.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (p.isYou) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          "You",
                                          style: GoogleFonts.inter(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFE5A93C),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  p.username.isNotEmpty ? p.username : (p.phone.isNotEmpty ? p.phone : "Participant"),
                                  style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white54),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Remove button (for non-creator)
                          if (!p.isYou && _participants.length > 2)
                            GestureDetector(
                              onTap: () => _removeParticipant(index),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                                child: const Icon(Icons.close_rounded, size: 14, color: Colors.white60),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Input based on Mode
                      if (_mode == SplitAllocationMode.equal) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Equal Share (${(100.0 / _participants.length).toStringAsFixed(1)}%)",
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
                              ),
                              Text(
                                CurrencyFormatter.format(_totalBill / _participants.length),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFE5A93C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (_mode == SplitAllocationMode.customAmount) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF221F18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "₦",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFE5A93C),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _amountControllers[index],
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "0.00",
                                    hintStyle: GoogleFonts.inter(color: Colors.white24),
                                    border: InputBorder.none,
                                    suffixText: "${_percentageControllers[index].text}%",
                                    suffixStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 12),
                                  ),
                                  onChanged: (val) => _onAmountChanged(index, val),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Percentage Mode
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF221F18),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _percentageControllers[index],
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: "0",
                                          hintStyle: TextStyle(color: Colors.white24),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (val) => _onPercentageChanged(index, val),
                                      ),
                                    ),
                                    Text(
                                      "%",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFE5A93C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "₦${_amountControllers[index].text}",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Confirm & Send Split Requests Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canProceed ? const Color(0xFFE5A93C) : Colors.white12,
                  foregroundColor: canProceed ? Colors.black : Colors.white38,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: canProceed ? _confirmAndCreate : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Confirm & Send Split Requests",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.send_rounded, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildModeTab(String label, SplitAllocationMode targetMode) {
    final isSelected = _mode == targetMode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _mode = targetMode);
          _recalculateAllocation();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE5A93C) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? Colors.black : Colors.white70,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountBalanceCard(bool isBalanced) {
    final rem = _remainingAmount;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isBalanced
            ? const Color(0xFF2ED573).withValues(alpha: 0.12)
            : (rem > 0 ? const Color(0xFFE5A93C).withValues(alpha: 0.12) : const Color(0xFFFF4757).withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isBalanced
              ? const Color(0xFF2ED573).withValues(alpha: 0.4)
              : (rem > 0 ? const Color(0xFFE5A93C).withValues(alpha: 0.4) : const Color(0xFFFF4757).withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isBalanced ? Icons.check_circle_rounded : (rem > 0 ? Icons.error_outline_rounded : Icons.warning_rounded),
            color: isBalanced ? const Color(0xFF2ED573) : (rem > 0 ? const Color(0xFFE5A93C) : const Color(0xFFFF4757)),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBalanced
                      ? "Allocations Balanced (100%)"
                      : (rem > 0 ? "${CurrencyFormatter.format(rem)} Remaining" : "Over-allocated by ${CurrencyFormatter.format(rem.abs())}"),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isBalanced ? const Color(0xFF2ED573) : (rem > 0 ? const Color(0xFFE5A93C) : const Color(0xFFFF4757)),
                  ),
                ),
                Text(
                  isBalanced
                      ? "Total ${CurrencyFormatter.format(_allocatedTotal)} matches bill amount perfectly."
                      : "Total must equal ${CurrencyFormatter.format(_totalBill)} to continue.",
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.white60),
                ),
              ],
            ),
          ),
          if (!isBalanced && rem > 0)
            GestureDetector(
              onTap: _distributeRemainingEvenly,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5A93C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Auto-Balance",
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPercentageBalanceCard(bool isBalanced) {
    final curTotal = _totalPercentage;
    final diff = 100.0 - curTotal;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isBalanced
            ? const Color(0xFF2ED573).withValues(alpha: 0.12)
            : const Color(0xFFE5A93C).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isBalanced
              ? const Color(0xFF2ED573).withValues(alpha: 0.4)
              : const Color(0xFFE5A93C).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isBalanced ? Icons.check_circle_rounded : Icons.info_outline_rounded,
            color: isBalanced ? const Color(0xFF2ED573) : const Color(0xFFE5A93C),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBalanced
                      ? "100% Total Allocated"
                      : "Total: ${curTotal.toStringAsFixed(1)}% (${diff > 0 ? '${diff.toStringAsFixed(1)}% remaining' : 'exceeds by ${(-diff).toStringAsFixed(1)}%'})",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isBalanced ? const Color(0xFF2ED573) : const Color(0xFFE5A93C),
                  ),
                ),
                Text(
                  isBalanced ? "Percentages add up to 100%." : "Adjust shares until total reaches exactly 100%.",
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.white60),
                ),
              ],
            ),
          ),
          if (!isBalanced)
            GestureDetector(
              onTap: _autoBalancePercentage,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5A93C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Auto 100%",
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
