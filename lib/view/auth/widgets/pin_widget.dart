import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';

class PinWidget extends StatelessWidget {
  final VoidCallback onDeletePressed;
  final VoidCallback onNumberPressed;
  const PinWidget({
    super.key,
    required this.onDeletePressed,
    required this.onNumberPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          String buttonText;
          if (index < 9) {
            buttonText = "${index + 1}";
          } else if (index == 9) {
            buttonText = "";
          } else if (index == 10) {
            buttonText = "0";
          } else {
            buttonText = "";
          }

          return GestureDetector(
            onTap: () async {
              if (index == 9) {
                onDeletePressed();
              } else if (index == 11) {
                // if (viewModel.enteredPin.length == 4) {
                //   viewModel.routeToConfirm();
                // } else {
                // toastification.show(
                //   type: ToastificationType.error,
                //   style: ToastificationStyle.fillColored,
                //   description: RichText(
                //     text: const TextSpan(
                //       text: 'Please enter a complete 4-digit PIN.',
                //     ),
                //   ),
                //   showProgressBar: false,
                //   context:
                //       context, // optional if you use ToastificationWrapper
                //   title: Text('An error occured'),
                //   alignment: Alignment.topCenter,
                //   autoCloseDuration: const Duration(seconds: 4),
                // );
                //  }
              } else if (buttonText.isNotEmpty) {
                //  viewModel.onNumberPressed(buttonText);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              child: Center(
                child:
                    index == 9
                        ? SvgPicture.asset(AppImages.deleteIcon)
                        : index == 11
                        ? SvgPicture.asset(AppImages.arrowForwardIcon)
                        : Text(
                          buttonText,
                          style: GoogleFonts.albertSans(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
              ),
            ),
          );
        },
      ),
    );
  }
}
