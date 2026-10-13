import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/kyc/providers/kyc_provider.dart';
import '../../utils/utils.dart';
import '../../view/user_verification/widgets/widgets.dart';
import '../../widgets/widgets.dart';

class PreVerificationScreen extends ConsumerStatefulWidget {
  const PreVerificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PreVerificationScreenState();
}

class _PreVerificationScreenState extends ConsumerState<PreVerificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kycNotifierProvider.notifier).fetchStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final kycStatus = ref.watch(kycNotifierProvider).valueOrNull;
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
            backgroundColor: Theme.of(context).colorScheme.surface,
            onPressed: () {
              context.pop();
            },
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inverseSurface,
              width: 1,
            ),
            actionText: "Go to Home",
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              "Hang tight! ⏳",
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "This won’t take long, and your bonus will be on its way! ",
              style: GoogleFonts.raleway(fontSize: 12, letterSpacing: 0),
            ),
            SizedBox(height: 24),
            VerificationTitleTile(
              title: "BVN Verification",
              isCompleted: kycStatus?.isBvnVerified == true,
              onTap: () {
                context.pushNamed(AppRouter.bvnScreen);
              },
            ),
            VerificationTitleTile(
              title: "NIN Verification",
              isCompleted: kycStatus?.isNinVerified == true,
              onTap: () {
                context.pushNamed(AppRouter.ninScreen);
              },
            ),
            VerificationTitleTile(
              title: "Proof of Address (KYC)",
              isCompleted: kycStatus?.isAddressVerified == true,
              onTap: () {
                context.pushNamed(AppRouter.addressScreen);
              },
            ),
            VerificationTitleTile(
              title: "Complete your profile",
              isCompleted: kycStatus?.isSelfieVerified == true,
              onTap: () {
                context.pushNamed(AppRouter.profileCompletion);
              },
            ),
          ],
        ),
      ),
    );
  }
}
