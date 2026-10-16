import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_overlays.dart';

class DeepAiInsightReportScreen extends StatefulWidget {
  final String category;
  final double currentSpend;
  final double previousSpend;
  final double percentageIncrease;
  final double potentialMonthlySavings;

  const DeepAiInsightReportScreen({
    super.key,
    this.category = "Food & Dining",
    this.currentSpend = 142500,
    this.previousSpend = 120800,
    this.percentageIncrease = 18.0,
    this.potentialMonthlySavings = 14250,
  });

  @override
  State<DeepAiInsightReportScreen> createState() =>
      _DeepAiInsightReportScreenState();
}

class _DeepAiInsightReportScreenState extends State<DeepAiInsightReportScreen> {
  int _selectedSavingsPercentage = 10;
  String _selectedTimeline = "30 Days";
  bool _budgetCreated = false;
  double _budgetLimit = 128000;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGold = const Color(0xFFB57510);
    final bgColor = isDark ? const Color(0xFF12100D) : const Color(0xFFFAF7F2);
    final cardBg = isDark ? const Color(0xFF1E1A14) : Colors.white;
    final borderColor = isDark ? Colors.white10 : const Color(0xFFE2D6C5);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? Colors.white60 : const Color(0xFF6B5E4A);

    final currencyFmt = NumberFormat("#,##0", "en_US");
    final calculatedSavings =
        (widget.currentSpend * (_selectedSavingsPercentage / 100.0));

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF26211B) : const Color(0xFFEDE4D4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: textPrimary,
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primaryGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.auto_awesome_rounded, color: primaryGold, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              "Deep AI Spending Report",
              style: GoogleFonts.raleway(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ANALYSIS TIMELINE",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: textSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: ["7 Days", "30 Days", "90 Days"].map((t) {
                      final isSel = _selectedTimeline == t;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTimeline = t),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isSel
                                ? primaryGold
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            t,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              color: isSel ? Colors.white : textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Top Hero Insight Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF2E2415), const Color(0xFF1B1710)]
                      : [const Color(0xFFFFF7EA), const Color(0xFFF9EED9)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryGold.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.trending_up_rounded,
                              color: Color(0xFFEF4444),
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "+${widget.percentageIncrease.toStringAsFixed(0)}% vs Last Month",
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.category,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "₦${currencyFmt.format(widget.currentSpend)}",
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Previous 30 days: ₦${currencyFmt.format(widget.previousSpend)} across 26 transactions",
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.25)
                          : Colors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: primaryGold,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Food & Dining represents 34% of your total expenditure this month. Your highest spending spikes occurred on Friday and Saturday evenings between 7 PM and 10 PM.",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              height: 1.45,
                              color: textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Week-by-Week Distribution Breakdown
            Text(
              "WEEKLY BREAKDOWN",
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _weeklyRow(
                    "Week 1 (Oct 1 - Oct 7)",
                    "₦28,400",
                    0.20,
                    primaryGold,
                    textPrimary,
                    textSecondary,
                  ),
                  const SizedBox(height: 12),
                  _weeklyRow(
                    "Week 2 (Oct 8 - Oct 14)",
                    "₦31,100",
                    0.22,
                    primaryGold,
                    textPrimary,
                    textSecondary,
                  ),
                  const SizedBox(height: 12),
                  _weeklyRow(
                    "Week 3 (Oct 15 - Oct 21)",
                    "₦45,800",
                    0.32,
                    const Color(0xFFEF4444),
                    textPrimary,
                    textSecondary,
                    tag: "Payday Spike",
                  ),
                  const SizedBox(height: 12),
                  _weeklyRow(
                    "Week 4 (Oct 22 - Present)",
                    "₦37,200",
                    0.26,
                    primaryGold,
                    textPrimary,
                    textSecondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Top Merchants
            Text(
              "TOP MERCHANTS IN THIS CATEGORY",
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _merchantTile(
                    "Chowdeck / Food Delivery",
                    "11 transactions",
                    "₦52,800",
                    Icons.delivery_dining_rounded,
                    const Color(0xFFE5A93C),
                    textPrimary,
                    textSecondary,
                    isFirst: true,
                  ),
                  Divider(height: 1, color: borderColor),
                  _merchantTile(
                    "Mega Chicken & Grills",
                    "6 visits",
                    "₦38,400",
                    Icons.restaurant_rounded,
                    const Color(0xFFEF4444),
                    textPrimary,
                    textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _merchantTile(
                    "Prince Ebeano Supermarket",
                    "5 grocery runs",
                    "₦31,300",
                    Icons.shopping_cart_rounded,
                    const Color(0xFF10B981),
                    textPrimary,
                    textSecondary,
                  ),
                  Divider(height: 1, color: borderColor),
                  _merchantTile(
                    "The Palms Cafe",
                    "4 coffee & brunch stops",
                    "₦20,000",
                    Icons.coffee_rounded,
                    const Color(0xFF3B82F6),
                    textPrimary,
                    textSecondary,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // AI Savings Calculator & Action Section
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: primaryGold.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.savings_rounded,
                          color: Color(0xFF10B981),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "AI Savings Opportunity",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Adjust target reduction to calculate potential monthly savings:",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Percentage pills
                  Row(
                    children: [5, 10, 15, 20].map((pct) {
                      final isSel = _selectedSavingsPercentage == pct;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedSavingsPercentage = pct),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? primaryGold
                                  : (isDark
                                      ? const Color(0xFF28231B)
                                      : const Color(0xFFF3ECE0)),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSel ? primaryGold : Colors.transparent,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "$pct%",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isSel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSel ? Colors.white : textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Estimated Monthly Savings",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "₦${currencyFmt.format(calculatedSavings)} / mo",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Safe Target",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  if (_budgetCreated)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: primaryGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primaryGold),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: primaryGold, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Budget active: ₦${currencyFmt.format(_budgetLimit)} cap for ${widget.category}",
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        actionText: "Set ₦${currencyFmt.format(widget.currentSpend - calculatedSavings)} Monthly Budget",
                        icon: Icons.track_changes_rounded,
                        onPressed: () => _openSetBudgetModal(context),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  void _openSetBudgetModal(BuildContext context) {
    final currencyFmt = NumberFormat("#,##0", "en_US");
    final targetCap =
        widget.currentSpend * (1.0 - (_selectedSavingsPercentage / 100.0));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final cardBg = isDark ? const Color(0xFF1E1A14) : Colors.white;
        final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
        final textSecondary = isDark ? Colors.white60 : const Color(0xFF6B5E4A);
        final primaryGold = const Color(0xFFB57510);

        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 14,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : const Color(0xFFD2C7B4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Confirm Budget Cap",
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Zengly AI will notify you when spending in ${widget.category} reaches 80% and 100% of this cap.",
                style: GoogleFonts.inter(fontSize: 12.5, color: textSecondary),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF28231B) : const Color(0xFFF7F2E7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Target Monthly Cap",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                    Text(
                      "₦${currencyFmt.format(targetCap)}",
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: primaryGold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  actionText: "Activate Budget Alert",
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _budgetCreated = true;
                      _budgetLimit = targetCap;
                    });
                    AppOverlays.showToast(
                      context: context,
                      title: "Budget Activated",
                      message:
                          "Monthly cap set to ₦${currencyFmt.format(targetCap)} for ${widget.category}.",
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _weeklyRow(
    String label,
    String amount,
    double progress,
    Color color,
    Color textPrimary,
    Color textSecondary, {
    String? tag,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                if (tag != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.inter(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Text(
              amount,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _merchantTile(
    String name,
    String subtitle,
    String total,
    IconData icon,
    Color iconColor,
    Color textPrimary,
    Color textSecondary, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                ),
              ],
            ),
          ),
          Text(
            total,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
