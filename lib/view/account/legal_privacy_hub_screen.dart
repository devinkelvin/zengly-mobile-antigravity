import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/widgets.dart';
import '../legal/legal_document_viewer_screen.dart';
import '../legal/models/legal_doc_model.dart';
import '../legal/widgets/terms_of_use_bottom_sheet.dart';
import '../privacy/privacy_centre_screen.dart';
import '../support/transaction_dispute_screen.dart';
import 'about_zengly_screen.dart';
import 'account_deletion_screen.dart';
import 'widgets/account_list_tile.dart';

class LegalPrivacyHubScreen extends StatelessWidget {
  const LegalPrivacyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6B655D);

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
          "Legal & Privacy",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Shield Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF382709), const Color(0xFF1E170E)]
                      : [const Color(0xFFFBF4E8), const Color(0xFFF4EAD9)],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_user_outlined, size: 28, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Compliance & Transparency",
                          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 14.5, color: textPrimary),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Access verified legal agreements, terms of use, fee schedules, and privacy controls governed by NDPA 2023.",
                          style: GoogleFonts.inter(fontSize: 12, color: textSecondary, height: 1.35),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // GROUP 1: LEGAL DOCUMENTS
            _buildSectionHeader("LEGAL DOCUMENTS", textSecondary),
            const SizedBox(height: 8),
            AccountListTile(
              iconData: Icons.article_outlined,
              title: "Term of use",
              subTitle: "Wallet funds, reversal rules, liability & responsibilities",
              onPressed: () {
                TermsOfUseBottomSheet.show(context);
              },
            ),
            AccountListTile(
              iconData: Icons.description_outlined,
              title: "Terms of Service",
              subTitle: "Rules governing your profile, wallet, and lifestyle services",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LegalDocumentViewerScreen(
                      document: LegalRepository.termsOfService,
                    ),
                  ),
                );
              },
            ),
            AccountListTile(
              iconData: Icons.policy_outlined,
              title: "Privacy Policy",
              subTitle: "How we collect, protect, and process your data under NDPA",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LegalDocumentViewerScreen(
                      document: LegalRepository.privacyPolicy,
                    ),
                  ),
                );
              },
            ),
            AccountListTile(
              iconData: Icons.payments_outlined,
              title: "Fees & Charges Schedule",
              subTitle: "Transparent breakdown of all platform rates, fees, and limits",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LegalDocumentViewerScreen(
                      document: LegalRepository.feesAndCharges,
                    ),
                  ),
                );
              },
            ),
            AccountListTile(
              iconData: Icons.currency_exchange_outlined,
              title: "Refunds, Reversals & Disputes",
              subTitle: "Guidelines and SLAs for resolving failed or disputed payments",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LegalDocumentViewerScreen(
                      document: LegalRepository.disputePolicy,
                    ),
                  ),
                );
              },
            ),
            AccountListTile(
              iconData: Icons.handshake_outlined,
              title: "P2P Lending Terms & Disclosures",
              subTitle: "FCCPC compliance notice & regulatory sandbox disclosures",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LegalDocumentViewerScreen(
                      document: LegalRepository.lendingTerms,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // GROUP 2: YOUR PRIVACY & CONTROLS
            _buildSectionHeader("YOUR PRIVACY", textSecondary),
            const SizedBox(height: 8),
            AccountListTile(
              iconData: Icons.privacy_tip_outlined,
              title: "Privacy Centre",
              subTitle: "Manage your personal information, permissions, and rights",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrivacyCentreScreen(),
                  ),
                );
              },
            ),
            AccountListTile(
              iconData: Icons.download_outlined,
              title: "Request Data Export",
              subTitle: "Download an encrypted archive of your account records",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrivacyCentreScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // GROUP 3: ACCOUNT CLOSURE & COMPANY
            _buildSectionHeader("ACCOUNT & OPERATOR", textSecondary),
            const SizedBox(height: 8),
            AccountListTile(
              iconData: Icons.info_outline_rounded,
              title: "About Zengly",
              subTitle: "Lynexa Innovations Ltd., legal disclosures & partner rails",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutZenglyScreen(),
                  ),
                );
              },
            ),
            AccountListTile(
              iconData: Icons.report_problem_outlined,
              title: "Transaction Disputes & Issues",
              subTitle: "Report a debited transfer, missing token, or billing issue",
              onPressed: () {
                TransactionDisputeScreen.show(context);
              },
            ),
            AccountListTile(
              iconData: Icons.delete_outline_rounded,
              title: "Delete Account",
              subTitle: "Permanent account closure & data erasure pathway",
              isLogOut: true,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AccountDeletionScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textSecondary) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}
