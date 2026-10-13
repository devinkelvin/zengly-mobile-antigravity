import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/widgets.dart';
import 'ajo_group_details_screen.dart';
import 'ajo_models.dart';

class JoinAjoGroupScreen extends StatefulWidget {
  const JoinAjoGroupScreen({super.key});

  @override
  State<JoinAjoGroupScreen> createState() => _JoinAjoGroupScreenState();
}

class _JoinAjoGroupScreenState extends State<JoinAjoGroupScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  AjoGroup? _foundGroup;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _searchCode() {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Code Required",
        message: "Please enter an invitation code.",
        toastType: ToastificationType.warning,
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _foundGroup = AjoGroup(
          id: "ajo-invite-1",
          name: "Lagos Tech Founders Ajo",
          category: "Investment Club",
          contributionAmount: 100000,
          frequency: "Monthly",
          totalMembers: 10,
          currentRound: 3,
          totalPool: 1000000,
          nextPayoutDate: "Nov 15, 2026",
          myPosition: 7,
          members: [
            const AjoMember(id: "1", name: "Femi Adeleke (Host)", position: 1, status: MemberPaymentStatus.paidOut, payoutDate: "Sep 15, 2026"),
            const AjoMember(id: "2", name: "Sandra Eze", position: 2, status: MemberPaymentStatus.paidOut, payoutDate: "Oct 15, 2026"),
            const AjoMember(id: "3", name: "Bolaji K.", position: 3, status: MemberPaymentStatus.paid, payoutDate: "Nov 15, 2026"),
            const AjoMember(id: "4", name: "Amaka O.", position: 4, status: MemberPaymentStatus.pending, payoutDate: "Dec 15, 2026"),
            const AjoMember(id: "5", name: "Kayode S.", position: 5, status: MemberPaymentStatus.pending, payoutDate: "Jan 15, 2027"),
            const AjoMember(id: "6", name: "Tariq B.", position: 6, status: MemberPaymentStatus.pending, payoutDate: "Feb 15, 2027"),
            const AjoMember(id: "7", name: "Available Slot (You)", position: 7, status: MemberPaymentStatus.pending, payoutDate: "Mar 15, 2027", isMe: true),
          ],
        );
      });
    });
  }

  void _confirmJoin() {
    if (_foundGroup == null) return;
    AppOverlays.showToast(
      context: context,
      title: "Joined Successfully!",
      message: "You have joined '${_foundGroup!.name}'. Payout slot #7 reserved.",
      toastType: ToastificationType.success,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AjoGroupDetailsScreen(group: _foundGroup!),
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
          "Join Ajo Group",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Group Invitation Code",
              style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              "Paste the code shared by your group organizer to verify group details and join.",
              style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
            ),
            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: "e.g. AJO-LAG-2026",
                      hintStyle: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: borderColor)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: borderColor)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: primaryColor, width: 1.5)),
                    ),
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1, color: textPrimary),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : _searchCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text("Find", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (_foundGroup != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF382709), const Color(0xFF1E1810)]
                        : [const Color(0xFFFBF4E8), const Color(0xFFF3E7D3)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _foundGroup!.name,
                          style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(100)),
                          child: Text("Active", style: GoogleFonts.inter(fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Contribution", style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                        Text("₦100,000 / ${_foundGroup!.frequency}", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Cycle Payout", style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                        Text("₦1,000,000", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: primaryColor)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Available Slot", style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                        Text("Position #7 (Payout: Mar 15, 2027)", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF34C759))),
                      ],
                    ),
                    const SizedBox(height: 18),
                    AppButton(
                      actionText: "Confirm & Join Group",
                      borderRadius: 100,
                      onPressed: _confirmJoin,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
