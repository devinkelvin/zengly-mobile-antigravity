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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.viewPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Awesome! \nSet up your biometrics",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Please re-enter your transaction pin to confirm",
                style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
              ),
              Spacer(),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: _saveBiometrics,
                        borderRadius: BorderRadius.circular(35),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            AppImages.fingerPrint,
                            height: 34,
                            width: 34,
                          ),
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 1,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      InkWell(
                        onTap: _saveBiometrics,
                        borderRadius: BorderRadius.circular(35),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            AppImages.iconFaceId,
                            height: 34,
                            width: 34,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: _skipForNow,
                  backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                  actionText: "I will do this later",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
