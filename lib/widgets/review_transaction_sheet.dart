import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'transaction_pin_bottom_sheet.dart';

class ReviewTransactionSheet extends StatefulWidget {
  final String title;
  final String recipientName;
  final String recipientSubtitle;
  final String amount;
  final String fee;
  final String totalDebit;
  final String paymentSource;
  final Future<void> Function()? onConfirm;

  const ReviewTransactionSheet({
    super.key,
    this.title = "Review Transaction",
    required this.recipientName,
    required this.recipientSubtitle,
    required this.amount,
    this.fee = "₦0.00",
    required this.totalDebit,
    this.paymentSource = "Zengly Wallet (Sterling Virtual)",
    this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    String title = "Review Transaction",
    required String recipientName,
    required String recipientSubtitle,
    required String amount,
    String fee = "₦0.00",
    required String totalDebit,
    String paymentSource = "Zengly Wallet (Sterling Virtual)",
    Future<void> Function()? onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReviewTransactionSheet(
        title: title,
        recipientName: recipientName,
        recipientSubtitle: recipientSubtitle,
        amount: amount,
        fee: fee,
        totalDebit: totalDebit,
        paymentSource: paymentSource,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<ReviewTransactionSheet> createState() => _ReviewTransactionSheetState();
}

class _ReviewTransactionSheetState extends State<ReviewTransactionSheet> {
  bool _isProcessing = false;

  Future<void> _handleConfirm() async {
    if (_isProcessing) return;

    // Pop the review sheet first
    Navigator.of(context).pop();

    // Show the transaction PIN bottom sheet
    final pin = await TransactionPinBottomSheet.show(
      context,
      title: "Authorize Payment",
      amountSummary: widget.totalDebit,
    );

    if (pin != null && pin.length == 4) {
      if (widget.onConfirm != null) {
        await widget.onConfirm!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6B655D);
    final sheetBg = isDark ? const Color(0xFF1E1A14) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEBE3D7);

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : const Color(0xFFD6CEBF),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Recipient Preview Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: primaryColor.withValues(alpha: 0.15),
                  child: Text(
                    widget.recipientName.isNotEmpty ? widget.recipientName[0].toUpperCase() : "Z",
                    style: GoogleFonts.raleway(fontWeight: FontWeight.w800, color: primaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.recipientName,
                              style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.verified_rounded, size: 14, color: primaryColor),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.recipientSubtitle,
                        style: GoogleFonts.inter(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Financial Breakdown Table
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _buildRow("Transfer Amount", widget.amount, textSecondary, textPrimary, false),
                const Divider(height: 18),
                _buildRow("Platform Fee", widget.fee, textSecondary, const Color(0xFF34C759), false),
                const Divider(height: 18),
                _buildRow("Other Charges", "₦0.00", textSecondary, textPrimary, false),
                const Divider(height: 18),
                _buildRow("Payment Source", widget.paymentSource, textSecondary, textPrimary, false),
                const Divider(height: 22, thickness: 1.2),
                _buildRow("Total Debit", widget.totalDebit, textPrimary, primaryColor, true),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Primary Confirm & Pay Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isProcessing ? null : _handleConfirm,
              child: _isProcessing
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text("Confirm & Pay", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, Color labelColor, Color valueColor, bool isBold) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isBold ? 14 : 12.5,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: labelColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
