import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class ElectricityTransactionStatusScreen extends ConsumerStatefulWidget {
  const ElectricityTransactionStatusScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ElectricityTransactionStatusScreenState();
}

class _ElectricityTransactionStatusScreenState
    extends ConsumerState<ElectricityTransactionStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          color: Theme.of(context).colorScheme.onSurface,
          icon: Icon(Icons.close_outlined),
        ),
      ),
      body: Padding(
        padding: AppDimensions.viewPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity),
            RotatingCoinIcon(size: 130),
            SizedBox(height: 16),
            Text(
              "Transaction Complete",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: -1,
              ),
            ),
            Text(
              "Your Payment Has Been Processed Successfully",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.scrim,
                letterSpacing: 0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsetsDirectional.only(
                top: 8,
                start: 16,
                bottom: 16,
                end: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Here is your token",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                          color: Theme.of(context).colorScheme.scrim,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            height: 18,
                            width: 1,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 5),
                          SvgPicture.asset(AppImages.copy),
                          SizedBox(width: 5),
                          Text(
                            "Copy",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "2124-5467-8576-7484-8474",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {},
                    fontSize: 13,
                    horizontalPadding: 10,
                    actionText: "Download Receipt",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    onPressed: () {},
                    fontSize: 13,
                    horizontalPadding: 10,
                    actionText: "View Transaction",
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),
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
        ),
      ),
    );
  }
}
