import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/utils.dart';

class TransactionLimitsScreen extends StatelessWidget {
  const TransactionLimitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF14120E);
    const cardColor = Color(0xFF1F1D19);
    const primaryAmber = Color(0xFFC58314);
    const dividerColor = Color(0xFF2C2822);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF25231F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          "Transaction Limits",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tier Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primaryAmber.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: primaryAmber.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: primaryAmber,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Tier 1 Account",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00B050).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  "Active",
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF00B050),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Verified with Phone Number & BVN",
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Limits Breakdown Card
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _buildLimitItem(
                      label: "Daily Transfer Limit",
                      amount: "₦50,000.00",
                      usedText: "₦0.00 used today (₦50,000.00 remaining)",
                      progress: 0.0,
                    ),
                    const Divider(
                      height: 28,
                      thickness: 1,
                      color: dividerColor,
                    ),
                    _buildLimitItem(
                      label: "Single Transfer Limit",
                      amount: "₦20,000.00",
                      usedText: "Maximum per single transaction",
                    ),
                    const Divider(
                      height: 28,
                      thickness: 1,
                      color: dividerColor,
                    ),
                    _buildLimitItem(
                      label: "Maximum Wallet Balance",
                      amount: "₦300,000.00",
                      usedText: "Upgrade to Tier 3 for unlimited balance",
                    ),
                    const Divider(
                      height: 28,
                      thickness: 1,
                      color: dividerColor,
                    ),
                    _buildLimitItem(
                      label: "Daily Bills & Airtime Limit",
                      amount: "₦100,000.00",
                      usedText: "Power, cable TV and recharge",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Upgrade Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed(AppRouter.preVerification);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAmber,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Upgrade to Tier 2 (Higher Limits)",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLimitItem({
    required String label,
    required String amount,
    required String usedText,
    double? progress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            Text(
              amount,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          usedText,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
        if (progress != null) ...[
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF2C2822),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFC58314)),
              minHeight: 6,
            ),
          ),
        ],
      ],
    );
  }
}
