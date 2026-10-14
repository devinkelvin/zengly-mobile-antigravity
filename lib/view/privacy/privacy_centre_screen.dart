import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../account/account_deletion_screen.dart';
import '../account/account_vm.dart';
import '../legal/legal_document_viewer_screen.dart';
import '../legal/models/legal_doc_model.dart';

class PrivacyCentreScreen extends ConsumerStatefulWidget {
  const PrivacyCentreScreen({super.key});

  @override
  ConsumerState<PrivacyCentreScreen> createState() => _PrivacyCentreScreenState();
}

class _PrivacyCentreScreenState extends ConsumerState<PrivacyCentreScreen> {
  bool _marketingPush = false;
  bool _promoEmail = false;
  bool _crashTelemetry = true;
  bool _lifestylePersonalization = true;
  bool _contactsLookup = false;

  void _showExportDataDialog() {
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

  void _showCorrectionDialog() {
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
    final cardBg = isDark ? const Color(0xFF1E1A14) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEBE3D7);
    final accountState = ref.watch(accountProvider);

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
          "Privacy Centre",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Privacy Shield Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF382709), const Color(0xFF1E170E)]
                      : [const Color(0xFFFBF4E8), const Color(0xFFF4EAD9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.shield_outlined, size: 28, color: primaryColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Privacy is Protected",
                          style: GoogleFonts.raleway(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Manage your personal data, permissions, and choices under the Nigeria Data Protection Act (NDPA 2023).",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SECTION 1: YOUR INFORMATION
            _buildSectionHeader("YOUR INFORMATION", textSecondary),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    label: "Legal Name",
                    value: accountState.fullName,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildInfoTile(
                    label: "Zengly Tag",
                    value: accountState.username,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildInfoTile(
                    label: "KYC Tier Level",
                    value: "${accountState.tier} Verified",
                    valueColor: const Color(0xFF34C759),
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.edit_note_rounded, size: 20, color: primaryColor),
                    title: Text(
                      "Request Data Correction",
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                    ),
                    subtitle: Text(
                      "Update changed address or legal name with supporting documents",
                      style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: _showCorrectionDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SECTION 2: YOUR PREFERENCES
            _buildSectionHeader("YOUR PREFERENCES", textSecondary),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: "Marketing Push Notifications",
                    subtitle: "Receive lifestyle perks, event alerts, and Vaniti promo codes",
                    value: _marketingPush,
                    onChanged: (val) => setState(() => _marketingPush = val),
                    primaryColor: primaryColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildSwitchTile(
                    title: "Promotional Emails",
                    subtitle: "Discounts on utility bills and new feature releases",
                    value: _promoEmail,
                    onChanged: (val) => setState(() => _promoEmail = val),
                    primaryColor: primaryColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildSwitchTile(
                    title: "Essential Crash & Security Telemetry",
                    subtitle: "Anonymous crash diagnostics to keep Zengly fast & secure",
                    value: _crashTelemetry,
                    onChanged: (val) => setState(() => _crashTelemetry = val),
                    primaryColor: primaryColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildSwitchTile(
                    title: "Lifestyle Personalization",
                    subtitle: "Tailor bill reminders and recommended split groups to your habits",
                    value: _lifestylePersonalization,
                    onChanged: (val) => setState(() => _lifestylePersonalization = val),
                    primaryColor: primaryColor,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SECTION 3: YOUR DEVICE PERMISSIONS
            _buildSectionHeader("DEVICE PERMISSIONS & USAGE TRANSPARENCY", textSecondary),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildPermissionTile(
                    icon: Icons.camera_alt_outlined,
                    title: "Camera",
                    purpose: "Used strictly for live selfie KYC verification and profile avatar updates.",
                    status: "Granted",
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    primaryColor: primaryColor,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildPermissionTile(
                    icon: Icons.notifications_none_rounded,
                    title: "Push Notifications",
                    purpose: "Mandatory for real-time security alerts and payment receipts.",
                    status: "Enabled",
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    primaryColor: primaryColor,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildPermissionTile(
                    icon: Icons.contacts_outlined,
                    title: "Contacts Access (Optional)",
                    purpose: "Used ONLY to discover friends for Split Bills & Vaniti sprays. Never used for lending or shared with third parties.",
                    status: _contactsLookup ? "Granted" : "Not Granted",
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    primaryColor: primaryColor,
                    onTapToggle: () => setState(() => _contactsLookup = !_contactsLookup),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SECTION 4: YOUR DATA RIGHTS
            _buildSectionHeader("EXERCISE YOUR DATA RIGHTS", textSecondary),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.download_rounded, size: 22, color: primaryColor),
                    title: Text(
                      "Request Data Export",
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                    ),
                    subtitle: Text(
                      "Download a structured archive of your account records",
                      style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: _showExportDataDialog,
                  ),
                  Divider(height: 1, color: borderColor),
                  ListTile(
                    leading: const Icon(Icons.policy_outlined, size: 22, color: Color(0xFF007AFF)),
                    title: Text(
                      "Read Privacy Policy",
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                    ),
                    subtitle: Text(
                      "Full transparency on third-party processors & NDPA compliance",
                      style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LegalDocumentViewerScreen(
                            document: LegalRepository.privacyPolicy,
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, color: borderColor),
                  ListTile(
                    leading: const Icon(Icons.delete_forever_outlined, size: 22, color: Color(0xFFFF3B30)),
                    title: Text(
                      "Delete Account & Erase Data",
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFFF3B30)),
                    ),
                    subtitle: Text(
                      "Permanent account closure and eligible data erasure pathway",
                      style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccountDeletionScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
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

  Widget _buildInfoTile({
    required String label,
    required String value,
    required Color textPrimary,
    required Color textSecondary,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13, color: textSecondary)),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color primaryColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: primaryColor,
            activeThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String purpose,
    required String status,
    required Color textPrimary,
    required Color textSecondary,
    required Color primaryColor,
    VoidCallback? onTapToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: status.contains("Granted") || status.contains("Enabled")
                            ? const Color(0xFF34C759).withValues(alpha: 0.15)
                            : Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: status.contains("Granted") || status.contains("Enabled")
                              ? const Color(0xFF34C759)
                              : textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  purpose,
                  style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
