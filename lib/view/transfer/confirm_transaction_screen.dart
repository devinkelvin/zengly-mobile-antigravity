import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class ConfirmTransactionScreen extends ConsumerStatefulWidget {
  final TransferResult transfer;

  const ConfirmTransactionScreen({super.key, required this.transfer});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfirmTransactionScreenState();
}

class _ConfirmTransactionScreenState
    extends ConsumerState<ConfirmTransactionScreen> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Automatically trigger the transaction PIN bottom sheet after review renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _promptTransactionPin();
    });
  }

  Future<void> _promptTransactionPin() async {
    final pin = await TransactionPinBottomSheet.show(
      context,
      title: "Enter Transaction PIN",
      actionText: "Send Transfer",
      amountSummary: "₦${NumberFormat("#,##0.00").format(widget.transfer.amount)}",
    );

    if (pin != null && pin.length == 4) {
      _submit();
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    AppOverlays.showLoadingDialog(context: context);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.pop();

    final now = DateTime.now();
    final reference = "TRF${now.millisecondsSinceEpoch}";
    final t = widget.transfer;
    context.goNamed(
      AppRouter.transferSuccess,
      extra: TransferResult(
        recipientName: t.recipientName,
        recipientAccountNumber: t.recipientAccountNumber,
        recipientBank: t.recipientBank,
        sourceBank: t.sourceBank,
        sourceAccountNumber: t.sourceAccountNumber,
        amount: t.amount,
        note: t.note,
        fee: t.fee,
        date: now,
        transactionReference: reference,
        providerReference: "PRV$reference",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF14120E);
    const cardColor = Color(0xFF1F1D19);
    const dividerColor = Color(0xFF2C2822);
    const primaryAmber = Color(0xFFB57510);
    final currencyFormat = NumberFormat("#,##0.00");

    final t = widget.transfer;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF25231F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          "Review Transfer",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Amount Highlight Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primaryAmber.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Transfer Amount",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₦${currencyFormat.format(t.amount)}",
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryAmber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: primaryAmber,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Zero Fee Transfer",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: primaryAmber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Transaction Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recipient Details",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Recipient Name Row
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: primaryAmber.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            t.recipientName.isNotEmpty
                                ? t.recipientName[0].toUpperCase()
                                : "Z",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: primaryAmber,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.recipientName,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${t.recipientBank} • ${t.recipientAccountNumber}",
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: dividerColor, height: 1),
                    const SizedBox(height: 16),

                    _buildDetailRow("Source Account", "Zengly Main Wallet"),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      "Transaction Fee",
                      t.fee != null && t.fee! > 0
                          ? "₦${currencyFormat.format(t.fee)}"
                          : "₦0.00 (Free)",
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      "Total Debit",
                      "₦${currencyFormat.format(t.amount + (t.fee ?? 0))}",
                      isHighlighted: true,
                    ),

                    if (t.note != null && t.note!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow("Description / Note", t.note!),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Security Guarantee Pill
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.security_rounded,
                    color: primaryAmber,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Protected by Zengly End-to-End Encryption",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Solid Amber Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _promptTransactionPin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAmber,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Send Transfer",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white60,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
            color: isHighlighted ? const Color(0xFFC58314) : Colors.white,
          ),
        ),
      ],
    );
  }
}
