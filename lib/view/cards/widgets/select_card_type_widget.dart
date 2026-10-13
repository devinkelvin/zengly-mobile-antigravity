import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';

class SelectCardTypeWidget extends ConsumerWidget {
  final String title, subTitle;
  const SelectCardTypeWidget({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRouter.confirmCardDetail);
      },
      child: Container(
        height: 93,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(AppImages.mastercard),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                ),
                Text(
                  subTitle,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
