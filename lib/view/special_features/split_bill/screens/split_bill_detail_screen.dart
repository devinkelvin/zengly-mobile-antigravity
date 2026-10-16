import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../split_bill_vm.dart';

class SplitBillDetailScreen extends ConsumerStatefulWidget {
  const SplitBillDetailScreen({super.key});

  @override
  ConsumerState<SplitBillDetailScreen> createState() =>
      _SplitBillDetailScreenState();
}

class _SplitBillDetailScreenState extends ConsumerState<SplitBillDetailScreen> {
  String _selectedFilter = "All";

  void _remindParticipant(SplitBillItem bill, SplitParticipant participant) {
    HapticFeedback.lightImpact();
    ref.read(splitBillProvider.notifier).nudgeParticipant(bill.id, participant.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFE5A93C),
        content: Text(
          "Payment reminder sent to ${participant.name} via Zengly notification & SMS!",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }

  void _remindAllPending(SplitBillItem bill) {
    HapticFeedback.mediumImpact();
    final pendingCount = bill.pendingCount + bill.overdueCount;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFE5A93C),
        content: Text(
          "Reminders sent to all $pendingCount pending and overdue friends!",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }

  Future<void> _payYourShare(SplitBillItem bill) async {
    HapticFeedback.lightImpact();
    final you = bill.youParticipant;
    if (you == null) return;

    final pinVerified = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TransactionPinBottomSheet(),
    );

    if (pinVerified == true && mounted) {
      ref.read(splitBillProvider.notifier).payYourShare(bill.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF2ED573),
          content: Text(
            "Your share of ${CurrencyFormatter.format(you.amount)} paid successfully!",
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
      );
    }
  }

