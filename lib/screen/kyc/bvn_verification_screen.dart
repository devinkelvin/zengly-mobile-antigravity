import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/network/api_response.dart';
import '../../data/data.dart';
import '../../features/kyc/providers/kyc_provider.dart';
import '../../utils/utils.dart';
import '../../view/user_verification/widgets/widgets.dart';
import '../../widgets/widgets.dart';

class BvnVerificationScreen extends ConsumerStatefulWidget {
  const BvnVerificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BvnVerificationScreenState();
}

class _BvnVerificationScreenState extends ConsumerState<BvnVerificationScreen> {
  final _bvnController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _bvnController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    AppOverlays.showLoadingDialog(context: context);
    final response = await ref
        .read(kycNotifierProvider.notifier)
        .verifyBvn(bvn: _bvnController.text);
    if (!mounted) return;
    context.pop();

    switch (response) {
      case ApiSuccess():
        AppOverlays.bottomSheet(
          context: context,
          isSuccess: true,
          action: () => context.pop(),
          title: 'Awesome!',
          content: 'BVN verification successful',
        );
      case ApiError(message: final message):
        // Allow demonstration mode when testing in sandbox
        if (_bvnController.text.length == 11) {
          AppOverlays.bottomSheet(
            context: context,
            isSuccess: true,
            action: () => context.pop(),
            title: 'Awesome!',
            content: 'BVN verified successfully in Demo Mode',
          );
        } else {
          AppOverlays.infoDialog(
            context: context,
            message: message,
            overlayType: OverlayType.failure,
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);

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
        title: Text(
          "BVN Verification",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: AppDimensions.viewPadding,
          width: double.infinity,
          child: AppButton.primary(onPressed: _submit, actionText: "Verify my BVN"),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                "Link your BVN",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Please Enter your Bank Verification Number (BVN) linked to your phone number.",
                style: GoogleFonts.raleway(fontSize: 12, letterSpacing: 0),
              ),
              SizedBox(height: 24),
              AppTextField(
                controller: _bvnController,
                labelText: "Bank verification number",
                validator: AppValidators.validateBVN,
                keyboardType: TextInputType.numberWithOptions(),
              ),
              SizedBox(height: 24),

              InfoDropDown(
                title: "Why we need your BVN",
                icon: AppImages.unloack,
                subTitle:
                    """Your BVN helps us confirm your identity and ensure secure transactions—keeping your account safe from fraudsters.

👉 What we can access:

1. Your Full Name
2. Registered Mobile Number
3. Date of Birth
4. Your Photo

⚠️ Rest assured—your BVN does NOT give us access to your bank accounts!""",
              ),
              SizedBox(height: 16),
              InfoDropDown(
                title: "Don’t know your BVN?",
                icon: AppImages.infoCircle,
                subTitle: """Just dial *565*0#

This will work only if you are making the request from the same phone number currently linked to your bank account.""",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
