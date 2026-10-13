import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../models/insight_models.dart';
import 'insight_period_selector.dart';

class InsightSpendingTab extends StatelessWidget {
  final List<SpendingCategory> categories;
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;
  final int? selectedIndex;
  final ValueChanged<int> onCategoryTap;
  final DateTimeRange dateRange;
  final ValueChanged<DateTimeRange> onDateRangeChanged;

  const InsightSpendingTab({
    super.key,
    required this.categories,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.selectedIndex,
    required this.onCategoryTap,
    required this.dateRange,
    required this.onDateRangeChanged,
  });

  Future<void> _showCustomDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 2, 12, 31),
      initialDateRange: dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFFB57510),
              onPrimary: Colors.white,
              surface: const Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF181818),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateRangeChanged(picked);
    }
  }

  String _formatDateRange() {
    final startFormat = DateFormat("MMM d, yyyy");
    final endFormat = DateFormat("MMM d, yyyy");
    if (dateRange.start.year == dateRange.end.year &&
        dateRange.start.month == dateRange.end.month &&
        dateRange.start.day == dateRange.end.day) {
      return startFormat.format(dateRange.start);
    }
    return "${startFormat.format(dateRange.start)} – ${endFormat.format(dateRange.end)}";
  }

  @override
  Widget build(BuildContext context) {
    final total = categories.fold<double>(0, (sum, c) => sum + c.amount);
    final maxAmount = categories.fold<double>(
      0,
      (max, c) => c.amount > max ? c.amount : max,
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // 1. Period Selector Bar
          InsightPeriodSelector(
            periods: const ["1D", "1W", "1M", "6M", "1Y", "CUSTOM"],
            selected: selectedPeriod,
            onChanged: onPeriodChanged,
            onCustomTap: () => _showCustomDatePicker(context),
          ),
          const SizedBox(height: 12),

          // 2. Clickable Date Filter Badge
          Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showCustomDatePicker(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          selectedPeriod == "CUSTOM"
                              ? const Color(0xFFB57510).withValues(alpha: 0.6)
                              : Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDateRange(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 14,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Outflows Hero Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFB57510),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "TOTAL OUTFLOWS",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                            color: Theme.of(context).colorScheme.scrim,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap:
                          () => AppOverlays.fullAnalyticsSheet(
                            context: context,
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFB57510,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFFB57510,
                            ).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Full Analytics",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.north_east_rounded,
                              size: 11,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  CurrencyFormatter.format(total),
                  style: GoogleFonts.raleway(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${categories.length} categories active",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF10B981,
                        ).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "-3.8% vs last period",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Section Header: Category Breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Category Breakdown",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                "Sorted by spend",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 5. Perfectly Aligned Full-Width Category Cards
          ...categories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final isSelected = selectedIndex == index;
            final percentage =
                total > 0 ? (category.amount / total) * 100 : 0.0;
            final progressFactor =
                maxAmount > 0
                    ? (category.amount / maxAmount).clamp(0.04, 1.0)
                    : 0.04;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onCategoryTap(index),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? const Color(0xFF1B1B1B)
                              : const Color(0xFF131313),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xFFB57510)
                                : Colors.white.withValues(alpha: 0.05),
                        width: isSelected ? 1.2 : 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row: Left icon + label, Right amount + percentage
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: category.color.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                category.icon ?? Icons.payments_outlined,
                                size: 16,
                                color: category.color,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${category.transactionCount ?? 0} transactions",
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.scrim,
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
                                  CurrencyFormatter.format(category.amount),
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${percentage.toStringAsFixed(1)}% of spend",
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: category.color,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Bottom row: Sleek full-width progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Stack(
                            children: [
                              Container(
                                height: 4,
                                width: double.infinity,
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progressFactor,
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: category.color,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 8),
          // 6. Action Button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed:
                  () => AppOverlays.fullAnalyticsSheet(context: context),
              actionText: "Export Spending Statement",
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
