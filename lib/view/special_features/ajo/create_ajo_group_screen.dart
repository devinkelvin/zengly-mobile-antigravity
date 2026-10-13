import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/widgets.dart';
import 'ajo_group_details_screen.dart';
import 'ajo_models.dart';

class CreateAjoGroupScreen extends StatefulWidget {
  const CreateAjoGroupScreen({super.key});

  @override
  State<CreateAjoGroupScreen> createState() => _CreateAjoGroupScreenState();
}

class _CreateAjoGroupScreenState extends State<CreateAjoGroupScreen> {
  final _nameController = TextEditingController();
  String _selectedCategory = "Friends & Family";
  double _contributionAmount = 50000;
  String _frequency = "Monthly";
  int _totalMembers = 5;
  bool _agreedToTerms = true;

  final List<String> _categories = [
    "Friends & Family",
    "Work Colleagues",
    "Business Savings",
    "Investment Club",
  ];

  final List<double> _amountPresets = [10000, 25000, 50000, 100000];
  final List<int> _memberPresets = [3, 5, 10, 12];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onCreateGroup() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Validation Error",
        message: "Please enter a name for your Ajo group.",
        toastType: ToastificationType.warning,
      );
      return;
    }

    if (!_agreedToTerms) {
      AppOverlays.showToast(
        context: context,
        title: "Agreement Required",
        message: "Please agree to the Ajo 2.0 automated escrow rules.",
        toastType: ToastificationType.warning,
      );
      return;
    }

    final totalPool = _contributionAmount * _totalMembers;

    // Create realistic mock members
    final members = List.generate(_totalMembers, (index) {
      final pos = index + 1;
      final isMe = pos == 1;
      return AjoMember(
        id: "member-$pos",
        name: isMe ? "You (Host)" : "Member $pos",
        position: pos,
        status: pos == 1 ? MemberPaymentStatus.paid : MemberPaymentStatus.pending,
        payoutDate: "Month $pos, 2026",
        isMe: isMe,
      );
    });

    final newGroup = AjoGroup(
      id: "ajo-${DateTime.now().millisecondsSinceEpoch}",
      name: name,
      category: _selectedCategory,
      contributionAmount: _contributionAmount,
      frequency: _frequency,
      totalMembers: _totalMembers,
      currentRound: 1,
      totalPool: totalPool,
      nextPayoutDate: "Nov 1, 2026",
      myPosition: 1,
      isCreator: true,
      members: members,
    );

    AppOverlays.showToast(
      context: context,
      title: "Group Created!",
      message: "Your Ajo group '$name' has been created successfully.",
      toastType: ToastificationType.success,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AjoGroupDetailsScreen(group: newGroup),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE);
    final currencyFormat = NumberFormat.currency(symbol: "₦", decimalDigits: 0);
    final totalPool = _contributionAmount * _totalMembers;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Create Ajo Group",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header summary
            Text(
              "Start a Rotating Savings Circle",
              style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              "Pool money with trusted members and take turns receiving lump-sum payouts.",
              style: GoogleFonts.inter(fontSize: 12, color: textSecondary, height: 1.35),
            ),
            const SizedBox(height: 18),

            // Group Name input
            Text("Group Name", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "e.g. Lagos Hustlers Club, Family Thrift",
                hintStyle: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: borderColor)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: borderColor)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: primaryColor, width: 1.5)),
              ),
              style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
            ),
            const SizedBox(height: 16),

            // Category Chips
            Text("Category", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : textPrimary,
                  ),
                  selectedColor: primaryColor,
                  backgroundColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
                  side: BorderSide(color: isSelected ? primaryColor : borderColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Contribution Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Contribution per Member", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
                Text(currencyFormat.format(_contributionAmount), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: primaryColor)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: _amountPresets.map((amount) {
                final isSelected = _contributionAmount == amount;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => setState(() => _contributionAmount = amount),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : (isDark ? const Color(0xFF1E1A14) : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? primaryColor : borderColor),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${(amount / 1000).toInt()}k",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Frequency and Total Members
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Frequency", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _frequency,
                            isExpanded: true,
                            dropdownColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
                            items: ["Weekly", "Bi-weekly", "Monthly"].map((f) {
                              return DropdownMenuItem(value: f, child: Text(f, style: GoogleFonts.inter(fontSize: 13, color: textPrimary)));
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _frequency = v);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Members", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _totalMembers,
                            isExpanded: true,
                            dropdownColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
                            items: _memberPresets.map((m) {
                              return DropdownMenuItem(value: m, child: Text("$m Members", style: GoogleFonts.inter(fontSize: 13, color: textPrimary)));
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _totalMembers = v);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Payout Pool Estimation Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF2C2210), const Color(0xFF1C1812)]
                      : [const Color(0xFFFAF2E4), const Color(0xFFF4EAD9)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Cycle Payout", style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
                      const SizedBox(height: 2),
                      Text(currencyFormat.format(totalPool), style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: primaryColor)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Each Member Receives", style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
                      const SizedBox(height: 2),
                      Text(currencyFormat.format(totalPool), style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Terms Checkbox
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  activeColor: primaryColor,
                  onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                ),
                Expanded(
                  child: Text(
                    "I agree to the Ajo 2.0 automated escrow rules and transparent rotation order.",
                    style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Submit Button
            AppButton(
              actionText: "Create Group (${currencyFormat.format(totalPool)} Pool)",
              borderRadius: 100,
              onPressed: _onCreateGroup,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
