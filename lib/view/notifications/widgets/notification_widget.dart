import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final bool isRead;
  final String category;

  const NotificationWidget({
    super.key,
    this.title = "Upcoming Bill Payment",
    this.message =
        "Get ready for your upcoming energy bill! Click to view consumption details.",
    this.date = "Feb 5, 2024",
    this.isRead = false,
    this.category = "general",
  });

  IconData _iconForCategory() {
    switch (category) {
      case 'transfer':
        return Icons.arrow_downward_rounded;
      case 'vaniti':
        return Icons.celebration_rounded;
      case 'ajo':
        return Icons.groups_rounded;
      case 'card':
        return Icons.credit_card_rounded;
      case 'reward':
        return Icons.redeem_rounded;
      case 'security':
        return Icons.shield_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _colorForCategory() {
    switch (category) {
      case 'transfer':
        return const Color(0xFF00C06D);
      case 'vaniti':
        return const Color(0xFFB57510);
      case 'ajo':
        return const Color(0xFF8A5A1A);
      case 'card':
        return const Color(0xFF007AFF);
      case 'reward':
        return const Color(0xFFFF9500);
      case 'security':
        return const Color(0xFFFF3B30);
      default:
        return const Color(0xFFB57510);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catColor = _colorForCategory();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? (isRead ? const Color(0xFF1E1A14) : const Color(0xFF262018))
            : (isRead ? const Color(0xFFF7F2E8) : Colors.white),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isRead
              ? (isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFECE4D6))
              : catColor.withValues(alpha: 0.35),
          width: isRead ? 1 : 1.4,
        ),
        boxShadow: isRead
            ? []
            : [
                BoxShadow(
                  color: catColor.withValues(alpha: isDark ? 0.15 : 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Icon Circle
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _iconForCategory(),
              color: catColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Notification Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: isRead ? FontWeight.w600 : FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: catColor,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    height: 1.4,
                    color: isDark ? Colors.white70 : const Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    date,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
