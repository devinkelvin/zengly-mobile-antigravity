import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/widgets.dart';

class CardSuccessWidget extends StatelessWidget {
  final String title, subTitle;
  const CardSuccessWidget({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RotatingCoinIcon(size: 90),
        SizedBox(height: 16, width: double.infinity),
        Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              context.pop();
            },
            actionText: "Okay",
            backgroundColor: Theme.of(context).colorScheme.surface,
            borderSide: BorderSide(color: Color(0XFFE0334C)),
          ),
        ),
      ],
    );
  }
}
