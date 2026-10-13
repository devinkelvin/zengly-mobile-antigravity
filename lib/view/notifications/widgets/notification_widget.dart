import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationWidget extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final bool isRead;

  const NotificationWidget({
    super.key,
    this.title = "Upcoming Bill Payment",
    this.message =
        "Get ready for your upcoming energy bill! Click to view consumption details.",
    this.date = "Feb 5, 2024",
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    final dimColor = Theme.of(context).colorScheme.scrim;
    final titleColor =
        isRead ? dimColor : Theme.of(context).colorScheme.onSurface;
    final dotColor = isRead ? dimColor : Theme.of(context).colorScheme.primary;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: isRead ? 0.6 : 1.0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.4,
                color: dimColor,
              ),
            ),
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              date,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: dimColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
