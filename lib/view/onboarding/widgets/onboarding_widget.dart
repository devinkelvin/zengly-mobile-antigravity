import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';

class OnboardingWidget extends StatelessWidget {
  final OnboardingModel model;
  const OnboardingWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Padding(
          padding: AppDimensions.horizontalPadding,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              model.badge,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: primary,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: Responsive.height(context) * 0.38,
          child: Image.asset(
            model.image,
            fit: BoxFit.fitWidth,
            width: double.infinity,
          ),
        ),
        const Spacer(),
        Padding(
          padding: AppDimensions.horizontalPadding,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${model.headline}\n",
                  style: GoogleFonts.raleway(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                    height: 1.2,
                  ),
                ),
                TextSpan(
                  text: model.highlightedWord,
                  style: GoogleFonts.raleway(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: primary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: AppDimensions.horizontalPadding,
          child: Text(
            model.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white60 : Colors.black54,
              height: 1.45,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
