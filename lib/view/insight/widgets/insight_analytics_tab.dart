import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/app_overlays.dart';
import '../models/insight_models.dart';
import 'insight_period_selector.dart';

class InsightAnalyticsTab extends StatelessWidget {
  final List<AnalyticsPoint> points;
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const InsightAnalyticsTab({
    super.key,
    required this.points,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  static const _incomeColor = Color(0xFF34C759);
  static const _expenseColor = Color(0xFFE05A3C);

  @override
  Widget build(BuildContext context) {
    final latest = points.last;
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            "Income vs Expenses",
            style: GoogleFonts.inter(
              fontSize: 12,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₦${latest.income.toStringAsFixed(0)}",
                style: GoogleFonts.raleway(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  "12% vs last",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _incomeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.arrow_drop_up, color: _incomeColor, size: 18),
              Text(
                "Income",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.arrow_drop_down, color: _expenseColor, size: 18),
              Text(
                "Expenses",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(height: 220, child: _buildChart(context)),
          const SizedBox(height: 16),
          InsightPeriodSelector(
            periods: const ["1M", "3M", "6M", "1Y", "ALL"],
            selected: selectedPeriod,
            onChanged: onPeriodChanged,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Showing Jan 28, 2026 - Feb 28, 2026",
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fee Trend (6 Months)",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₦8,550",
                      style: GoogleFonts.raleway(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => AppOverlays.fullAnalyticsSheet(context: context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Full Analytics",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.north_east,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final incomeSpots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].income),
    ];
    final expenseSpots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].expense),
    ];

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Theme.of(context).colorScheme.surface,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final point = points[spot.x.toInt()];
                final isIncome = spot.barIndex == 0;
                final header = spot.barIndex == 0 ? "${point.label}\n" : "";
                return LineTooltipItem(
                  "$header${isIncome ? "● Income" : "● Expenses"}: ₦${spot.y.toStringAsFixed(0)}",
                  GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isIncome ? _incomeColor : _expenseColor,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: incomeSpots,
            isCurved: true,
            color: _incomeColor,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: expenseSpots,
            isCurved: true,
            color: _expenseColor,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _expenseColor.withValues(alpha: 0.35),
                  _expenseColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
