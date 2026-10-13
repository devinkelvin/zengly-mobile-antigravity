import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/widgets.dart';
import 'ajo_models.dart';

class AjoGroupDetailsScreen extends StatefulWidget {
  final AjoGroup group;

  const AjoGroupDetailsScreen({super.key, required this.group});

  @override
  State<AjoGroupDetailsScreen> createState() => _AjoGroupDetailsScreenState();
}

class _AjoGroupDetailsScreenState extends State<AjoGroupDetailsScreen> {
  late bool _hasPaidCurrentRound;

  @override
  void initState() {
    super.initState();
    _hasPaidCurrentRound = false;
  }

  void _showContributionPaymentSheet() {
    final currencyFormat = NumberFormat.currency(symbol: "₦", decimalDigits: 2);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1A17) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E2A24) : const Color(0xFFE2D6C5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Confirm Contribution",
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.group.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF26211A) : const Color(0xFFF7F3EB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF382F22) : const Color(0xFFE8DFC0),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Amount Due",
                    style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.scrim),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(widget.group.contributionAmount),
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment Source", style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.scrim)),
                      Text("Zengly Wallet (₦2,000,000.00)", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Current Cycle", style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.scrim)),
                      Text("Round ${widget.group.currentRound} of ${widget.group.totalMembers}", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Processing Fee", style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.scrim)),
                      Text("₦0.00 (Free)", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF34C759))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              actionText: "Authorize Payment",
              borderRadius: 100,
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() => _hasPaidCurrentRound = true);
                AppOverlays.showToast(
                  context: context,
                  title: "Contribution Successful",
                  message: "Your ${currencyFormat.format(widget.group.contributionAmount)} contribution for Round ${widget.group.currentRound} is confirmed!",
                  toastType: ToastificationType.success,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showInviteSheet() {
    final inviteCode = "AJO-${widget.group.name.substring(0, 3).toUpperCase()}-2026";
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1A17) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E2A24) : const Color(0xFFE2D6C5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Invite Members to ${widget.group.name}",
              style: GoogleFonts.raleway(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              "Share your unique group code. Verified Zengly users can enter this code to join your savings circle.",
              style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.scrim),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252018) : const Color(0xFFF8F4EC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    inviteCode,
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: primaryColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy_rounded, color: primaryColor, size: 20),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: inviteCode));
                      Navigator.of(ctx).pop();
                      AppOverlays.showToast(
                        context: context,
                        title: "Copied!",
                        message: "Group invitation code copied to clipboard.",
                        toastType: ToastificationType.success,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final currencyFormat = NumberFormat.currency(symbol: "₦", decimalDigits: 0);

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
          widget.group.name,
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded, color: textPrimary, size: 20),
            onPressed: _showInviteSheet,
          ),
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: textPrimary, size: 20),
            onPressed: () {
              AppOverlays.showToast(
                context: context,
                title: "Ajo 2.0 Security",
                message: "Payouts are automated via escrow smart rules. Defaulter protection is active.",
                toastType: ToastificationType.info,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cycle Pool Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF382709), const Color(0xFF1E1810)]
                      : [const Color(0xFFFBF4E8), const Color(0xFFF3E7D3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: primaryColor.withValues(alpha: 0.35)),
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
                          color: primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "${widget.group.category} • ${widget.group.frequency}",
                          style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: primaryColor),
                        ),
                      ),
                      Text(
                        "Round ${widget.group.currentRound}/${widget.group.totalMembers}",
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Total Cycle Pool",
                    style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    currencyFormat.format(widget.group.totalPool),
                    style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                  const SizedBox(height: 14),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: widget.group.currentRound / widget.group.totalMembers,
                      minHeight: 8,
                      backgroundColor: isDark ? const Color(0xFF2C2419) : const Color(0xFFE2D6C5),
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Payout Position: #${widget.group.myPosition}",
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: textPrimary),
                      ),
                      Text(
                        "Next: ${widget.group.nextPayoutDate}",
                        style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w500, color: primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contribution Action Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _hasPaidCurrentRound ? "Current Round Paid" : "Contribution Pending",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _hasPaidCurrentRound ? const Color(0xFF34C759) : const Color(0xFFFF9500),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _hasPaidCurrentRound
                              ? "You've fulfilled your ${currencyFormat.format(widget.group.contributionAmount)} obligation."
                              : "${currencyFormat.format(widget.group.contributionAmount)} due before next rotation.",
                          style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _hasPaidCurrentRound ? null : _showContributionPaymentSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      disabledBackgroundColor: isDark ? const Color(0xFF2A241A) : const Color(0xFFEFECE5),
                      foregroundColor: Colors.white,
                      disabledForegroundColor: textSecondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text(
                      _hasPaidCurrentRound ? "Paid ✓" : "Pay Now",
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Member Payout Roster
            Text(
              "Rotation Schedule (${widget.group.members.length} Members)",
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.group.members.length,
              separatorBuilder: (context, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final member = widget.group.members[index];
                Color statusColor;
                String statusLabel;

                switch (member.status) {
                  case MemberPaymentStatus.paidOut:
                    statusColor = const Color(0xFF34C759);
                    statusLabel = "Payout Received";
                    break;
                  case MemberPaymentStatus.paid:
                    statusColor = primaryColor;
                    statusLabel = "Active • Ready";
                    break;
                  case MemberPaymentStatus.pending:
                    statusColor = textSecondary;
                    statusLabel = "Scheduled";
                    break;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: member.isMe
                        ? (isDark ? const Color(0xFF2A2215) : const Color(0xFFFAF4EA))
                        : (isDark ? const Color(0xFF1E1A14) : Colors.white),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: member.isMe
                          ? primaryColor.withValues(alpha: 0.5)
                          : (isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: member.status == MemberPaymentStatus.paidOut
                              ? const Color(0xFF34C759).withValues(alpha: 0.15)
                              : primaryColor.withValues(alpha: 0.15),
                        ),
                        child: Text(
                          "${member.position}",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: member.status == MemberPaymentStatus.paidOut
                                ? const Color(0xFF34C759)
                                : primaryColor,
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
                                Text(
                                  member.name,
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                                ),
                                if (member.isMe) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Text(
                                      "YOU",
                                      style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Payout Date: ${member.payoutDate}",
                              style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        statusLabel,
                        style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w700, color: statusColor),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
