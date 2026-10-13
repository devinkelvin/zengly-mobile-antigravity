import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';

class FoundDevice extends ConsumerWidget {
  const FoundDevice({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        AppOverlays.openFoundDeviceSheet(context: context);
      },
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Image.asset(AppImages.dummyPerson),
          ),
          SizedBox(height: 10),
          Text(
            "@Sammy",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class FoundDeviceBottomSheet extends ConsumerWidget {
  const FoundDeviceBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          "Spray Confirmation",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inverseSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(AppImages.dummyPerson),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Awusu Samuel (@Sammy)",
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "2975299801 ",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.scrim,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),
              SecondLineDetail(
                title: "Transfer Amount ",
                detail: "₦100,000.00",
              ),
              SizedBox(height: 24),
              SecondLineDetail(title: "Denomination", detail: "₦100"),
              SizedBox(height: 24),
              SecondLineDetail(title: "Spray Effects", detail: "Flying Cash"),
              SizedBox(height: 24),
              DottedDashedLine(
                height: 1,
                width: double.infinity,
                axis: Axis.horizontal,
                dashWidth: 8,
                dashSpace: 8,
                dashColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.16),
              ),
              SizedBox(height: 24),
              SecondLineDetail(title: "Transfer fee", detail: "₦100"),
            ],
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              context.pop();
              context.goNamed(AppRouter.dashboard);
            },
            actionText: "Proceed",
          ),
        ),
      ],
    );
  }
}
