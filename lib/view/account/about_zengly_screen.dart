import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../legal/legal_document_viewer_screen.dart';
import '../legal/models/legal_doc_model.dart';
import '../legal/widgets/terms_of_use_bottom_sheet.dart';

class AboutZenglyScreen extends StatelessWidget {
  const AboutZenglyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6B655D);
    final cardBg = isDark ? const Color(0xFF1E1A14) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEBE3D7);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "About Zengly",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Brand Logo & App Version
            Center(
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor.withValues(alpha: 0.4), width: 2),
                    ),
                    child: Center(
                      child: Text(
                        "Z",
                        style: GoogleFonts.raleway(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Zengly",
                    style: GoogleFonts.raleway(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Social-Finance & Lifestyle Mobile Application",
                    style: GoogleFonts.inter(fontSize: 13, color: textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      "Version 1.0.0 (Build 2026.10-MVP)",
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // OPERATOR & REGULATORY DISCLOSURE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance_rounded, size: 20, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        "Legal Operating Structure",
                        style: GoogleFonts.raleway(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Zengly is conceived, designed, and operated by Lynexa Innovations Ltd., a financial technology and software company incorporated under the laws of the Federal Republic of Nigeria.\n\nRegulated Financial Services Notice:\nLynexa Innovations Ltd. is a technology provider, not a licensed commercial deposit bank. All user custodial balances, virtual and physical debit cards, interbank settlement clearing, and Bank Verification Number (BVN) integrations are provided in partnership with duly authorized commercial and microfinance banking partners licensed by the Central Bank of Nigeria (CBN).",
                    style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // LEGAL & AGREEMENTS QUICK LINKS (INCLUDING SCREENSHOT 3 TERMS OF USE)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gavel_rounded, size: 20, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        "Legal & Agreements",
                        style: GoogleFonts.raleway(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.article_outlined, size: 20, color: primaryColor),
                    title: Text("Term of use", style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: textPrimary)),
                    subtitle: Text("Wallet funds, liabilities & responsibilities", style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => TermsOfUseBottomSheet.show(context),
                  ),
                  Divider(height: 12, color: borderColor),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.description_outlined, size: 20, color: primaryColor),
                    title: Text("Terms of Service", style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: textPrimary)),
                    subtitle: Text("Full comprehensive terms of service", style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LegalDocumentViewerScreen(
                            document: LegalRepository.termsOfService,
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(height: 12, color: borderColor),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.policy_outlined, size: 20, color: primaryColor),
                    title: Text("Privacy Policy", style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: textPrimary)),
                    subtitle: Text("Data processing under NDPA 2023", style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LegalDocumentViewerScreen(
                            document: LegalRepository.privacyPolicy,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // SECURITY & DATA PROTECTION CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.security_rounded, size: 20, color: const Color(0xFF34C759)),
                      const SizedBox(width: 8),
                      Text(
                        "Data Protection & Security",
                        style: GoogleFonts.raleway(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "• Governed by the Nigeria Data Protection Act (NDPA 2023).\n• End-to-end TLS 1.3 encryption in transit & AES-256 at rest.\n• Zero plaintext storage of passwords or 4-digit transaction PINs.\n• Hardware-backed Secure Enclave for biometric authentication.",
                    style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CONTACT & SUPPORT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Official Contacts",
                    style: GoogleFonts.raleway(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
                  ),
                  const SizedBox(height: 12),
                  _buildContactRow(
                    icon: Icons.language_rounded,
                    label: "Website",
                    value: "https://zengly.com",
                    textPrimary: textPrimary,
                    primaryColor: primaryColor,
                  ),
                  const Divider(height: 18),
                  _buildContactRow(
                    icon: Icons.email_outlined,
                    label: "General Support",
                    value: "support@zengly.com",
                    textPrimary: textPrimary,
                    primaryColor: primaryColor,
                  ),
                  const Divider(height: 18),
                  _buildContactRow(
                    icon: Icons.privacy_tip_outlined,
                    label: "Data Protection Officer",
                    value: "privacy@zengly.com",
                    textPrimary: textPrimary,
                    primaryColor: primaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text(
              "© 2026 Lynexa Innovations Ltd. All rights reserved.",
              style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String label,
    required String value,
    required Color textPrimary,
    required Color primaryColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: primaryColor),
        const SizedBox(width: 10),
        Text(label, style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey)),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary),
        ),
      ],
    );
  }
}
