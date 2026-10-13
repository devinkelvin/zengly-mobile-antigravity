import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/app_images.dart';
import '../../../utils/utils.dart';

class CompleteProfileWidget extends StatelessWidget {
  const CompleteProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(AppImages.beepGif, height: 15, width: 15),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              "Complete your profile in just a few easy steps",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                letterSpacing: 0,
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.5),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.goNamed(AppRouter.preVerification);
            },
            child: Container(
              height: 27,
              width: 27,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: SvgPicture.asset(AppImages.arrowForwardIcon),
            ),
          ),
        ],
      ),
    );
  }
}
