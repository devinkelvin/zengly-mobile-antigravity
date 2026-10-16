import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ChooseSignUpScreen extends ConsumerStatefulWidget {
  const ChooseSignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChooseSignUpScreenState();
}

class _ChooseSignUpScreenState extends ConsumerState<ChooseSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              AppImages.onboardingGif,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: AppDimensions.viewPadding,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  SvgPicture.asset(AppImages.fullLogo),
                  SizedBox(width: double.infinity),
                  Spacer(),
                  Text(
                    l10n.yourMoneyYourFreedom,
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 28),
                  // Fills the width on small phones but stops growing past
                  // 360pt, so the buttons don't stretch on large devices.
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              onPressed: () {
                                context.pushNamed(AppRouter.signUp);
                              },
                              height: 50,
                              borderRadius: 15,
                              backgroundColor:
                                  Theme.of(context).colorScheme.onSurfaceVariant,
                              textColor: Theme.of(context).colorScheme.surface,
                              actionText: l10n.createAnAccount,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              onPressed: () {
                                context.pushNamed(AppRouter.loginUnknown);
                              },
                              height: 50,
                              borderRadius: 15,
                              actionText: l10n.login,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  context.pushNamed(AppRouter.onboarding);
                                },
                                child: Text(
                                  "View Onboarding",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              const Text(" • ", style: TextStyle(color: Colors.white38)),
                              TextButton(
                                onPressed: () {
                                  context.goNamed(AppRouter.dashboard);
                                },
                                child: Text(
                                  "Explore Demo →",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFE5A93C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
