import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class ReceiveBottomSheet extends StatelessWidget {
  const ReceiveBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Container(
          width: 96,
          height: 96,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: SvgPicture.asset(AppImages.fingerPrint2Icon),
        ),
        SizedBox(height: 16),
        Text(
          "Virtual account details",
          style: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 24),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: Radius.circular(20),
                    strokeWidth: 1,
                    color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
                    dashPattern: [8, 8],
                  ),

                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Your account number",
                          style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 0,
                            color: Theme.of(context).colorScheme.scrim,
                          ),
                        ),
                        SizedBox(width: double.infinity, height: 2),
                        GestureDetector(
                          onTap: () async {
                            Clipboard.setData(
                              ClipboardData(text: "9039438820"),
                            ).then((_) {
                              if (!context.mounted) {
                                return;
                              }
                              AppOverlays.showToast(
                                context: context,
                                message: "Account number copied successfully",
                                toastType: ToastificationType.success,
                              );
                            });
                          },
                          child: Text(
                            "9039438820",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              letterSpacing: 0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        // SizedBox(height: 2),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: [
                              LineDetail(
                                title: "Account name",
                                detail: "Ability Elijah",
                              ),
                              LineDetail(
                                title: "Bank name",
                                detail: "XYZ Bank",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                ),
              ),
              child: Text(
                "Copy Account Number",
                style: GoogleFonts.raleway(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () async {
              await SharePlus.instance.share(
                ShareParams(
                  subject: "Share Account Details",
                  sharePositionOrigin: Rect.fromPoints(
                    const Offset(2, 2),
                    const Offset(3, 3),
                  ),
                  text:
                      'Bank: Zengly /nAccount Number: 9039438820/nAccount Name: Ability Elijah',
                ),
              );
              if (context.mounted) {
                context.pop();
              }
            },
            actionText: "Share Details",
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