  void _markPaidManually(String billId, SplitParticipant participant) {
    ref.read(splitBillProvider.notifier).markParticipantPaid(billId, participant.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2ED573),
        content: Text(
          "${participant.name}'s share marked as settled!",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }

  void _openDeclineReasonDialog(SplitBillItem bill, SplitParticipant you) {
    final reasonCtrl = TextEditingController(text: "Not my bill - did not participate");
    final reasons = [
      "Not my bill - did not participate",
      "I only ordered drinks / appetizers",
      "Incorrect share amount calculated",
      "Already paid cash directly to merchant",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16140F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Decline Split Request",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFF4757),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Please state why you are rejecting your share of ${CurrencyFormatter.format(you.amount)}:",
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 14),
                  // Preset Reasons
                  ...reasons.map((r) {
                    final isSelected = reasonCtrl.text == r;
                    return InkWell(
                      onTap: () => setModalState(() => reasonCtrl.text = r),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFF4757).withValues(alpha: 0.15)
                              : const Color(0xFF221F18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFF4757) : Colors.white10,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              size: 16,
                              color: isSelected ? const Color(0xFFFF4757) : Colors.white38,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                r,
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4757),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ref.read(splitBillProvider.notifier).markParticipantDeclined(
                              bill.id,
                              you.id,
                              reasonCtrl.text.trim(),
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Color(0xFFFF4757),
                            content: Text("Split request declined. Creator notified."),
                          ),
                        );
                      },
                      child: Text(
                        "Confirm Decline",
                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleDeclinedAction(SplitBillItem bill, SplitParticipant p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16140F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.cancel_outlined, color: Color(0xFFFF4757), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    "Resolve ${p.name}'s Declined Share",
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Reason given: \"${p.statusReason ?? 'Declined by friend'}\"",
                style: GoogleFonts.inter(fontSize: 12.5, fontStyle: FontStyle.italic, color: Colors.white70),
              ),
              const SizedBox(height: 20),

              // Option 1: Cover Share
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFE5A93C).withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.shield_outlined, color: Color(0xFFE5A93C), size: 20),
                ),
                title: Text("Cover Share Myself", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                subtitle: Text("Absorb ${CurrencyFormatter.format(p.amount)} into your share as creator", style: GoogleFonts.inter(fontSize: 11, color: Colors.white54)),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(splitBillProvider.notifier).coverDeclinedShare(bill.id, p.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Covered ${p.name}'s share of ${CurrencyFormatter.format(p.amount)}")),
                  );
                },
              ),
              const Divider(color: Colors.white10),

              // Option 2: Reassign evenly among active participants
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF00B894).withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.replay_rounded, color: Color(0xFF00B894), size: 20),
                ),
                title: Text("Reassign Evenly", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                subtitle: Text("Distribute ${CurrencyFormatter.format(p.amount)} equally among remaining active friends", style: GoogleFonts.inter(fontSize: 11, color: Colors.white54)),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(splitBillProvider.notifier).reassignDeclinedShare(bill.id, p.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${p.name}'s share redistributed among active participants")),
                  );
                },
              ),
              const Divider(color: Colors.white10),

              // Option 3: Mark Paid Manually
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF2ED573).withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_outline, color: Color(0xFF2ED573), size: 20),
                ),
                title: Text("Mark as Settled Manually", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                subtitle: Text("Friend paid via cash or alternative bank transfer", style: GoogleFonts.inter(fontSize: 11, color: Colors.white54)),
                onTap: () {
                  Navigator.pop(ctx);
                  _markPaidManually(bill.id, p);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareBillLink(SplitBillItem bill) {
    Clipboard.setData(ClipboardData(text: "https://zengly.app/split/${bill.id}"));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFE5A93C),
        content: Text(
          "Split bill invite link copied to clipboard!",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final splitState = ref.watch(splitBillProvider);
    final bill = splitState.activeBill ?? splitState.bills.first;
    final you = bill.youParticipant;
    final youOweShare = you != null && !you.isPaid && !you.isDeclined;

    // Filter participants
    final filteredParticipants = bill.participants.where((p) {
      if (_selectedFilter == "Paid") return p.isPaid;
      if (_selectedFilter == "Pending") return p.isPending;
      if (_selectedFilter == "Overdue") return p.isOverdue;
      if (_selectedFilter == "Declined") return p.isDeclined;
      return true;
    }).toList();

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
          "Bill Details",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _shareBillLink(bill),
            icon: Icon(Icons.share_outlined, color: textPrimary, size: 20),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Status Overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF241F18),
                    Color(0xFF16140F),
                  ],
                ),
                border: Border.all(
                  color: bill.status == "Action Required"
                      ? const Color(0xFFFF4757).withValues(alpha: 0.5)
                      : (bill.status == "Completed"
                          ? const Color(0xFF2ED573).withValues(alpha: 0.4)
                          : const Color(0xFFE5A93C).withValues(alpha: 0.3)),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          bill.category.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: const Color(0xFFE5A93C),
                          ),
                        ),
                      ),
                      _buildStatusPill(bill.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bill.title,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.account_balance_rounded, size: 14, color: Colors.white54),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${bill.merchantName} • ${bill.merchantBank} (${bill.merchantAccount})",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Bill Amount",
                            style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white54),
                          ),
                          Text(
                            CurrencyFormatter.format(bill.totalAmount),
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Settled So Far",
                            style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white54),
                          ),
                          Text(
                            CurrencyFormatter.format(bill.paidAmount),
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF2ED573),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: bill.progress,
                      minHeight: 7,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        bill.progress == 1.0 ? const Color(0xFF2ED573) : const Color(0xFFE5A93C),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "${bill.paidCount} of ${bill.participantsCount} friends paid (${(bill.progress * 100).toInt()}%)",
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.white60),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (bill.pendingAmount > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          "${CurrencyFormatter.format(bill.pendingAmount)} remaining",
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFFE5A93C)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Filter Tabs for All Statuses: All, Paid, Pending, Overdue, Declined
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterTab("All", bill.participantsCount),
                  const SizedBox(width: 8),
                  _buildFilterTab("Paid", bill.paidCount, badgeColor: const Color(0xFF2ED573)),
                  const SizedBox(width: 8),
                  _buildFilterTab("Pending", bill.pendingCount, badgeColor: const Color(0xFFE5A93C)),
                  if (bill.overdueCount > 0) ...[
                    const SizedBox(width: 8),
                    _buildFilterTab("Overdue", bill.overdueCount, badgeColor: const Color(0xFFFF9F43)),
                  ],
                  if (bill.declinedCount > 0) ...[
                    const SizedBox(width: 8),
                    _buildFilterTab("Declined", bill.declinedCount, badgeColor: const Color(0xFFFF4757)),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Participants List Header + Quick Nudge All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Participants (${filteredParticipants.length})",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if ((bill.pendingCount + bill.overdueCount) > 0 && bill.isCreatedByYou)
                  GestureDetector(
                    onTap: () => _remindAllPending(bill),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active_outlined, size: 14, color: Color(0xFFE5A93C)),
                        const SizedBox(width: 4),
                        Text(
                          "Nudge All Pending",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE5A93C),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Participants Cards Handling ALL 4 Status Use Cases
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredParticipants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final p = filteredParticipants[index];
                return _buildParticipantTile(bill, p);
              },
            ),

            const SizedBox(height: 24),

            // Additional Bill Notes Card
            if (bill.note.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF171512),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notes_rounded, size: 16, color: Color(0xFFE5A93C)),
                        const SizedBox(width: 6),
                        Text(
                          "Split Notes",
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bill.note,
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.white60),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Floating Bottom Pay Share / Decline for "You" if unpaid
            if (youOweShare) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1815),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE5A93C)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bill.isCreatedByYou ? "Your Share as Bill Creator" : "Your Share of this Bill",
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.white60),
                            ),
                            Text(
                              CurrencyFormatter.format(you.amount),
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFE5A93C),
                              ),
                            ),
                          ],
                        ),
                        if (bill.isCreatedByYou)
                          TextButton(
                            onPressed: () => _markPaidManually(bill.id, you),
                            child: Text(
                              "I Settled Directly",
                              style: GoogleFonts.inter(color: const Color(0xFFE5A93C), fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          )
                        else
                          TextButton(
                            onPressed: () => _openDeclineReasonDialog(bill, you),
                            child: Text(
                              "Decline Request",
                              style: GoogleFonts.inter(color: const Color(0xFFFF4757), fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE5A93C),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        onPressed: () => _payYourShare(bill),
                        child: Text(
                          bill.isCreatedByYou
                              ? "Pay Creator Share (${CurrencyFormatter.format(you.amount)})"
                              : "Pay My Share (${CurrencyFormatter.format(you.amount)})",
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label, int count, {Color? badgeColor}) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE5A93C) : const Color(0xFF171512),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? const Color(0xFFE5A93C) : Colors.white10,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.black : Colors.white70,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.black.withValues(alpha: 0.15)
                    : (badgeColor?.withValues(alpha: 0.2) ?? Colors.white10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count",
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.black : (badgeColor ?? Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantTile(SplitBillItem bill, SplitParticipant p) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF171512),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: p.isDeclined
              ? const Color(0xFFFF4757).withValues(alpha: 0.3)
              : (p.isOverdue
                  ? const Color(0xFFFF9F43).withValues(alpha: 0.3)
                  : (p.isPaid ? const Color(0xFF2ED573).withValues(alpha: 0.2) : Colors.white10)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: p.avatarColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  p.avatarInitial.isNotEmpty ? p.avatarInitial : p.name[0],
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),

              // Name + Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            p.name,
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
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
                    const SizedBox(height: 2),
                    Text(
                      p.bankName != null && p.accountNumber != null
                          ? "${p.username.isNotEmpty ? '${p.username} • ' : ''}${p.bankName} (${p.accountNumber})"
                          : (p.username.isNotEmpty ? p.username : (p.phone.isNotEmpty ? p.phone : "Member")),
                      style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Amount & Status Badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(p.amount),
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: p.isPaid ? const Color(0xFF2ED573) : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildParticipantStatusBadge(p),
                ],
              ),
            ],
          ),

          // Declined reason banner + Action buttons (Case 4: Rejected split request)
          if (p.isDeclined) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF4757).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFF4757).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFFF4757)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Reason: \"${p.statusReason ?? 'Declined by friend'}\"",
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFFF4757), fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            if (bill.isCreatedByYou) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => _handleDeclinedAction(bill, p),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5A93C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Resolve Declined Share",
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ] else if (p.isOverdue) ...[
            // Case 3: Overdue / Did not pay
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    p.statusReason ?? "3 days past due date",
                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFFFF9F43), fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!p.isYou && bill.isCreatedByYou)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _markPaidManually(bill.id, p),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
                          child: Text("Mark Paid", style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _remindParticipant(bill, p),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9F43).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text("Urgent Nudge", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFFF9F43))),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ] else if (p.isYou && !p.isPaid) ...[
            // Case: You (creator or participant) have an unpaid share
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    bill.isCreatedByYou ? "Your share as bill creator" : "Your share (pending payment)",
                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFFE5A93C), fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (bill.isCreatedByYou) ...[
                      GestureDetector(
                        onTap: () => _markPaidManually(bill.id, p),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
                          child: Text("Paid Offline", style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    GestureDetector(
                      onTap: () => _payYourShare(bill),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5A93C),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("Pay Now", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ] else if (p.isPending && !p.isYou && bill.isCreatedByYou) ...[
            // Case 2: Pending
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    p.reminderCount > 0 ? "Nudged ${p.reminderCount} time(s)" : "Awaiting response",
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _markPaidManually(bill.id, p),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(6)),
                        child: Text("Mark Paid", style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _remindParticipant(bill, p),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.notifications_active_outlined, size: 12, color: Color(0xFFE5A93C)),
                            const SizedBox(width: 4),
                            Text("Nudge", style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFE5A93C))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ] else if (p.isPaid) ...[
            // Case 1: Paid / Settled
            const SizedBox(height: 6),
            Text(
              p.paidAt != null ? "Settled • ${p.paidAt}" : "Settled in full via Zengly",
              style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF2ED573), fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildParticipantStatusBadge(SplitParticipant p) {
    if (p.isPaid) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF2ED573).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check, size: 11, color: Color(0xFF2ED573)),
            const SizedBox(width: 4),
            Text("Settled", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF2ED573))),
          ],
        ),
      );
    }
    if (p.isDeclined) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFF4757).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text("Declined", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFFF4757))),
      );
    }
    if (p.isOverdue) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9F43).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text("Overdue", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFFF9F43))),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text("Pending", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFE5A93C))),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bg = const Color(0xFFE5A93C).withValues(alpha: 0.15);
    Color fg = const Color(0xFFE5A93C);

    if (status == "Completed") {
      bg = const Color(0xFF2ED573).withValues(alpha: 0.15);
      fg = const Color(0xFF2ED573);
    } else if (status == "Action Required") {
      bg = const Color(0xFFFF4757).withValues(alpha: 0.15);
      fg = const Color(0xFFFF4757);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
