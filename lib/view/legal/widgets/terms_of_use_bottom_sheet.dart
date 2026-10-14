import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsOfUseBottomSheet extends StatelessWidget {
  final VoidCallback? onAccept;

  const TermsOfUseBottomSheet({super.key, this.onAccept});

  static Future<bool?> show(BuildContext context, {VoidCallback? onAccept}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TermsOfUseBottomSheet(onAccept: onAccept),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFFB0B0B0) : const Color(0xFF6B655D);

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : const Color(0xFFD6CEBF),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Header: Close 'X' button on left, centered "Term of use"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close_rounded, size: 20, color: textPrimary),
                    ),
                  ),
                ),
                Text(
                  "Term of use",
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),

          // Scrollable Terms Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: "1. Wallet Funds and Usage",
                    content:
                        "By creating a wallet within this application, you acknowledge and agree that all funds deposited into the wallet are strictly intended for use within the platform. Such funds shall not be withdrawn, transferred, or otherwise utilized outside the app, whether electronically, physically, or by any other means. The wallet is intended solely as a medium to facilitate transactions, purchases, or services available through the app.",
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    title: "2. Failed or Reversed Transactions",
                    content:
                        "In the event that a debit is processed on a payment card or other linked financial instrument and such transaction fails or is declined, the amount in question shall be automatically credited back to your wallet. The platform shall not be held liable for any delay or failure in the reversal of funds due to circumstances beyond its reasonable control, including banking system delays.",
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    title: "3. Limitation of Liability",
                    content:
                        "The wallet, its operation, and the funds therein are provided on an “as is” basis. The platform disclaims any liability for indirect, incidental, or consequential losses arising from wallet usage, including but not limited to failed transactions, technical errors, or unauthorized access, except as expressly provided by law.",
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    title: "4. User Responsibilities",
                    content:
                        "You agree to maintain the confidentiality of your wallet credentials and shall not permit any third party to access or use your wallet without explicit authorization. You are solely responsible for all activity occurring under your account. The platform reserves the right to suspend, restrict, or terminate wallet access in cases of suspected fraud, misuse, or breach of these terms.",
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Sticky Bottom Red Button
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
            decoration: BoxDecoration(
              color: sheetBg,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white10 : Colors.black12,
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF3838), // Vibrant red matching Screenshot 3
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  if (onAccept != null) onAccept!();
                },
                child: Text(
                  "I Accept this Terms",
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.raleway(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
