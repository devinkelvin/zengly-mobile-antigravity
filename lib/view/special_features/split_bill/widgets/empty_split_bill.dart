import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';

class EmptySplitBill extends ConsumerWidget {
  final String detail;
  final bool isInitiateSplit;
  const EmptySplitBill({
    super.key,
    required this.detail,
    required this.isInitiateSplit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: AppDimensions.viewPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.emptySplitBill),
          SizedBox(height: 10, width: double.infinity),
          Text(
            "No recent activity yet",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              detail,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                letterSpacing: 0,
                color: Theme.of(context).colorScheme.secondaryFixedDim,
              ),
            ),
          ),
          if (isInitiateSplit)
            Column(
              children: [
                SizedBox(height: 30, width: double.infinity),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: () {
                      context.pushNamed(AppRouter.createBill);
                    },
                    actionText: "Initiate a split payment ",
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
