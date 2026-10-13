import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/network/api_response.dart';
import '../../../data/data.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class LoginUnknownScreen extends ConsumerStatefulWidget {
  const LoginUnknownScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginUnknownScreenState();
}

class _LoginUnknownScreenState extends ConsumerState<LoginUnknownScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final LocalAuthentication _localAuth = LocalAuthentication();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onBiometricPressed() async {
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
      _showEnableBiometricsSheet();
    }
  }

  void _showEnableBiometricsSheet() {
    AppOverlays.showEnableBiometricsSheet(context: context);
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    AppOverlays.showLoadingDialog(context: context);
    final response = await ref
        .read(authNotifierProvider.notifier)
        .login(
          email: _emailController.text,
          password: _passwordController.text,
        );
    if (!mounted) return;
    context.pop();

    switch (response) {
      case ApiSuccess(data: final session):
        if (session.user.hasCreatedPin == false) {
          context.goNamed(AppRouter.createPin);
        } else {
          context.goNamed(AppRouter.dashboard);
        }
      case ApiError(message: final message):
        AppOverlays.infoDialog(
          context: context,
          message: message,
          overlayType: OverlayType.failure,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      bottomSheet: LoginBottom(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.viewPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.login,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  l10n.confirmDetailsToLogin,
                  style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
                ),
                SizedBox(height: 40),
                AppTextField(
                  controller: _emailController,
                  labelText: l10n.emailAddressCaps,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: [AutofillHints.email],
                  validator: AppValidators.validateEmail,
                ),
                SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  labelText: l10n.password,
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: [AutofillHints.newPassword],
                  validator: AppValidators.validatePassword,
                  isPassword: true,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: _login,
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
                SizedBox(height: 48),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed(AppRouter.signUp);
                    },
                    child: Text(
                      l10n.openAnAccount,
                      style: GoogleFonts.inter(
                        letterSpacing: 0,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
