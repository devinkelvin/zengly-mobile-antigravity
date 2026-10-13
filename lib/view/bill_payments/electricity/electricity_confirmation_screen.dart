import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../transfer/widgets/widgets.dart';
import '../../view.dart';

class ElectricityConfirmationScreen extends ConsumerWidget {
  const ElectricityConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Confirmation",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              "Verify and confirm this transaction",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
              ),
            ),
            SizedBox(height: 10),
            Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: ReceiptShapePainter(
                      context: context,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      ElectricityTile(title: "Type", content: "Electricity"),
                      ElectricityTile(
                        title: "Disco",
                        content: "Ikeja Electric",
                      ),
                      ElectricityTile(
                        title: "Meter type",
                        content: "Prepaid",
                      ),
                      ElectricityTile(
                        title: "Meter Number",
                        content: "0464368396",
                      ),
                      ElectricityTile(
                        title: "Meter Name",
                        content: "Maxwell Chimaroke Ufughiree",
                      ),
                      ElectricityTile(
                        title: "Meter Address",
                        content: "24 Yennah Greek, Ikeja",
                      ),
                      ElectricityTile(
                        title: "Phone number",
                        content: "+2348089876654",
                      ),
                      ElectricityTile(
                        title: "Amount",
                        content: "₦ 20,000.00",
                      ),
                      ElectricityTile(title: "Fee", content: "₦ 50.00"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () {
                  context.goNamed(AppRouter.electricityTransactionStatusScreen);
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
