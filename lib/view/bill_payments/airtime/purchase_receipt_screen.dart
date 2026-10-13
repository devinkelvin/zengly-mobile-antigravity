import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../transfer/widgets/widgets.dart';

class PurchaseReceiptScreen extends StatelessWidget {
  final PurchaseReceiptData receipt;

  const PurchaseReceiptScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
        ),
        title: Text(
          "Share Receipt",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          children: [
            Stack(
              children: [
                ReceiptShape(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Row(
                        children: [
                          SvgPicture.asset(AppImages.zenglyIcon, height: 24),
                          SizedBox(width: 8),
                          Text(
                            "Zengly",
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Transaction Receipt",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.scrim,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Successful",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        receipt.amount,
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (receipt.cashback != null) ...[
                        SizedBox(height: 4),
                        Text(
                          "+${receipt.cashback}",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
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
                      LineDetail(title: "Amount", detail: receipt.amount),
                      LineDetail(
                        title: "Recipient mobile",
                        detail: receipt.phoneNumber,
                      ),
                      LineDetail(title: "Transaction Type", detail: receipt.type),
                      LineDetail(
                        title: "Payment Method",
                        detail: receipt.paymentMethod,
                      ),
                      LineDetail(
                        title: "Transaction Date",
                        detail: receipt.transactionDate,
                      ),
                      SizedBox(height: 8),
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
                      LineDetail(
                        title: "Transaction Reference",
                        detail: receipt.transactionReference,
                      ),
                      LineDetail(
                        title: "Provider Reference",
                        detail: receipt.providerReference,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {},
                    actionText: "Share as image",
                    fontSize: 13,
                    horizontalPadding: 10,
                    backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                    textColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    onPressed: () {},
                    actionText: "Share as PDF",
                    fontSize: 13,
                    horizontalPadding: 10,
                    backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                    textColor: Theme.of(context).colorScheme.onSurface,
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
