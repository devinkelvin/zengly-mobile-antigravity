import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../core/network/api_response.dart';
import '../../../data/data.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../widgets/widgets.dart';

class _PasswordReq {
  final String label;
  final String pattern;
  const _PasswordReq(this.label, this.pattern);
}

class _PasswordRequirementsSection extends StatelessWidget {
  final bool lengthMet;
  final bool Function(String pattern) reqMet;
  final List<_PasswordReq> requirements;

  const _PasswordRequirementsSection({
    required this.lengthMet,
    required this.reqMet,
    required this.requirements,
  });

  @override
  Widget build(BuildContext context) {
    final metColor = const Color(0xFF00C27C);
    final unmetColor = Theme.of(context).colorScheme.scrim;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password Requirements",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        _ReqRow(
          label: "Use 10 to 15 characters, including at least:",
          met: lengthMet,
          metColor: metColor,
          unmetColor: unmetColor,
        ),
        ...requirements.map(
          (r) => _ReqRow(
            label: r.label,
            met: reqMet(r.pattern),
            metColor: metColor,
            unmetColor: unmetColor,
          ),
        ),
      ],
    );
  }
}

class _ReqRow extends StatelessWidget {
  final String label;
  final bool met;
  final Color metColor;
  final Color unmetColor;

  const _ReqRow({
    required this.label,
    required this.met,
    required this.metColor,
    required this.unmetColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            met ? "✓" : "-",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: met ? metColor : unmetColor,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: met ? metColor : unmetColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool _isValidPhoneNumber(String value) {
  String phoneNumber = value.replaceAll(RegExp(r'\D'), '');
  if (value.startsWith("+234")) {
    phoneNumber = phoneNumber.substring(3);
    List<String> validPrefixes = ["70", "71", "80", "81", "90", "91"];
    bool hasValidPrefix = validPrefixes.any(
      (prefix) => phoneNumber.startsWith(prefix),
    );

    return hasValidPrefix && phoneNumber.length == 10;
  } else if (value.startsWith("+44")) {
    phoneNumber = phoneNumber.substring(2);

    return phoneNumber.length >= 10 &&
        phoneNumber.length <= 11 &&
        phoneNumber.startsWith("7");
  } else if (value.startsWith("+1")) {
    phoneNumber = phoneNumber.substring(1);
    return phoneNumber.length == 10;
  }

  return false;
}

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  final _emailOtpController = TextEditingController();
  final _phoneOtpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _phoneNumber = "";
  bool _isAgreedToTerms = false;
  bool _isEmailVerified = false;
  bool _isPhoneVerified = false;
  String _password = "";

  static const _requirements = [
    _PasswordReq("1 uppercase letter", r'[A-Z]'),
    _PasswordReq("1 lowercase letter", r'[a-z]'),
    _PasswordReq("1 number", r'[0-9]'),
    _PasswordReq(r"1 special character, like / @ $ % &", r'[!@#\$%^&*/]'),
  ];

  bool _reqMet(String pattern) =>
      _password.isNotEmpty && RegExp(pattern).hasMatch(_password);
  bool get _lengthMet => _password.length >= 10 && _password.length <= 15;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() => _password = _passwordController.text);
    });
  }

  void _updatePhoneNumber(String newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].isEmpty) return email;
    final visible = parts[0].length <= 3 ? parts[0] : parts[0].substring(0, 3);
    return "$visible****@${parts[1]}";
  }

  String _maskPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 6) return digits;
    final start = digits.substring(0, 4);
    final end = digits.substring(digits.length - 2);
    return "$start*****$end";
  }

  void _verifyEmail() {
    if (AppValidators.validateEmail(_emailController.text) != null) {
      AppOverlays.showToast(
        context: context,
        message: "Enter a valid email address to proceed",
        toastType: ToastificationType.error,
      );
      return;
    }
    AppOverlays.otpBottomSheet(
      context: context,
      controller: _emailOtpController,
      length: 6,
      seconds: 60,
      channel: OtpChannel.email,
      maskedTarget: _maskEmail(_emailController.text),
      onVerify: () {
        context.pop();
        setState(() => _isEmailVerified = true);
      },
    );
  }

  void _verifyPhone() {
    if (!_isValidPhoneNumber(_phoneNumber)) {
      AppOverlays.showToast(
        context: context,
        message: "Enter a valid phone number to proceed",
        toastType: ToastificationType.error,
      );
      return;
    }
    AppOverlays.otpBottomSheet(
      context: context,
      controller: _phoneOtpController,
      length: 6,
      seconds: 60,
      channel: OtpChannel.phone,
      maskedTarget: _maskPhone(_phoneController.text),
      onVerify: () {
        context.pop();
        setState(() => _isPhoneVerified = true);
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailOtpController.dispose();
    _phoneOtpController.dispose();

    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_isEmailVerified) {
      AppOverlays.showToast(
        context: context,
        message: "Verify your email address to proceed",
        toastType: ToastificationType.error,
      );
      return;
    }
    if (!_isPhoneVerified) {
      AppOverlays.showToast(
        context: context,
        message: "Verify your phone number to proceed",
        toastType: ToastificationType.error,
      );
      return;
    }
    if (!_isAgreedToTerms) {
      AppOverlays.showToast(
        context: context,
        message: "Agree to Terms of Service and Privacy Policy to proceed",
        toastType: ToastificationType.error,
      );
      return;
    }
    if (!_isValidPhoneNumber(_phoneNumber)) {
      AppOverlays.showToast(
        context: context,
        message: "Enter a valid phone number to proceed",
        toastType: ToastificationType.error,
      );
      return;
    }

    AppOverlays.showLoadingDialog(context: context);
    final response = await ref
        .read(authNotifierProvider.notifier)
        .signUp(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phoneNo: _phoneNumber,
        );
    if (!mounted) return;
    context.pop();

    switch (response) {
      case ApiSuccess():
        // Email and phone are already verified inline on this screen via
        // the OTP bottom sheets, so skip the standalone OTP screen and go
        // straight to setting the transaction PIN.
        // context.pushNamed(
        //   AppRouter.otp,
        //   pathParameters: AppRouter.otpParameters(
        //     verificationId: result.verificationId,
        //     email: _emailController.text,
        //     isSignUp: true,
        //   ),
        // );
        context.goNamed(AppRouter.createPin);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF26211B)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 18),
                onPressed: () => context.pop(),
                color: Theme.of(context).colorScheme.onSurface,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.viewPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign Up 🚀",
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Let’s kick things off ",
                  style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
                ),
                SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _firstNameController,
                        labelText: "Legal firstname",
                        showValidation: false,
                        keyboardType: TextInputType.name,
                        autofillHints: [AutofillHints.name],
                        validator: AppValidators.validateName,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: AppTextField(
                        controller: _lastNameController,
                        showValidation: false,
                        labelText: "Legal surname",
                        validator: AppValidators.validateName,
                        keyboardType: TextInputType.name,
                        autofillHints: [AutofillHints.familyName],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  labelText: "Email address",
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.validateEmail,
                  autofillHints: [AutofillHints.email],
                  hasVerifyEnd: true,
                  isVerified: _isEmailVerified,
                  onVerify: _verifyEmail,
                ),
                SizedBox(height: 16),
                PhoneNumberTextField(
                  controller: _phoneController,
                  updatePhone: _updatePhoneNumber,
                  hasVerifyEnd: true,
                  isVerified: _isPhoneVerified,
                  onVerify: _verifyPhone,
                ),
                SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  labelText: "Choose a password",
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: [AutofillHints.newPassword],
                  validator: AppValidators.validatePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 12),
                _PasswordRequirementsSection(
                  lengthMet: _lengthMet,
                  reqMet: _reqMet,
                  requirements: _requirements,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _confirmPasswordController,
                  labelText: "Confirm password",
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: [AutofillHints.newPassword],
                  validator: (val) {
                    if (val!.isEmpty || val != _passwordController.text) {
                      return 'Enter the same password';
                    }
                    return null;
                  },
                  isPassword: true,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "I agree to the",
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: " Terms of Service",
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: " and",
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: " Privacy Policy.",
                              style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Switch(
                      value: _isAgreedToTerms,
                      onChanged: (val) {
                        setState(() => _isAgreedToTerms = val);
                      },
                      activeThumbColor: Theme.of(context).colorScheme.onPrimary,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveThumbColor:
                          Theme.of(context).colorScheme.onPrimary,
                      inactiveTrackColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF3E3A32)
                              : const Color(0xFFD6CEBF),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _signUp();
                      }
                    },
                    actionText: "Open Account",
                  ),
                ),
                SizedBox(height: 40),
                LiveChatWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
