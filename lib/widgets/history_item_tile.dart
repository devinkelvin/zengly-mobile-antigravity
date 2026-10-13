import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../data/data.dart';

class HistoryItemTile extends StatelessWidget {
  final TransactionHistoryModel transaction;
  final VoidCallback? onTap;
  final bool isGrouped;

  const HistoryItemTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.isGrouped = false,
  });

  Color _statusColor(BuildContext context) {
    switch (transaction.status) {
      case TransactionStatus.successful:
        return const Color(0xFF34C759);
      case TransactionStatus.pending:
        return const Color(0xFFFF9500);
      case TransactionStatus.failed:
        return Theme.of(context).colorScheme.error;
      case TransactionStatus.reversed:
        return const Color(0xFF34C759);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formattedAmount = NumberFormat("#,##0.00").format(
      transaction.amount,
    );
    final amountText =
        "${transaction.isCredit ? '+' : '-'}₦$formattedAmount";

    final content = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF2C2822)
                    : const Color(0xFFEDE5D8),
              ),
              child: Center(
                child: Image.asset(
                  transaction.displayImage,
                  height: 22,
                  width: 22,
                  fit: BoxFit.contain,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.9)
                      : const Color(0xFF2B251B),
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.date,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountText,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.status.label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _statusColor(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (isGrouped) {
      return content;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF211D16)
            : Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: content,
    );
  }
}
