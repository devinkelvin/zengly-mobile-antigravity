import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'account_vm.dart';
import 'widgets/widgets.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final accountState = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.accountTitle,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
        actions: [
          SizedBox(
            width: 80,
            height: 38,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppImages.tier1, width: 21),
                  SizedBox(width: 4),
                  Text(
                    l10n.tier1,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                          Theme.of(context).colorScheme.onTertiaryFixedVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Brand gradient is the base layer…
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFFEA9F41), Color(0xFF3971B0)],
                            ),
                          ),
                        ),
                        // …with the user's own avatar blurred over the right of
                        // the banner. Right/top/bottom edges are pushed off-canvas
                        // so the ClipRRect trims them; only the left edge is
                        // left to melt into the gradient.
                        Positioned(
                          right: -40,
                          top: -40,
                          bottom: -40,
                          width: 280,
                          child: Opacity(
                            opacity: 0.75,
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 40,
                                sigmaY: 40,
                              ),
                              child: Image.asset(
                                AppImages.profilePicture,
                                fit: BoxFit.cover,
                                alignment: const Alignment(0, -0.3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      "A",
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -36,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              AppImages.profilePicture,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 26,
                              width: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 44),
            Text(
              "@ability007",
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              "54674778965",
              style: GoogleFonts.raleway(
                fontSize: 12,
                color: Color(0xFFE99935),
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 8),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "Account Number: 2002405021",
            //       style: GoogleFonts.inter(
            //         fontSize: 14,
            //         color: Theme.of(context).colorScheme.scrim,
            //       ),
            //     ),
            //     SizedBox(width: 4),
            //     GestureDetector(
            //       onTap: () {},
            //       child: SvgPicture.asset(AppImages.copyImage),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 8),
            // AppButton(
            //   onPressed: () {
            //     context.goNamed(AppRouter.personalInfo);
            //   },
            //   actionText: "Edit Profile",
            //   borderRadius: 50,
            //   height: 40,
            // ),
            // SizedBox(height: 32),
            AccountListTile(
              icon: AppImages.biometrics,
              title: l10n.biometricsTitle,
              subTitle: l10n.fingerprintOrFaceId,
              isBiometrics: true,
              switchValue: accountState.isBiometricEnabled,
              onSwitchChanged: (val) {
                ref.read(accountProvider.notifier).toggleBiometrics();
              },
              onPressed: () {
                ref.read(accountProvider.notifier).toggleBiometrics();
              },
            ),
            AccountListTile(
              icon: AppImages.accountCircle,
              title: l10n.profileAndAccount,
              subTitle: l10n.manageYourAccount,
              onPressed: () {
                context.goNamed(AppRouter.personalInfo);
              },
            ),
            AccountListTile(
              icon: AppImages.verifications,
              title: l10n.verificationTitle,
              subTitle: l10n.kycVerification,
              onPressed: () {
                context.goNamed(AppRouter.preVerification);
              },
            ),
            AccountListTile(
              icon: AppImages.transaction,
              title: l10n.transactionLimit,
              subTitle: l10n.viewAccountTransactionLimits,
              onPressed: () => AppOverlays.transactionLimitsSheet(context: context),
            ),
            AccountListTile(
              icon: AppImages.security,
              title: l10n.security,
              subTitle: l10n.managePasswordAndPin,
              onPressed: () => AppOverlays.securitySettingsSheet(context: context),
            ),
            AccountListTile(
              icon: AppImages.bug,
              title: l10n.reportABug,
              subTitle: l10n.helpMakeUsBetter,
              onPressed: () => AppOverlays.reportBugSheet(context: context),
            ),
            AccountListTile(
              icon: AppImages.support,
              title: l10n.support,
              subTitle: l10n.talkWithCustomerService,
              onPressed: () => AppOverlays.supportHelpSheet(context: context),
            ),
            // AccountListTile(
            //   iconData: Icons.language,
            //   title: l10n.language,
            //   subTitle: l10n.personalizeVisualExperience,
            //   onPressed: () {
            //     context.pushNamed(AppRouter.language);
            //   },
            // ),
            AccountListTile(
              iconData: Icons.brightness_6_outlined,
              title: l10n.appearance,
              subTitle: l10n.personalizeVisualExperience,
              onPressed: () => context.pushNamed(AppRouter.appearance),
            ),
            SizedBox(height: 40),
            AccountListTile(
              icon: AppImages.logout,
              title: l10n.logout,
              isLogOut: true,
              subTitle: "",
              onPressed: () {
                AppOverlays.logoutSheet(
                  context: context,
                  onConfirm: () async {
                    await ref
                        .read(authNotifierProvider.notifier)
                        .clearCurrentUser();
                    if (!context.mounted) return;
                    context.goNamed(AppRouter.chooseSignUp);
                  },
                );
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
