import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../transfer/widgets/widgets.dart';

class RequestDetailsScreen extends StatefulWidget {
  final TransactionHistoryModel transaction;

  const RequestDetailsScreen({super.key, required this.transaction});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  static const _token = "3456-4567-9876-9876-8987";
  static const _distributionCompany = "Eko Electricity";
  static const _meterNumber = "57689464638";
  static const _customerName = "Mary Ann Joe";
  static const _serviceAddress = "20 Ololunlgbon Street, Lekki, Lagos, Nigeria";
  static const _purchaseType = "Prepaid";
  static const _unitsPurchased = "4.4 kWh";

  void _copyToken() {
    Clipboard.setData(const ClipboardData(text: _token)).then((_) {
      if (!mounted) return;
      AppOverlays.showToast(
        context: context,
        message: "Copied to clipboard",
        toastType: ToastificationType.success,
      );
    });
  }

  void _openShareReceipt() {
    final transaction = widget.transaction;
    final formattedAmount =
        "₦${NumberFormat.decimalPattern().format(transaction.amount)}";
    context.pushNamed(
      AppRouter.shareReceipt,
      extra: ElectricityReceiptData(
        distributionCompany: _distributionCompany,
        meterNumber: _meterNumber,
        customerName: _customerName,
        serviceAddress: _serviceAddress,
        purchaseType: _purchaseType,
        unitsPurchased: _unitsPurchased,
        token: _token,
        amount: formattedAmount,
        date: transaction.date,
        transactionId: "26022509010053732818832",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    final formattedAmount = NumberFormat.decimalPattern().format(
      transaction.amount,
    );
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
          "Request Details",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                "Report Issue",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                          vertical: 28,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "₦$formattedAmount.00",
                                        style: GoogleFonts.inter(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        transaction.date,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.scrim,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                  ),
                                  child: Icon(
                                    Icons.person_add_alt,
                                    size: 18,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ],
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
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Your Token",
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.scrim,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "$_token...",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 24,
                                    width: 1,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                  ),
                                  SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: _copyToken,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Copy",
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        SvgPicture.asset(
                                          AppImages.copy,
                                          width: 16,
                                          height: 16,
                                          colorFilter: ColorFilter.mode(
                                            Theme.of(
                                              context,
                                            ).colorScheme.error,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                            SizedBox(height: 20),
                            _TimelineStep(
                              label: "Payment",
                              detail: transaction.date,
                              isComplete: true,
                            ),
                            _TimelineStep(
                              label: "Token Generation",
                              detail: transaction.date,
                              isComplete: true,
                            ),
                            _TimelineStep(
                              label: "SMS/Email Delivery",
                              detail: transaction.date,
                              isComplete: true,
                            ),
                            _TimelineStep(
                              label: "Remote Load",
                              detail: "Failed",
                              isComplete: false,
                              isLast: true,
                              errorMessage:
                                  "Token couldn't be loaded automatically. Please load it manually.",
                            ),
                            SizedBox(height: 4),
                            DottedDashedLine(
                              height: 1,
                              width: double.infinity,
                              axis: Axis.horizontal,
                              dashWidth: 8,
                              dashSpace: 8,
                              dashColor: dashColor,
                            ),
                            SizedBox(height: 20),
                            LineDetail(
                              title: "Distribution Company",
                              detail: _distributionCompany,
                            ),
                            LineDetail(
                              title: "Meter Number",
                              detail: _meterNumber,
                            ),
                            LineDetail(
                              title: "Customer Name",
                              detail: _customerName,
                            ),
                            _WrappingLineDetail(
                              title: "Service Address",
                              detail: _serviceAddress,
                            ),
                            LineDetail(
                              title: "Purchase Type",
                              detail: _purchaseType,
                            ),
                            LineDetail(
                              title: "Units Purchased",
                              detail: _unitsPurchased,
                            ),
                            LineDetail(title: "Token", detail: _token),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: _openShareReceipt,
                      actionText: "Share Receipt",
                      icon: Icons.share,
                      backgroundColor:
                          Theme.of(context).colorScheme.outlineVariant,
                      textColor: Theme.of(context).colorScheme.onSurface,
                      borderRadius: 100,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String label;
  final String detail;
  final bool isComplete;
  final bool isLast;
  final String? errorMessage;

  const _TimelineStep({
    required this.label,
    required this.detail,
    required this.isComplete,
    this.isLast = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isComplete
                          ? Theme.of(context).colorScheme.onSecondary
                          : Theme.of(context).colorScheme.surface,
                ),
                child:
                    isComplete
                        ? Icon(
                          Icons.check,
                          size: 14,
                          color: Theme.of(context).colorScheme.surface,
                        )
                        : null,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 30,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.16),
                ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (errorMessage != null) ...[
                          SizedBox(height: 4),
                          Text(
                            errorMessage!,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    detail,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color:
                          isComplete
                              ? Theme.of(context).colorScheme.scrim
                              : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.72,
              ),
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
