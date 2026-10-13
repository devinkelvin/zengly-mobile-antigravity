import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../transfer/widgets/widgets.dart';

class ShareReceiptScreen extends StatelessWidget {
  final ElectricityReceiptData receipt;

  const ShareReceiptScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final dashColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.16);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          "Share Receipt",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 0,
          ),
        ),
      ),
      body: SingleChildScrollView(
      padding: AppDimensions.newViewPadding,

        child: Column(
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: ReceiptShapePainter(
                      context: context,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Row(
                        children: [
                          const _DistributionLogo(),
                          Spacer(),
                          Text(
                            "Transaction Receipt",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Successful",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                      SizedBox(height: 4),
                      Text(
                        receipt.date,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                      ),
                      SizedBox(height: 24),
                      DottedDashedLine(
                        height: 1,
                        width: double.infinity,
                        axis: Axis.horizontal,
                        dashWidth: 2,
                        dashSpace: 8,
                        dashColor: dashColor,
                      ),
                      SizedBox(height: 24),
                      LineDetail(
                        title: "Distribution Company",
                        detail: receipt.distributionCompany,
                      ),
                      LineDetail(
                        title: "Meter Number",
                        detail: receipt.meterNumber,
                      ),
                      LineDetail(
                        title: "Customer Name",
                        detail: receipt.customerName,
                      ),
                      _WrappingLineDetail(
                        title: "Service Address",
                        detail: receipt.serviceAddress,
                      ),
                      LineDetail(
                        title: "Purchase Type",
                        detail: receipt.purchaseType,
                      ),
                      LineDetail(
                        title: "Units Purchased",
                        detail: receipt.unitsPurchased,
                      ),
                      LineDetail(title: "Token", detail: receipt.token),
                      LineDetail(title: "Cost of Unit", detail: receipt.amount),
                      LineDetail(title: "Date", detail: receipt.date),
                      SizedBox(height: 8),
                      DottedDashedLine(
                        height: 1,
                        width: double.infinity,
                        axis: Axis.horizontal,
                        dashWidth: 2,
                        dashSpace: 8,
                        dashColor: dashColor,
                      ),
                      SizedBox(height: 24),
                      LineDetail(
                        title: "Transaction ID",
                        detail: receipt.transactionId,
                        isSuperBold: true,
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
                    backgroundColor:
                        Theme.of(context).colorScheme.outlineVariant,
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
                    backgroundColor:
                        Theme.of(context).colorScheme.outlineVariant,
                    textColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DistributionLogo extends StatelessWidget {
  const _DistributionLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "EK",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF003DA5),
              ),
            ),
            TextSpan(
              text: "EDC",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFD52B1E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WrappingLineDetail extends StatelessWidget {
  final String title;
  final String detail;

  const _WrappingLineDetail({required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              detail,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
