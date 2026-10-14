import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../transfer/widgets/widgets.dart';

class ShareReceiptScreen extends StatelessWidget {
  final ElectricityReceiptData receipt;

  const ShareReceiptScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF6B5E4A);
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
          "Official Receipt",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AppOverlays.showToast(
                context: context,
                message: "Receipt shared",
                toastType: ToastificationType.info,
              );
            },
            icon: const Icon(Icons.share_outlined, size: 22),
          ),
          const SizedBox(width: 8),
        ],
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
                      color: isDark
                          ? const Color(0xFF221D17)
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
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
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          const _DistributionLogo(),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: const Color(0xFF10B981).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Successful",
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        receipt.amount,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        receipt.date,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      DottedDashedLine(
                        height: 1,
                        width: double.infinity,
                        axis: Axis.horizontal,
                        dashWidth: 2,
                        dashSpace: 8,
                        dashColor: dashColor,
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 8),
                      DottedDashedLine(
                        height: 1,
                        width: double.infinity,
                        axis: Axis.horizontal,
                        dashWidth: 2,
                        dashSpace: 8,
                        dashColor: dashColor,
                      ),
                      const SizedBox(height: 20),
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
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      AppOverlays.showToast(
                        context: context,
                        message: "Receipt saved to downloads as PDF",
                        toastType: ToastificationType.success,
                      );
                    },
                    actionText: "Download PDF",
                    icon: Icons.picture_as_pdf_outlined,
                    fontSize: 13,
                    horizontalPadding: 10,
                    backgroundColor: isDark
                        ? const Color(0xFF26211B)
                        : Theme.of(context).colorScheme.outlineVariant,
                    textColor: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      AppOverlays.showToast(
                        context: context,
                        message: "Opening share options...",
                        toastType: ToastificationType.info,
                      );
                    },
                    actionText: "Share Receipt",
                    icon: Icons.share_outlined,
                    fontSize: 13,
                    horizontalPadding: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
