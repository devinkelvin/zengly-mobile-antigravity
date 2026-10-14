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

  _TransactionBadgeConfig _badgeConfig() {
    final title = transaction.title.toLowerCase();

    if (transaction.category == TransactionCategory.electricityPayment ||
        title.contains("electricity") ||
        title.contains("ikedc") ||
        title.contains("ekedc")) {
      return const _TransactionBadgeConfig(
        icon: Icons.bolt_rounded,
        color: Color(0xFF0288D1),
      );
    }
    if (transaction.category == TransactionCategory.airtime ||
        title.contains("airtime")) {
      return const _TransactionBadgeConfig(
        icon: Icons.phone_iphone_rounded,
        color: Color(0xFF8E24AA),
      );
    }
    if (transaction.category == TransactionCategory.data ||
        title.contains("data")) {
      return const _TransactionBadgeConfig(
        icon: Icons.wifi_rounded,
        color: Color(0xFF7C3AED),
      );
    }
    if (transaction.category == TransactionCategory.sprayCash ||
        title.contains("spray") ||
        title.contains("baller")) {
      return const _TransactionBadgeConfig(
        icon: Icons.celebration_rounded,
        color: Color(0xFFE91E63),
      );
    }
    if (transaction.category == TransactionCategory.tvSubscription ||
        title.contains("dstv") ||
        title.contains("gotv")) {
      return const _TransactionBadgeConfig(
        icon: Icons.tv_rounded,
        color: Color(0xFFFF9800),
      );
    }
    if (transaction.category == TransactionCategory.walletReversal ||
        title.contains("reversal")) {
      return const _TransactionBadgeConfig(
        icon: Icons.history_rounded,
        color: Color(0xFF00ACC1),
      );
    }
    if (transaction.category == TransactionCategory.walletTopup ||
        title.contains("salary") ||
        title.contains("top-up") ||
        title.contains("topup") ||
        transaction.isCredit) {
      return const _TransactionBadgeConfig(
        icon: Icons.south_west_rounded,
        color: Color(0xFF10B981),
      );
    }

    // Default Debit / Transfer
    return const _TransactionBadgeConfig(
      icon: Icons.north_east_rounded,
      color: Color(0xFFB57510),
    );
  }

  Color _statusColor() {
    switch (transaction.status) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badge = _badgeConfig();
    final statusColor = _statusColor();

    final formattedAmount = NumberFormat("#,##0.00").format(
      transaction.amount,
    );
    final amountSign = transaction.isCredit ? "+" : "-";
    final amountText = "$amountSign₦$formattedAmount";

    final content = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Upgraded Luxury Squircle Category Badge
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: badge.color.withValues(alpha: isDark ? 0.16 : 0.10),
                border: Border.all(
                  color: badge.color.withValues(alpha: isDark ? 0.28 : 0.20),
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Icon(
                  badge.icon,
                  size: 22,
                  color: badge.color,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Title & Timestamp
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        transaction.date,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      ),
                      if (transaction.recipient != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          "• ${transaction.recipient}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Amount & Status Micro-Pill
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  amountText,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: transaction.isCredit
                        ? const Color(0xFF10B981)
                        : (isDark ? Colors.white : const Color(0xFF1A1A1A)),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: isDark ? 0.15 : 0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        transaction.status.label,
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
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
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: content,
    );
  }
}

class _TransactionBadgeConfig {
  final IconData icon;
  final Color color;

  const _TransactionBadgeConfig({required this.icon, required this.color});
}
