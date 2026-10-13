import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class OnboardingWidget extends StatelessWidget {
  final OnboardingModel model;
  const OnboardingWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: model.backgroundColor,
      child: Padding(
        padding: AppDimensions.horizontalPadding,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: Responsive.height(context) * 0.375),
                Image.asset(model.image),
                Spacer(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                SvgPicture.asset(AppImages.zenglyTextLogo),
                SizedBox(height: 40),
                Text(
                  model.subTitle,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                    color: model.titleColor,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(width: Responsive.width(context) - 32),
                    SizedBox(
                      width: Responsive.width(context) - 32,
                      child: AppButton(
                        backgroundColor: model.buttonColor1,
                        onPressed: () {
                          context.goNamed(AppRouter.chooseSignUp);
                        },
                        actionText: "Create an account",
                        textColor: Color(0XFF171717),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: Responsive.width(context) - 32,
                      child: AppButton(
                        onPressed: () {
                          context.goNamed(AppRouter.loginUnknown);
                        },
                        backgroundColor: model.buttonColor2,
                        actionText: "Login",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
