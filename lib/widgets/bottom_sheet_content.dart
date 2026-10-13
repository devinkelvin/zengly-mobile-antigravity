import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class BottomSheetContent extends StatelessWidget {
  final bool isSuccess;
  final String? title;
  final String? content;
  final String? actionText;
  final VoidCallback action;

  /// Optional Lottie asset shown in place of the default gift-card + confetti
  /// success artwork (e.g. a checkmark for a completed flow).
  final String? animationAsset;

  const BottomSheetContent({
    super.key,
    required this.isSuccess,
    required this.action,
    this.title,
    this.content,
    this.actionText,
    this.animationAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isSuccess)
          SizedBox(
            height: 160,
            width: 160,
            child: Lottie.asset(
              animationAsset ?? 'assets/animations/checkmark.json',
              repeat: true,
              fit: BoxFit.contain,
            ),
          )
        else
          Image.asset(
            AppImages.errorGif,
            height: 120,
            width: 120,
          ),
        SizedBox(height: 16),
        Text(
          title ?? (isSuccess ? "Awesome! You're all set." : "Oops!"),
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 8),
        Text(
          content ??
              (isSuccess
                  ? " Your action was successful"
                  : "Something didn’t go as planned. Let’s try that again!"),
          textAlign: TextAlign.center,
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Theme.of(context).colorScheme.shadow,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              if (isSuccess) {
                context.pop();
                action();
              } else {
                context.pop();
              }
            },
            actionText: actionText ?? "Continue",
          ),
        ),
      ],
    );
  }
}
