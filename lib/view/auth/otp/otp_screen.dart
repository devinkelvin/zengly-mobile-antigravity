import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

import '../../../core/network/api_response.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String email;
  final String isSignUp;
  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.email,
    required this.isSignUp,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late int seconds;
  late Timer timer;
  bool isTimerActive = true;

  bool _isSignUp = false;

  final _pinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    seconds = 60;
    _startTimer();
    _isSignUp = widget.isSignUp == "yes";
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          isTimerActive = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    final l10n = AppLocalizations.of(context);
    if (_pinController.text.length != 6) {
      AppOverlays.showToast(
        context: context,
        message: l10n.enter6DigitOtpToProceed,
      );
      return;
    }
    AppOverlays.showLoadingDialog(context: context);
    final response = await ref
        .read(authNotifierProvider.notifier)
        .verifyEmail(
          verificationId: widget.verificationId,
          otpCode: _pinController.text,
        );
    if (!mounted) return;
    context.pop();

    final isSuccess = response is ApiSuccess;
    if (!mounted) return;
    AppOverlays.bottomSheet(
      context: context,
      isSuccess: isSuccess,
      action: () {
        context.goNamed(AppRouter.createPin);
      },
      title: isSuccess ? l10n.voila : "Error",
      content:
          isSuccess ? l10n.welcomeToZengly : (response as ApiError).message,
    );
  }

  Future<void> _resendOtp() async {
    final l10n = AppLocalizations.of(context);
    AppOverlays.showLoadingDialog(context: context);
    final response = await ref
        .read(authNotifierProvider.notifier)
        .resendOtp(email: widget.email);
    if (!mounted) return;
    context.pop();
    final isSuccess = response is ApiSuccess;
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

  Future<void> _resendOtpForgotPassword() async {
    final l10n = AppLocalizations.of(context);
    AppOverlays.showLoadingDialog(context: context);
    final response = await ref
        .read(authNotifierProvider.notifier)
        .resendOtpForgotPassword(email: widget.email);
    if (!mounted) return;
    context.pop();
    final isSuccess = response is ApiSuccess;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppDimensions.viewPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.enterOtp,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  l10n.weJustSentOtp,
                  style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Pinput(
                      validator: AppValidators.validatePin6,
                      autofocus: true,
                      controller: _pinController,
                      length: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      hapticFeedbackType: HapticFeedbackType.heavyImpact,
                      errorBuilder: (errorText, pin) {
                        return Text(
                          errorText ?? l10n.enterPinPlaceholder,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        );
                      },
                      focusedPinTheme: PinTheme(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      errorPinTheme: PinTheme(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                      defaultPinTheme: PinTheme(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  l10n.noOtpHelp,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    letterSpacing: 0,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: () {
                      if (_pinController.text.length != 6) {
                        AppOverlays.showToast(
                          context: context,
                          message: l10n.enter6DigitOtpToProceed,
                          toastType: ToastificationType.error,
                        );
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        if (_isSignUp) {
                          _verifyEmail();
                        } else {
                          context.pushNamed(
                            AppRouter.newPassword,
                            pathParameters: AppRouter.newPasswordParameters(
                              verificationId: widget.verificationId,
                              otp: _pinController.text,
                            ),
                          );
                        }
                      }
                    },
                    actionText: l10n.verify,
                  ),
                ),
                SizedBox(height: 48),
                GestureDetector(
                  onTap: () {
                    if (seconds != 0) {
                      AppOverlays.showToast(
                        context: context,
                        message: l10n.tryAgainWhenTimerExpires,
                        toastType: ToastificationType.error,
                      );
                    } else {
                      if (_isSignUp) {
                        _resendOtp();
                      } else {
                        _resendOtpForgotPassword();
                      }
                    }
                  },
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: l10n.didntGetCode,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          TextSpan(
                            text:
                                seconds > 0
                                    ? l10n.resendIn(seconds)
                                    : l10n.resendNow,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Spacer(),
                LiveChatWidget(),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
