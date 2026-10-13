import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/network/api_response.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String otp;
  const NewPasswordScreen({
    super.key,
    required this.verificationId,
    required this.otp,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    AppOverlays.showLoadingDialog(context: context);
    final response = await ref
        .read(authNotifierProvider.notifier)
        .resetPassword(
          verificationId: widget.verificationId,
          otp: widget.otp,
          password: _newPasswordController.text,
        );
    if (!mounted) return;
    context.pop();
    final isSuccess = response is ApiSuccess;
    AppOverlays.bottomSheet(
      context: context,
      isSuccess: isSuccess,
      action: () {
        context.goNamed(AppRouter.loginUnknown);
      },
      title: isSuccess ? l10n.awesomeAllSet : l10n.oops,
      content:
          isSuccess
              ? l10n.passcodeLockedAndLoaded
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
                  l10n.createNewPassword,
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 40),
                AppTextField(
                  controller: _newPasswordController,
                  labelText: l10n.newPassword,
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: [AutofillHints.newPassword],
                  validator: AppValidators.validatePassword,
                  isPassword: true,
                ),
                SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPasswordController,
                  labelText: l10n.confirmNewPassword,
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: [AutofillHints.newPassword],
                  validator: (val) {
                    if (val!.isEmpty || val != _newPasswordController.text) {
                      return l10n.enterTheSamePassword;
                    }
                    return null;
                  },
                  isPassword: true,
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: _resetPassword,
                    actionText: l10n.complete,
                  ),
                ),
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
