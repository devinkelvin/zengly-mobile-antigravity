import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class TransferReceiptScreen extends ConsumerStatefulWidget {
  final TransferResult transfer;

  const TransferReceiptScreen({super.key, required this.transfer});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransferReceiptScreenState();
}

class _TransferReceiptScreenState extends ConsumerState<TransferReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    final transfer = widget.transfer;
    final dashColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.16);
    final amountText =
        "₦${NumberFormat.decimalPattern().format(transfer.amount)}";
    final dateText = DateFormat(
      "d MMM yyyy, h:mm:ss a",
    ).format(transfer.date);

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
        padding: AppDimensions.viewPadding,
        child: Column(
          children: [
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
                      SizedBox(height: 32,),
                      Row(
                        children: [
                          SvgPicture.asset(AppImages.zenglyIcon, height: 24),
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
                        amountText,
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        dateText,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.scrim,
                        ),
                      ),
                      SizedBox(height: 24),
                      DottedDashedLine(
                        height: 1,
                        width: double.infinity,
                        axis: Axis.horizontal,
                        dashWidth: 8,
                        dashSpace: 8,
                        dashColor: dashColor,
                      ),
                      SizedBox(height: 24),
                      LineDetail(title: "Amount", detail: amountText),
                      LineDetail(
                        title: "Our fee",
                        detail:
                            "₦${NumberFormat.decimalPattern().format(transfer.fee)}",
                      ),
                      LineDetail(
                        title: "Beneficiary",
                        detail: transfer.recipientName,
                      ),
                      LineDetail(title: "Source", detail: transfer.sourceBank),
                      LineDetail(
                        title: "Transaction Date",
                        detail: dateText,
                      ),
                      SizedBox(height: 8),
                      DottedDashedLine(
                        height: 1,
                        width: double.infinity,
                        axis: Axis.horizontal,
                        dashWidth: 8,
                        dashSpace: 8,
                        dashColor: dashColor,
                      ),
                      SizedBox(height: 24),
                      LineDetail(
                        title: "Transaction Reference",
                        detail: transfer.transactionReference,
                        isSuperBold: true,
                      ),
                      LineDetail(
                        title: "Provider Reference",
                        detail: transfer.providerReference,
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
                    icon: Icons.image_outlined,
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
                    icon: Icons.picture_as_pdf_outlined,
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
