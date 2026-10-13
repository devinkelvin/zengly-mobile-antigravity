import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../widgets/widgets.dart';

class ConfirmGiftcardSheet extends ConsumerWidget {
  const ConfirmGiftcardSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Text(
          "Confirmation",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transaction Type",
                        style: GoogleFonts.raleway(
                          color: Theme.of(context).colorScheme.scrim,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Gift Card",
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(50),
                    child: Image.asset(
                      AppImages.canadaFlag,
                      width: 36,
                      height: 36,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              LineDetail(
                title: "Country",
                detail: "United States",
                isRaleway: true,
              ),
              LineDetail(title: "Amount", detail: "₦9,415.00", isRaleway: true),
              LineDetail(title: "Quantity", detail: "2", isRaleway: true),
              LineDetail(title: "Fee", detail: "₦100", isRaleway: true),
            ],
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              context.pop();
            },
            actionText: "Continue",
          ),
        ),
      ],
    );
  }
}
