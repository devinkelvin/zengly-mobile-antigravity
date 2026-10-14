import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'account_vm.dart';

class AccountDeletionScreen extends ConsumerStatefulWidget {
  const AccountDeletionScreen({super.key});

  @override
  ConsumerState<AccountDeletionScreen> createState() =>
      _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends ConsumerState<AccountDeletionScreen> {
  int _currentStep = 1;
  String _selectedReason = "I no longer need this service";
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _additionalNotesController = TextEditingController();
  bool _understandRetention = false;
  bool _isLoading = false;

  final List<String> _reasons = [
    "I no longer need this service",
    "Privacy and data collection concerns",
    "Switching to another payment platform",
    "Temporary break / will return later",
    "Experienced technical difficulties",
    "Other reasons",
  ];

  @override
  void dispose() {
    _passwordController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  void _proceedToStep2() {
    if (!_understandRetention) {
      AppOverlays.showToast(
        context: context,
        title: "Acknowledgement Required",
        message: "Please acknowledge the statutory financial record retention terms to proceed.",
        toastType: ToastificationType.warning,
      );
      return;
    }
    setState(() => _currentStep = 2);
  }

  void _proceedToStep3() {
    setState(() => _currentStep = 3);
  }

  Future<void> _submitDeletionRequest() async {
    if (_passwordController.text.trim().isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Authentication Required",
        message: "Enter your account password or security PIN to confirm deletion.",
        toastType: ToastificationType.error,
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _currentStep = 4;
    });
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
        leading: _currentStep < 4
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textPrimary),
                onPressed: () {
                  if (_currentStep > 1) {
                    setState(() => _currentStep--);
                  } else {
                    context.pop();
                  }
                },
              )
            : const SizedBox.shrink(),
        title: Text(
          "Delete Account",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Progress Indicator (for steps 1 to 3)
            if (_currentStep < 4) ...[
              Row(
                children: [
                  for (int i = 1; i <= 3; i++) ...[
                    Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: _currentStep >= i ? const Color(0xFFFF3B30) : borderColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "STEP $_currentStep OF 3",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF3B30),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // STEP 1: CONSEQUENCES & RETENTION
            if (_currentStep == 1) ...[
              Text(
                "Account Closure & Erasure",
                style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                "Please review what happens when you delete your Zengly account:",
                style: GoogleFonts.inter(fontSize: 13, color: textSecondary, height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _buildConsequenceRow(
                      icon: Icons.cancel_outlined,
                      title: "Permanent Loss of @${accountState.username}",
                      subtitle: "Your unique tag, contacts list, and profile avatar will be permanently relinquished.",
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    const Divider(height: 24),
                    _buildConsequenceRow(
                      icon: Icons.credit_card_off_outlined,
                      title: "Immediate Card & Virtual Wallet Deactivation",
                      subtitle: "All associated virtual dollar cards and Sterling NGN account numbers will be frozen.",
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    const Divider(height: 24),
                    _buildConsequenceRow(
                      icon: Icons.account_balance_outlined,
                      title: "Statutory Financial Record Retention Notice",
                      subtitle: "In accordance with the Money Laundering (Prevention & Prohibition) Act 2022 and NDPA 2023, completed transaction ledgers and KYC compliance records will be retained securely for 5 years before permanent destruction.",
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C1414) : const Color(0xFFFFEBEA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFF3B30).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _understandRetention,
                      activeColor: const Color(0xFFFF3B30),
                      onChanged: (val) => setState(() => _understandRetention = val ?? false),
                    ),
                    Expanded(
                      child: Text(
                        "I understand the consequences of deletion and statutory compliance retention laws.",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B30),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _proceedToStep2,
                  child: Text("Continue to Account Review", style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                ),
              ),
            ],

            // STEP 2: REVIEW ACCOUNT OBLIGATIONS
            if (_currentStep == 2) ...[
              Text(
                "Review Your Account Status",
                style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                "Ensure all financial obligations and balances are resolved before closing:",
                style: GoogleFonts.inter(fontSize: 13, color: textSecondary, height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _buildBalanceStatusRow(
                      label: "Available Wallet Balance",
                      status: "₦0.00 (Cleared)",
                      isOk: true,
                      textPrimary: textPrimary,
                    ),
                    const Divider(height: 20),
                    _buildBalanceStatusRow(
                      label: "Pending Outward Transfers",
                      status: "None (All Settled)",
                      isOk: true,
                      textPrimary: textPrimary,
                    ),
                    const Divider(height: 20),
                    _buildBalanceStatusRow(
                      label: "Active Split Bill Requests",
                      status: "None Active",
                      isOk: true,
                      textPrimary: textPrimary,
                    ),
                    const Divider(height: 20),
                    _buildBalanceStatusRow(
                      label: "Outstanding Lending / Ajo Obligations",
                      status: "None Outstanding",
                      isOk: true,
                      textPrimary: textPrimary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Why are you leaving Zengly?",
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedReason,
                    items: _reasons.map((r) {
                      return DropdownMenuItem<String>(
                        value: r,
                        child: Text(r, style: GoogleFonts.inter(fontSize: 13, color: textPrimary)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedReason = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B30),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _proceedToStep3,
                  child: Text("Proceed to Security Confirmation", style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                ),
              ),
            ],

            // STEP 3: SECURITY CONFIRMATION
            if (_currentStep == 3) ...[
              Text(
                "Confirm Identity & Deletion",
                style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                "To prevent accidental or unauthorized closure, please verify your credentials:",
                style: GoogleFonts.inter(fontSize: 13, color: textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter Account Password / Security PIN",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: GoogleFonts.inter(fontSize: 14, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: "••••••••",
                        hintStyle: GoogleFonts.inter(fontSize: 14, color: textSecondary),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Additional Feedback (Optional)",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _additionalNotesController,
                      maxLines: 2,
                      style: GoogleFonts.inter(fontSize: 13, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: "Tell us how we could have done better...",
                        hintStyle: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B30),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _submitDeletionRequest,
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text("Permanently Request Account Deletion", style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                ),
              ),
            ],

            // STEP 4: SUBMITTED SUCCESS & EXTERNAL WEB FALLBACK
            if (_currentStep == 4) ...[
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.mark_email_read_rounded, size: 54, color: Color(0xFFFF3B30)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Deletion Request Submitted",
                      style: GoogleFonts.raleway(fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "Ticket Reference: ZENG-DEL-892401",
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: primaryColor),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Your request has been logged. In accordance with platform safety policies, your account is now in a 30-day pending deactivation period.\n\nIf you change your mind within 30 days, log in with your credentials to cancel deletion. Otherwise, all non-statutory personal data will be permanently wiped.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 13, color: textSecondary, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.public_rounded, size: 16, color: primaryColor),
                              const SizedBox(width: 6),
                              Text(
                                "Google Play Web-Based Deletion Pathway",
                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "You can also manage or initiate deletion online without the mobile app at:",
                            style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "https://zengly.com/account/delete",
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          await ref.read(authNotifierProvider.notifier).clearCurrentUser();
                          if (!context.mounted) return;
                          context.goNamed(AppRouter.chooseSignUp);
                        },
                        child: Text("Sign Out & Complete", style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildConsequenceRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: const Color(0xFFFF3B30)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
              const SizedBox(height: 3),
              Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: textSecondary, height: 1.35)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceStatusRow({
    required String label,
    required String status,
    required bool isOk,
    required Color textPrimary,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: textPrimary)),
        Row(
          children: [
            Icon(Icons.check_circle_rounded, size: 16, color: const Color(0xFF34C759)),
            const SizedBox(width: 4),
            Text(
              status,
              style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFF34C759)),
            ),
          ],
        ),
      ],
    );
  }
}
