import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../../data/data.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class BiometricsScreen extends ConsumerStatefulWidget {
  const BiometricsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BiometricsScreenState();
}

class _BiometricsScreenState extends ConsumerState<BiometricsScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> _saveBiometrics() async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to set up Biometric login',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (!mounted) return;

      if (isAuthenticated) {
        AppOverlays.showLoadingDialog(context: context);
        await ref.read(authNotifierProvider.notifier).markBiometricsEnabled();
        if (!mounted) return;
        context.pop();
        _showWelcomeSheet();
      } else {
        AppOverlays.infoDialog(
          context: context,
          message: "Error verifying biometrics, please try again later",
          overlayType: OverlayType.failure,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showBiometricError(e);
    }
  }

  void _showBiometricError(Object e) {
    String message;
    bool canOpenSettings = false;

    if (e is PlatformException) {
      final msg = e.message?.toLowerCase() ?? '';
      if (msg.contains('security credentials') ||
          msg.contains('not available') ||
          e.code == 'NotAvailable' ||
          e.code == 'NotEnrolled') {
        message = "No biometrics enrolled on this device. Go to Settings to add a fingerprint or face, then come back.";
        canOpenSettings = true;
      } else if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
        message = "Biometrics locked due to too many failed attempts. Please use your device PIN to unlock first.";
        canOpenSettings = true;
      } else {
        message = "Biometric authentication is not available on this device.";
      }
    } else {
      message = "Biometric authentication is not available on this device.";
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Biometrics Not Set Up",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(fontSize: 14, color: Theme.of(context).colorScheme.scrim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Later", style: TextStyle(color: Theme.of(context).colorScheme.scrim)),
          ),
          if (canOpenSettings)
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                AppSettings.openAppSettings(type: AppSettingsType.security);
              },
              child: Text("Go to Settings", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
        ],
      ),
    );
  }

  Future<void> _skipForNow() async {
    AppOverlays.showLoadingDialog(context: context);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    context.pop();
    _showWelcomeSheet();
  }

  void _showWelcomeSheet() {
    final l10n = AppLocalizations.of(context);
    AppOverlays.bottomSheet(
      context: context,
      isSuccess: true,
      title: l10n.voila,
      content: l10n.welcomeToZengly,
      actionText: "Login",
      action: () {
        context.goNamed(AppRouter.loginUnknown);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const goldColor = Color(0xFFB57510);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fast & Secure Access",
                      style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        letterSpacing: -0.4,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Set up Face ID or Fingerprint to unlock your wallet and approve payments instantly.",
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        height: 1.45,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Concentric Glowing Biometric Rings
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: goldColor.withValues(alpha: isDark ? 0.05 : 0.03),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: goldColor.withValues(alpha: isDark ? 0.1 : 0.06),
                      border: Border.all(
                        color: goldColor.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _saveBiometrics();
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF382709), const Color(0xFF1E1810)]
                              : [const Color(0xFFFFF4E0), const Color(0xFFF3E2C3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: goldColor.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: goldColor.withValues(alpha: 0.3),
                            blurRadius: 28,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImages.fingerPrint,
                          width: 48,
                          height: 48,
                          colorFilter: const ColorFilter.mode(
                            goldColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Dual-support pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262017) : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isDark ? Colors.white12 : const Color(0xFFEADBCE),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield_rounded,
                      size: 16,
                      color: Color(0xFF34C759),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Hardware Keystore Protected",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : const Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Primary & Secondary Buttons
              AppButton.primary(
                actionText: "Authenticate with Biometrics",
                onPressed: _saveBiometrics,
              ),
              const SizedBox(height: 12),
              AppButton.outline(
                actionText: "I'll do this later",
                onPressed: _skipForNow,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
