import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class NinVerificationScreen extends ConsumerStatefulWidget {
  const NinVerificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NinVerificationScreenState();
}

class _NinVerificationScreenState extends ConsumerState<NinVerificationScreen> {
  final _ninController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _ninController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: AppDimensions.viewPadding,
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.pushNamed(
                  AppRouter.selfieVerificationScreen,
                  pathParameters: AppRouter.selfieParameters(
                    nin: _ninController.text,
                  ),
                );
              }
            },
            actionText: "Verify my NIN",
          ),
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
                "Link your NIN",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Please Enter your National Identification Number (NIN) linked to your phone number.",
                style: GoogleFonts.raleway(fontSize: 12, letterSpacing: 0),
              ),
              SizedBox(height: 24),
              AppTextField(
                controller: _ninController,
                labelText: "National Identification Number",
                validator: AppValidators.validateBVN,
                keyboardType: TextInputType.numberWithOptions(),
              ),
              SizedBox(height: 24),
              InfoDropDown(
                title: "Why We Need Your NIN",
                icon: AppImages.unloack,
                subTitle:
                    """We use your NIN to make sure it’s really you making transactions—keeping your account secure and fraud-free.

👉 What we can access:

Your Full Name
Registered Mobile Number
Date of Birth
Your Photo

⚠️ Don't worry—your NIN does NOT give us access to your bank accounts!""",
              ),
              SizedBox(height: 16),
              InfoDropDown(
                title: "Don’t know your NIN?",
                icon: AppImages.infoCircle,
                subTitle: """Just dial *346# to retrieve it instantly!

⚠️ Make sure you're using the phone number linked to your bank account for this to work.""",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
