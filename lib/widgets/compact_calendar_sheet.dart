import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'app_button.dart';

/// A compact, premium bottom-sheet calendar that displays exactly ONE month at a time.
/// Supports date range selection, quick preset filters, month navigation,
/// and adapts cleanly to both Light and Dark themes.
class CompactCalendarSheet extends StatefulWidget {
  final DateTimeRange initialRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTimeRange> onApply;

  const CompactCalendarSheet({
    super.key,
    required this.initialRange,
    this.firstDate,
    this.lastDate,
    required this.onApply,
  });

  static Future<DateTimeRange?> show({
    required BuildContext context,
    required DateTimeRange initialRange,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CompactCalendarSheet(
        initialRange: initialRange,
        firstDate: firstDate,
        lastDate: lastDate,
        onApply: (range) => Navigator.of(ctx).pop(range),
      ),
    );
  }

  @override
  State<CompactCalendarSheet> createState() => _CompactCalendarSheetState();
}

class _CompactCalendarSheetState extends State<CompactCalendarSheet> {
  late DateTime _displayedMonth;
  late DateTime _firstDate;
  late DateTime _lastDate;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _selectingEnd = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _firstDate = widget.firstDate ?? DateTime(2020);
    _lastDate = widget.lastDate ?? DateTime(now.year + 2, 12, 31);
    _startDate = DateTime(
      widget.initialRange.start.year,
      widget.initialRange.start.month,
      widget.initialRange.start.day,
    );
    _endDate = DateTime(
      widget.initialRange.end.year,
      widget.initialRange.end.month,
      widget.initialRange.end.day,
    );
    _displayedMonth = DateTime(_startDate!.year, _startDate!.month, 1);
  }

  void _onPrevMonth() {
    final prev = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    if (!prev.isBefore(DateTime(_firstDate.year, _firstDate.month, 1))) {
      setState(() => _displayedMonth = prev);
    }
  }

  void _onNextMonth() {
    final next = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    if (!next.isAfter(DateTime(_lastDate.year, _lastDate.month, 1))) {
      setState(() => _displayedMonth = next);
    }
  }

  void _selectPreset(String preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime start;
    DateTime end = today;

    switch (preset) {
      case "Today":
        start = today;
        break;
      case "7 Days":
        start = today.subtract(const Duration(days: 6));
        break;
      case "30 Days":
        start = today.subtract(const Duration(days: 29));
        break;
      case "This Month":
        start = DateTime(today.year, today.month, 1);
        break;
      default:
        start = today;
    }

    setState(() {
      _startDate = start;
      _endDate = end;
      _displayedMonth = DateTime(start.year, start.month, 1);
      _selectingEnd = false;
    });
  }

  void _onDayTapped(DateTime day) {
    setState(() {
      if (!_selectingEnd || _startDate == null) {
        _startDate = day;
        _endDate = day;
        _selectingEnd = true;
      } else {
        if (day.isBefore(_startDate!)) {
          _startDate = day;
          _endDate = day;
        } else {
          _endDate = day;
          _selectingEnd = false;
        }
      }
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDayInRange(DateTime day) {
    if (_startDate == null || _endDate == null) return false;
    return (day.isAfter(_startDate!) && day.isBefore(_endDate!)) ||
        _isSameDay(day, _startDate!) ||
        _isSameDay(day, _endDate!);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary; // 0xFFB57510
    final surfaceColor =
        isDark ? const Color(0xFF1C1A17) : const Color(0xFFFFFFFF);
    final borderColor =
        isDark ? const Color(0xFF2E2A24) : const Color(0xFFEFE9E0);
    final textPrimary =
        isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary =
        isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);

    final monthName = DateFormat('MMMM yyyy').format(_displayedMonth);
    final daysInMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final firstWeekday =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1).weekday % 7; // Sunday=0

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header: Title & Close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Date Range",
                style: GoogleFonts.raleway(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: textSecondary, size: 20),
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Preset Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final preset in ["Today", "7 Days", "30 Days", "This Month"])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => _selectPreset(preset),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF28241D)
                              : const Color(0xFFF7F3ED),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          preset,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Month Navigation Bar (Single Month View)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF24211B)
                  : const Color(0xFFFAF7F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: textPrimary,
                    size: 22,
                  ),
                  onPressed: _onPrevMonth,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Text(
                  monthName,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    color: textPrimary,
                    size: 22,
                  ),
                  onPressed: _onNextMonth,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Day of Week Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"].map(
              (day) => SizedBox(
                width: 38,
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ),
              ),
            ).toList(),
          ),
          const SizedBox(height: 6),

          // Month Day Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42, // 6 weeks * 7 days
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - firstWeekday + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final cellDate = DateTime(
                _displayedMonth.year,
                _displayedMonth.month,
                dayNumber,
              );

              final isStart =
                  _startDate != null && _isSameDay(cellDate, _startDate!);
              final isEnd =
                  _endDate != null && _isSameDay(cellDate, _endDate!);
              final inRange = _isDayInRange(cellDate);
              final isToday = _isSameDay(cellDate, DateTime.now());

              BoxDecoration decoration;
              TextStyle textStyle;

              if (isStart || isEnd) {
                decoration = BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.35),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                );
                textStyle = GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                );
              } else if (inRange) {
                decoration = BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(6),
                );
                textStyle = GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                );
              } else if (isToday) {
                decoration = BoxDecoration(
                  border: Border.all(color: primaryColor, width: 1.2),
                  borderRadius: BorderRadius.circular(8),
                );
                textStyle = GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                );
              } else {
                decoration = const BoxDecoration();
                textStyle = GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                );
              }

              return InkWell(
                onTap: () => _onDayTapped(cellDate),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: decoration,
                  alignment: Alignment.center,
                  child: Text("$dayNumber", style: textStyle),
                ),
              );
            },
          ),
          const SizedBox(height: 14),

          // Date Selection Feedback Summary
          if (_startDate != null && _endDate != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF24201A)
                    : const Color(0xFFFBF8F4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected Range:",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: textSecondary,
                    ),
                  ),
                  Text(
                    "${DateFormat('MMM d, yyyy').format(_startDate!)} – ${DateFormat('MMM d, yyyy').format(_endDate!)}",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Action Buttons: Cancel and Apply
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textPrimary,
                    side: BorderSide(color: borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  actionText: "Apply Filter",
                  borderRadius: 100,
                  onPressed: () {
                    if (_startDate != null && _endDate != null) {
                      widget.onApply(
                        DateTimeRange(start: _startDate!, end: _endDate!),
                      );
                    } else if (_startDate != null) {
                      widget.onApply(
                        DateTimeRange(start: _startDate!, end: _startDate!),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
