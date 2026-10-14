import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

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

  void _showDataExportDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.file_download_outlined, color: primaryColor),
            const SizedBox(width: 8),
            Text(
              "Request Data Export",
              style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 17),
            ),
          ],
        ),
        content: Text(
          "Under NDPA 2023 Article 28, you can receive an encrypted ZIP archive containing your profile details, KYC records, and complete transaction history.\n\nYour export package will be compiled within 24 to 48 hours and delivered securely to your verified email address.",
          style: GoogleFonts.inter(fontSize: 13, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AppOverlays.showToast(
                context: context,
                title: "Export Initiated",
                message: "Ticket EXP-72018 created. You will receive an encrypted download link via email.",
                toastType: ToastificationType.success,
              );
            },
            child: const Text("Confirm Request"),
          ),
        ],
      ),
    );
  }

  void _showCorrectionDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Request Data Rectification",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Provide details of the personal information that requires updating (e.g. Legal Name change, Residential Address update):",
              style: GoogleFonts.inter(fontSize: 12.5, height: 1.4),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              style: GoogleFonts.inter(fontSize: 13),
              decoration: InputDecoration(
                hintText: "Enter correction details and reference documents...",
                hintStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AppOverlays.showToast(
                context: context,
                title: "Request Received",
                message: "Our Compliance Team will review your rectification request within 2 business days.",
                toastType: ToastificationType.success,
              );
            },
            child: const Text("Submit Request"),
          ),
        ],
      ),
    );
  }

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

            // GROUP 1: LEGAL DOCUMENTS & AGREEMENTS
            _buildSectionHeader("LEGAL DOCUMENTS & AGREEMENTS", textSecondary),
            const SizedBox(height: 8),
            AccountListTile(
              iconData: Icons.article_outlined,
              title: "Terms of Use",
              subTitle: "Wallet funds, reversal rules, liability & platform responsibilities",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LegalDocumentViewerScreen(
                      document: LegalRepository.termsOfUse,
                    ),
                  ),
                );
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
            _buildSectionHeader("DATA PRIVACY & CONTROLS (NDPA 2023)", textSecondary),
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
              onPressed: () => _showDataExportDialog(context),
            ),
            AccountListTile(
              iconData: Icons.edit_note_rounded,
              title: "Request Data Rectification",
              subTitle: "Submit legal name or residential address correction request",
              onPressed: () => _showCorrectionDialog(context),
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
