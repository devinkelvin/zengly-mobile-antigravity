import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/widgets.dart';
import '../screens/deep_ai_insight_report_screen.dart';

class FullAnalyticsSheet extends StatelessWidget {
  final VoidCallback onNotify;

  const FullAnalyticsSheet({super.key, required this.onNotify});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGold = const Color(0xFFB57510);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? Colors.white60 : const Color(0xFF6B5E4A);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag handle
        Center(
          child: Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : const Color(0xFFD2C7B4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Header with AI Sparkle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: primaryGold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deep AI Spending Insights",
                      style: GoogleFonts.raleway(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      "Personalized pattern analysis",
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF28231C) : const Color(0xFFEBE3D3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close_rounded, size: 16, color: textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Core Insight Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF252019) : const Color(0xFFFFF9EE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryGold.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "+18% THIS MONTH",
                      style: GoogleFonts.inter(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                  Text(
                    "Food & Dining",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryGold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "₦142,500.00",
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Up from ₦120,800 last month across 26 transactions. Average order size: ₦5,480.",
                style: GoogleFonts.inter(fontSize: 12, color: textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Actionable Recommendation Callout
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.25)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.savings_rounded, color: Color(0xFF10B981), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Potential Monthly Savings: ~₦14,250",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Trimming 2 delivery orders per week safely redirects ~10% toward your emergency fund without altering your lifestyle.",
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: isDark ? Colors.white70 : const Color(0xFF1E3A2F),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Action Buttons: Approved AppButton (No pink!)
        SizedBox(
          width: double.infinity,
          child: AppButton(
            actionText: "View Full Deep AI Report",
            icon: Icons.auto_graph_rounded,
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const DeepAiInsightReportScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: AppButton.outline(
            actionText: "Dismiss",
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
