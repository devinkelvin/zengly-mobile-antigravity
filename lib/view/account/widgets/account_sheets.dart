import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class SecuritySettingsSheet extends StatelessWidget {
  const SecuritySettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).colorScheme.outlineVariant;
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shield_outlined, color: primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Security & Privacy",
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Manage your passwords, PIN, and account protection",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SecurityOptionTile(
          icon: Icons.pin_outlined,
          title: "Change Transaction PIN",
          subtitle: "Update your 4-digit security PIN for transfers and gifts",
          onTap: () {
            Navigator.pop(context);
            context.pushNamed(AppRouter.createPin);
          },
        ),
        const SizedBox(height: 10),
        _SecurityOptionTile(
          icon: Icons.lock_reset_outlined,
          title: "Reset Password",
          subtitle: "Change your account sign-in password",
          onTap: () {
            Navigator.pop(context);
            context.pushNamed(AppRouter.resetPassword);
          },
        ),
        const SizedBox(height: 10),
        _SecurityOptionTile(
          icon: Icons.fingerprint_rounded,
          title: "Biometric Authentication",
          subtitle: "Configure Face ID or Fingerprint login",
          onTap: () {
            Navigator.pop(context);
            context.pushNamed(AppRouter.biometrics);
          },
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF00C27C).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: Color(0xFF00C27C),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Two-Factor Authentication",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Active • SMS & Email Verification",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF00C27C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class TransactionLimitsSheet extends StatelessWidget {
  const TransactionLimitsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).colorScheme.outlineVariant;
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.account_balance_wallet_outlined, color: primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Limits",
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Your current limits based on Tier 1 verification",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _LimitRow(
                label: "Daily Transfer Limit",
                amount: "₦50,000.00",
                used: "₦0.00 used today",
              ),
              const Divider(height: 24, thickness: 0.8),
              _LimitRow(
                label: "Maximum Wallet Balance",
                amount: "₦300,000.00",
                used: "Unlimited with Tier 3",
              ),
              const Divider(height: 24, thickness: 0.8),
              _LimitRow(
                label: "Single Transfer Limit",
                amount: "₦20,000.00",
                used: "Per transaction",
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              Navigator.pop(context);
              context.pushNamed(AppRouter.preVerification);
            },
            actionText: "Upgrade to Tier 2 (Higher Limits)",
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class SupportHelpSheet extends StatelessWidget {
  const SupportHelpSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.headset_mic_outlined, color: primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Help & Support",
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "We are here to help you 24/7",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _SecurityOptionTile(
          icon: Icons.chat_bubble_outline_rounded,
          title: "Live Chat",
          subtitle: "Speak with a customer support representative",
          onTap: () {
            Navigator.pop(context);
            AppOverlays.showToast(
              context: context,
              title: "Live Chat",
              message: "Connecting to a live agent...",
              toastType: ToastificationType.info,
            );
          },
        ),
        const SizedBox(height: 10),
        _SecurityOptionTile(
          icon: Icons.mail_outline_rounded,
          title: "Email Support",
          subtitle: "support@zengly.app • Responses within 2 hours",
          onTap: () {
            Navigator.pop(context);
            AppOverlays.showToast(
              context: context,
              title: "Email Support",
              message: "Support email copied to clipboard",
              toastType: ToastificationType.success,
            );
          },
        ),
        const SizedBox(height: 10),
        _SecurityOptionTile(
          icon: Icons.help_outline_rounded,
          title: "Frequently Asked Questions",
          subtitle: "Find quick answers to common questions",
          onTap: () {
            Navigator.pop(context);
            AppOverlays.showToast(
              context: context,
              title: "FAQ",
              message: "Opening Zengly Help Center...",
              toastType: ToastificationType.info,
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class ReportBugSheet extends StatefulWidget {
  const ReportBugSheet({super.key});

  @override
  State<ReportBugSheet> createState() => _ReportBugSheetState();
}

class _ReportBugSheetState extends State<ReportBugSheet> {
  final _controller = TextEditingController();
  String _selectedCategory = "UI / Visuals";

  final _categories = [
    "UI / Visuals",
    "Vaniti Spray",
    "Transfers",
    "Account & KYC",
    "Other",
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).colorScheme.outlineVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.bug_report_outlined, color: primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Report a Bug",
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Help us make Zengly smoother and faster",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          "CATEGORY",
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: Theme.of(context).colorScheme.scrim,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((cat) {
            final isSelected = cat == _selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? primary : cardColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.black : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          "DESCRIPTION",
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            color: Theme.of(context).colorScheme.scrim,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _controller,
            maxLines: 3,
            style: GoogleFonts.inter(fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              hintText: "Describe what happened or what looks off...",
              hintStyle: GoogleFonts.inter(
                fontSize: 13,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              Navigator.pop(context);
              AppOverlays.showToast(
                context: context,
                title: "Report Submitted",
                message: "Thank you for helping us polish Zengly!",
                toastType: ToastificationType.success,
              );
            },
            actionText: "Submit Bug Report",
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _SecurityOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SecurityOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ],
        ),
      ),
    );
  }
}

class _LimitRow extends StatelessWidget {
  final String label;
  final String amount;
  final String used;

  const _LimitRow({
    required this.label,
    required this.amount,
    required this.used,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              used,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        Text(
          amount,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
