import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

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
  void _downloadReceipt() {
    HapticFeedback.lightImpact();
    AppOverlays.showToast(
      context: context,
      message: "Receipt downloaded to your device as PDF",
      toastType: ToastificationType.success,
    );
  }

  void _shareReceipt() {
    HapticFeedback.lightImpact();
    AppOverlays.showToast(
      context: context,
      message: "Sharing receipt...",
      toastType: ToastificationType.info,
    );
  }

  void _reportIssue() {
    context.pushNamed(
      AppRouter.transactionDispute,
      extra: {
        'ref': widget.transfer.transactionReference,
        'amount': widget.transfer.amount,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transfer = widget.transfer;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          "Official Receipt",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _reportIssue,
            icon: const Icon(Icons.info_outline_rounded, size: 22),
            tooltip: "Report a problem",
          ),
          IconButton(
            onPressed: _shareReceipt,
            icon: const Icon(Icons.share_outlined, size: 22),
            tooltip: "Share",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          children: [
            // Receipt Canvas Card
            Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: ReceiptShapePainter(
                      context: context,
                      color: isDark
                          ? const Color(0xFF221D17)
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      // Header Row
                      Row(
                        children: [
                          SvgPicture.asset(AppImages.zenglyIcon, height: 26),
                          const SizedBox(width: 8),
                          Text(
                            "ZENGLY",
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              letterSpacing: 1.2,
                              color: const Color(0xFFB57510),
                            ),
                          ),
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

                      // Large Amount Hero
                      Text(
                        amountText,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateText,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),
                      DottedDashedLine(
                        height: 1,
                        width: double.infinity,
                        axis: Axis.horizontal,
                        dashWidth: 8,
                        dashSpace: 8,
                        dashColor: dashColor,
                      ),
                      const SizedBox(height: 20),

                      // Transaction Line Details
                      LineDetail(title: "Transfer Amount", detail: amountText),
                      LineDetail(
                        title: "Transfer Fee",
                        detail: transfer.fee <= 0
                            ? "₦0.00 (Free Transfer)"
                            : "₦${NumberFormat.decimalPattern().format(transfer.fee)}",
                      ),
                      LineDetail(
                        title: "Recipient",
                        detail: transfer.recipientName,
                      ),
                      LineDetail(
                        title: "Destination Bank",
                        detail: transfer.recipientBank.isEmpty
                            ? "Zengly Wallet"
                            : transfer.recipientBank,
                      ),
                      LineDetail(
                        title: "Account Number",
                        detail: transfer.recipientAccountNumber,
                      ),
                      LineDetail(title: "Source Wallet", detail: transfer.sourceBank),
                      const SizedBox(height: 8),
                      DottedDashedLine(
                        height: 1,
                        width: double.infinity,
                        axis: Axis.horizontal,
                        dashWidth: 8,
                        dashSpace: 8,
                        dashColor: dashColor,
                      ),
                      const SizedBox(height: 20),
                      LineDetail(
                        title: "Transaction Reference",
                        detail: transfer.transactionReference,
                        isSuperBold: true,
                      ),
                      LineDetail(
                        title: "CBN Session Reference",
                        detail: transfer.providerReference.isEmpty
                            ? "NIP-${transfer.transactionReference}"
                            : transfer.providerReference,
                        isSuperBold: true,
                      ),

                      const SizedBox(height: 16),
                      // Verified Watermark
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB57510).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.verified_user_rounded,
                              size: 16,
                              color: Color(0xFFB57510),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Verified Electronic Fund Transfer",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFB57510),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Dual Share Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onPressed: _downloadReceipt,
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
                    onPressed: _shareReceipt,
                    actionText: "Share Receipt",
                    icon: Icons.share_outlined,
                    fontSize: 13,
                    horizontalPadding: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Return to Home Primary Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  context.go(AppRouter.dashboard);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Return to Home",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB57510),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

