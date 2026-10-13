import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class LoginKnownScreen extends ConsumerStatefulWidget {
  const LoginKnownScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginKnownScreenState();
}

class _LoginKnownScreenState extends ConsumerState<LoginKnownScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  void _changeUser() {
    context.goNamed(AppRouter.loginUnknown);
    ref.read(authNotifierProvider.notifier).clearCurrentUser();
  }

  void _onLoginPressed() {
    if (_passwordController.text.isEmpty) {
      AppOverlays.showToast(
        context: context,
        message: "Enter your password",
        toastType: ToastificationType.error,
      );
      return;
    }
    context.goNamed(AppRouter.dashboard);
  }

  void _onBiometricPressed() {
    final user = ref.read(authNotifierProvider).value;
    if (user?.hasLocalAuth != true) {
      _showEnableBiometricsSheet();
      return;
    }
    _loginWithLocalAuth();
  }

  Future<void> _loginWithLocalAuth() async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to login',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (!mounted) return;
      if (isAuthenticated) {
        context.goNamed(AppRouter.dashboard);
      } else {
        _showEnableBiometricsSheet();
      }
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Biometrics Not Set Up",
            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
          ),
          content: Text(
            "No biometrics enrolled on this device. Go to Settings to add a fingerprint or face, then try again.",
            style: GoogleFonts.inter(fontSize: 14, color: Theme.of(context).colorScheme.scrim),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("Later", style: TextStyle(color: Theme.of(context).colorScheme.scrim)),
            ),
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
  }

  void _showEnableBiometricsSheet() {
    AppOverlays.showEnableBiometricsSheet(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authNotifierProvider).value;

    return Scaffold(
      bottomSheet: LoginBottom(),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.viewPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        AppImages.profilePicture,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => context.goNamed(AppRouter.loginPin),
                        child: Text(
                          "Login with Passcode? ",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.scrim,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _changeUser,
                        child: Text(
                          "Change",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                _greeting,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.firstName ?? "Welcome back",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 32),
              AppTextField(
                controller: _passwordController,
                isPassword: true,
                labelText: l10n.password,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: _onLoginPressed,
                      actionText: l10n.login,
                      borderRadius: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 32,
                    width: 1,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _onBiometricPressed,
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImages.fingerPrint,
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
