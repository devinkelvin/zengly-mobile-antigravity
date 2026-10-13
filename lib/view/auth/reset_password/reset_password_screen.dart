import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

import '../../../core/network/api_response.dart';
import '../../../data/data.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

/// Progressive steps of the reset-password flow. Each completed step collapses
/// into a compact "verified" row so the user keeps the full trail on screen.
enum _ResetStep { email, verifying, otp, password, done }

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  _ResetStep _step = _ResetStep.email;
  String _verificationId = "";

  Timer? _timer;
  int _seconds = 60;

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        t.cancel();
      }
    });
  }

  /// Masks the local part of an email — "jonathan@mail.com" → "Jo***n@mail.com"
  String get _maskedEmail {
    final email = _emailController.text.trim();
    final at = email.indexOf('@');
    if (at < 1) return email;
    final local = email.substring(0, at);
    final domain = email.substring(at);
    if (local.length <= 3) return "$local***$domain";
    return "${local.substring(0, 2)}***${local.substring(local.length - 1)}$domain";
  }

  Future<void> _sendOtp() async {
    if (!_emailFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _step = _ResetStep.verifying);

    // Hold the "Verifying… Please wait" state on screen long enough to actually
    // be read, even when the API answers immediately.
    final minimumDwell = Future.delayed(const Duration(seconds: 2));
    final response = await ref
        .read(authNotifierProvider.notifier)
        .forgotPassword(email: _emailController.text.trim());
    await minimumDwell;
    if (!mounted) return;

    switch (response) {
      case ApiSuccess(data: final result):
        setState(() {
          _verificationId = result.verificationId;
          _step = _ResetStep.otp;
        });
        _startTimer();
      case ApiError(message: final message):
        setState(() => _step = _ResetStep.email);
        AppOverlays.infoDialog(
          context: context,
          message: message,
          overlayType: OverlayType.failure,
        );
    }
  }

  Future<void> _resendOtp() async {
    final l10n = AppLocalizations.of(context);
    AppOverlays.showLoadingDialog(context: context);
    final response = await ref
        .read(authNotifierProvider.notifier)
        .resendOtpForgotPassword(email: _emailController.text.trim());
    if (!mounted) return;
    context.pop();

    final isSuccess = response is ApiSuccess;
    if (isSuccess) _startTimer();
    AppOverlays.showToast(
      context: context,
      toastType:
          isSuccess ? ToastificationType.success : ToastificationType.error,
      message:
          isSuccess
              ? l10n.otpResentSuccessfully
              : (response as ApiError).message,
    );
  }

  void _confirmOtp() {
    final l10n = AppLocalizations.of(context);
    if (_otpController.text.length != 6) {
      AppOverlays.showToast(
        context: context,
        message: l10n.enter6DigitOtpToProceed,
        toastType: ToastificationType.error,
      );
      return;
    }
    FocusScope.of(context).unfocus();
    _timer?.cancel();
    setState(() => _step = _ResetStep.password);
  }

  Future<void> _resetPassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    AppOverlays.showLoadingDialog(context: context);

    final response = await ref
        .read(authNotifierProvider.notifier)
        .resetPassword(
          verificationId: _verificationId,
          otp: _otpController.text,
          password: _newPasswordController.text,
        );
    if (!mounted) return;
    context.pop();

    final l10n = AppLocalizations.of(context);
    if (response is ApiSuccess) {
      setState(() => _step = _ResetStep.done);
      AppOverlays.bottomSheet(
        context: context,
        isSuccess: true,
        action: () => context.goNamed(AppRouter.loginUnknown),
        title: l10n.newPasswordCreated,
        content: l10n.proceedToSignInWithNewPassword,
        actionText: l10n.signInWithNewPassword,
        animationAsset: 'assets/animations/checkmark.json',
      );
    } else {
      AppOverlays.bottomSheet(
        context: context,
        isSuccess: false,
        action: () {},
        title: l10n.oops,
        content: (response as ApiError).message,
      );
    }
  }

  void _onPrimaryAction() {
    switch (_step) {
      case _ResetStep.email:
        _sendOtp();
      case _ResetStep.verifying:
        break;
      case _ResetStep.otp:
        _confirmOtp();
      case _ResetStep.password:
        _resetPassword();
      case _ResetStep.done:
        context.goNamed(AppRouter.loginUnknown);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEmailDone = _step.index >= _ResetStep.otp.index;
    final isOtpDone = _step.index >= _ResetStep.password.index;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          l10n.resetYourPassword,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- Step 1: email ----
                    if (isEmailDone)
                      _VerifiedRow(label: l10n.emailAddressVerified)
                    else
                      _StepCard(
                        title: l10n.provideRegisteredEmail,
                        subtitle: l10n.onceVerifiedWeWillSendOtp,
                        child:
                            _step == _ResetStep.verifying
                                ? const _VerifyingRow()
                                : Form(
                                  key: _emailFormKey,
                                  child: _InlineField(
                                    controller: _emailController,
                                    hint: l10n.emailPlaceholder,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: AppValidators.validateEmail,
                                  ),
                                ),
                      ),

                    // ---- Step 2: OTP ----
                    if (_step.index >= _ResetStep.otp.index) ...[
                      const SizedBox(height: 12),
                      if (isOtpDone)
                        _VerifiedRow(label: l10n.otpVerified)
                      else
                        _OtpCard(
                          controller: _otpController,
                          maskedEmail: _maskedEmail,
                          seconds: _seconds,
                          onResend: _resendOtp,
                        ),
                    ],

                    // ---- Step 3: new password ----
                    if (_step == _ResetStep.password) ...[
                      const SizedBox(height: 12),
                      _StepCard(
                        title: l10n.createNewPassword,
                        child: Form(
                          key: _passwordFormKey,
                          child: Column(
                            children: [
                              _InlineField(
                                controller: _newPasswordController,
                                hint: l10n.newPassword,
                                isPassword: true,
                                validator: AppValidators.validatePassword,
                              ),
                              const SizedBox(height: 12),
                              _InlineField(
                                controller: _confirmPasswordController,
                                hint: l10n.confirmNewPassword,
                                isPassword: true,
                                validator: (val) {
                                  if (val == null ||
                                      val.isEmpty ||
                                      val != _newPasswordController.text) {
                                    return l10n.enterTheSamePassword;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: _onPrimaryAction,
                  borderRadius: 14,
                  actionText:
                      _step == _ResetStep.done
                          ? l10n.signInWithNewPassword
                          : l10n.continueLabel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Background used for elements nested *inside* a card — needs to read as a
/// step lighter than the card in dark mode, and a step brighter in light mode.
Color _innerFill(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;
  return Theme.of(context).brightness == Brightness.dark
      ? scheme.secondaryContainer
      : scheme.surface;
}

class _StepCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _StepCard({required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: GoogleFonts.inter(
                fontSize: 13,
                letterSpacing: 0,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Collapsed representation of a completed step.
class _VerifiedRow extends StatelessWidget {
  final String label;
  const _VerifiedRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            child: const Icon(Icons.check, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyingRow extends StatelessWidget {
  const _VerifyingRow();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _innerFill(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.verifyingPleaseWait,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Text(
            l10n.takeTwoSecs,
            style: GoogleFonts.inter(
              fontSize: 12,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpCard extends StatelessWidget {
  final TextEditingController controller;
  final String maskedEmail;
  final int seconds;
  final VoidCallback onResend;

  const _OtpCard({
    required this.controller,
    required this.maskedEmail,
    required this.seconds,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    final pinTheme = PinTheme(
      height: 46,
      width: 46,
      textStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: _innerFill(context),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.outlineVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.otpVerification,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: l10n.enterOtpSentToYourEmail,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          letterSpacing: 0,
                          color: scheme.scrim,
                        ),
                      ),
                      TextSpan(
                        text: '"$maskedEmail"',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          letterSpacing: 0,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Pinput(
                  controller: controller,
                  length: 6,
                  autofocus: true,
                  defaultPinTheme: pinTheme,
                  focusedPinTheme: pinTheme.copyDecorationWith(
                    border: Border.all(width: 1, color: scheme.primary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  hapticFeedbackType: HapticFeedbackType.heavyImpact,
                  // Design splits the code 3 — 3 with a dash between halves.
                  separatorBuilder:
                      (index) =>
                          index == 2
                              ? Container(
                                width: 12,
                                height: 1,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                color: scheme.scrim,
                              )
                              : const SizedBox(width: 6),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: _innerFill(context)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: GestureDetector(
              onTap: seconds == 0 ? onResend : null,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          seconds > 0
                              ? l10n.didntReceiveCodeResendIn
                              : l10n.didntReceiveCodeResendNow,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        letterSpacing: 0,
                        color: scheme.scrim,
                      ),
                    ),
                    TextSpan(
                      text:
                          seconds > 0
                              ? l10n.secondsShort(seconds)
                              : l10n.resendCodeNow,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact field used inside the step cards — placeholder-only, no floating
/// label, so it matches the card-nested look in the design.
class _InlineField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;

  const _InlineField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<_InlineField> createState() => _InlineFieldState();
}

class _InlineFieldState extends State<_InlineField> {
  late bool _obscure = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscure,
      validator: widget.validator,
      style: GoogleFonts.inter(
        fontSize: 14,
        letterSpacing: 0,
        color: scheme.onSurface,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: _innerFill(context),
        hintText: widget.hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          letterSpacing: 0,
          color: scheme.scrim,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: scheme.scrim,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 1),
        ),
      ),
    );
  }
}
