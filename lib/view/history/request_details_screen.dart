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
  static const _distributionCompany = "Eko Electricity (EKEDC)";
  static const _meterNumber = "57689464638";
  static const _customerName = "Mary Ann Joe";
  static const _serviceAddress = "20 Ololunlgbon Street, Lekki Phase 1, Lagos";
  static const _purchaseType = "Prepaid";
  static const _unitsPurchased = "4.4 kWh";

  void _copyToken() {
    Clipboard.setData(const ClipboardData(text: _token)).then((_) {
      if (!mounted) return;
      AppOverlays.showToast(
        context: context,
        message: "Token copied to clipboard",
        toastType: ToastificationType.success,
      );
    });
  }

  void _openShareReceipt() {
    final t = widget.transaction;
    final formattedAmount =
        "₦${NumberFormat.decimalPattern().format(t.amount)}";

    if (t.category == TransactionCategory.electricityPayment) {
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
          date: t.date,
          transactionId: "26022509010053732818832",
        ),
      );
    } else {
      context.pushNamed(
        AppRouter.transferReceipt,
        extra: TransferResult(
          amount: t.amount,
          date: DateTime.now(),
          recipientName: t.recipient ?? t.title,
          recipientBank: "Commercial Bank",
          recipientAccountNumber: "0428658653",
          sourceBank: "Zengly Main Wallet",
          sourceAccountNumber: "2087654321",
          note: t.title,
          transactionReference: "ZG-${t.hashCode.abs().toString().padLeft(10, '0')}",
          providerReference: "NIP-999014${t.hashCode.abs().toString().padLeft(8, '0')}",
          fee: 0,
        ),
      );
    }
  }

  void _reportIssue() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF221D17)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.help_outline_rounded,
                color: Color(0xFFB57510), size: 22),
            const SizedBox(width: 8),
            Text(
              "Report Transaction",
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Text(
          "Need help with transaction '${widget.transaction.title}'?\n\nOur customer support team is available 24/7 to resolve any disputed transfers or delayed settlements.",
          style: GoogleFonts.inter(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB57510),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AppOverlays.showToast(
                context: context,
                message: "Dispute opened. Our team will contact you shortly.",
                toastType: ToastificationType.success,
              );
            },
            child: const Text("Open Dispute"),
          ),
        ],
      ),
    );
  }

  Color _statusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.successful:
        return const Color(0xFF10B981);
      case TransactionStatus.pending:
        return const Color(0xFFF59E0B);
      case TransactionStatus.failed:
        return const Color(0xFFEF4444);
      case TransactionStatus.reversed:
        return const Color(0xFF06B6D4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.transaction;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formattedAmount = NumberFormat("#,##0.00").format(t.amount);
    final statusColor = _statusColor(t.status);
    final isElectricity = t.category == TransactionCategory.electricityPayment;
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
          "Transaction Details",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: TextButton.icon(
              onPressed: _reportIssue,
              icon: const Icon(Icons.help_outline_rounded, size: 16),
              label: Text(
                "Dispute",
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                backgroundColor: isDark
                    ? const Color(0xFF26211B)
                    : Theme.of(context).colorScheme.outlineVariant,
                foregroundColor: isDark ? Colors.white70 : Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.newViewPadding,
        child: Column(
          children: [
            // Receipt Shape Canvas
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
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // Status & Category Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB57510).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              t.category.label,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFB57510),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  t.status.label,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Large Amount Hero
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${t.isCredit ? '+' : '-'}₦$formattedAmount",
                                  style: GoogleFonts.inter(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    color: t.isCredit
                                        ? const Color(0xFF10B981)
                                        : (isDark ? Colors.white : const Color(0xFF1A1A1A)),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t.date,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: isDark ? Colors.white60 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFB57510).withValues(alpha: 0.15),
                            ),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              size: 20,
                              color: Color(0xFFB57510),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Electricity Token Box (if electricity)
                      if (isElectricity) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2A231A) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFB57510).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "RECHARGE TOKEN",
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: const Color(0xFFB57510),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _token,
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: _copyToken,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFB57510).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.copy_rounded,
                                        size: 14,
                                        color: Color(0xFFB57510),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Copy",
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFB57510),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      DottedDashedLine(
                        height: 1,
                        width: double.infinity,
                        axis: Axis.horizontal,
                        dashWidth: 8,
                        dashSpace: 8,
                        dashColor: dashColor,
                      ),
                      const SizedBox(height: 20),

                      // Dynamic Transaction Details
                      LineDetail(title: "Transaction Title", detail: t.title),
                      if (t.recipient != null)
                        LineDetail(title: "Recipient / Counterparty", detail: t.recipient!),
                      if (isElectricity) ...[
                        LineDetail(title: "Distribution Company", detail: _distributionCompany),
                        LineDetail(title: "Meter Number", detail: _meterNumber),
                        LineDetail(title: "Customer Name", detail: _customerName),
                        LineDetail(title: "Units Purchased", detail: _unitsPurchased),
                      ] else ...[
                        LineDetail(title: "Funding Source", detail: "Zengly Main Wallet"),
                        LineDetail(title: "Channel", detail: "Instant Electronic Transfer"),
                        LineDetail(
                          title: "Transaction Fee",
                          detail: "₦0.00",
                        ),
                      ],
                      LineDetail(
                        title: "Reference ID",
                        detail: "ZG-${t.hashCode.abs().toString().padLeft(10, '0')}",
                        isSuperBold: true,
                      ),

                      const SizedBox(height: 10),
                      DottedDashedLine(
                        height: 1,
                        width: double.infinity,
                        axis: Axis.horizontal,
                        dashWidth: 8,
                        dashSpace: 8,
                        dashColor: dashColor,
                      ),
                      const SizedBox(height: 20),

                      // Lifecycle Timeline
                      _TimelineStep(
                        label: "Transaction Initiated",
                        detail: t.date,
                        isComplete: true,
                      ),
                      _TimelineStep(
                        label: "Security PIN Authorized",
                        detail: "Verified",
                        isComplete: true,
                      ),
                      _TimelineStep(
                        label: "Network Settlement",
                        detail: t.status == TransactionStatus.successful
                            ? "Completed"
                            : (t.status == TransactionStatus.pending ? "In Progress" : "Failed"),
                        isComplete: t.status == TransactionStatus.successful,
                        isLast: true,
                        errorMessage: t.status == TransactionStatus.failed
                            ? "Network timeout occurred. Any debited amount has been queued for auto-reversal."
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Share Receipt CTA
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: _openShareReceipt,
                actionText: "View Official Receipt",
                icon: Icons.receipt_rounded,
              ),
            ),
            const SizedBox(height: 12),

            // Repeat Transaction Secondary
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () {
                  AppOverlays.showToast(
                    context: context,
                    message: "Setting up new transfer to ${t.recipient ?? t.title}",
                    toastType: ToastificationType.info,
                  );
                  context.pushNamed(AppRouter.selectRecipient, extra: false);
                },
                actionText: "Repeat Transaction",
                icon: Icons.replay_rounded,
                backgroundColor: isDark
                    ? const Color(0xFF26211B)
                    : Theme.of(context).colorScheme.outlineVariant,
                textColor: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
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
                  color: isComplete
                      ? const Color(0xFF10B981)
                      : (errorMessage != null
                          ? const Color(0xFFEF4444)
                          : (Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF332A1F)
                              : Colors.black12)),
                ),
                child: Icon(
                  isComplete
                      ? Icons.check
                      : (errorMessage != null ? Icons.close : Icons.circle),
                  size: 13,
                  color: Colors.white,
                ),
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
          const SizedBox(width: 12),
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
                          const SizedBox(height: 4),
                          Text(
                            errorMessage!,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFFEF4444),
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
                      fontWeight: FontWeight.w600,
                      color: isComplete
                          ? const Color(0xFF10B981)
                          : (errorMessage != null
                              ? const Color(0xFFEF4444)
                              : Theme.of(context).colorScheme.scrim),
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
