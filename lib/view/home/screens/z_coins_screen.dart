import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class ZCoinsScreen extends ConsumerWidget {
  const ZCoinsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Z-Coins & Rewards",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: AppDimensions.viewPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Z-Coins Hero Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2C2216),
                      Color(0xFF1B150E),
                      Color(0xFF0F0D0A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFB57510).withValues(alpha: 0.45),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB57510).withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Spinning / 3D Coin Asset
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFB57510).withValues(alpha: 0.15),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(AppImages.coinGif),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "TOTAL REWARDS BALANCE",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "450 Z-Coins",
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFD54F),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB57510).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFB57510).withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        "Tier 1 Member • 1.2x Earn Multiplier",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFFE082),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Ways to Earn Section
              Text(
                "HOW TO EARN Z-COINS",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: primary,
                ),
              ),
              const SizedBox(height: 12),

              _buildEarnTile(
                context: context,
                icon: Icons.send_rounded,
                title: "Make Zero-Fee Transfers",
                reward: "+10 Z-Coins",
                desc: "Earn for every completed transfer to other Zengly users or banks",
              ),
              _buildEarnTile(
                context: context,
                icon: Icons.celebration_rounded,
                title: "Shower Friends on Vaniti",
                reward: "+25 Z-Coins",
                desc: "Spray digital cash at verified celebration events",
              ),
              _buildEarnTile(
                context: context,
                icon: Icons.receipt_long_rounded,
                title: "Pay Utility & Energy Bills",
                reward: "+15 Z-Coins",
                desc: "Renew electricity and TV subscriptions through Zengly bills",
              ),
              _buildEarnTile(
                context: context,
                icon: Icons.group_add_rounded,
                title: "Invite Friends & Family",
                reward: "+100 Z-Coins",
                desc: "When a referred friend signs up and completes Tier 1 verification",
              ),

              const SizedBox(height: 24),

              // Rewards & Redemption Catalog
              Text(
                "AVAILABLE REWARDS & PERKS",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: primary,
                ),
              ),
              const SizedBox(height: 12),

              _buildPerkCard(
                context: context,
                title: "Zero FX Fee Voucher",
                cost: "200 Z-Coins",
                desc: "Waive all conversion fees on your next Virtual Dollar Card funding.",
                onRedeem: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Voucher unlocked! Applied to next Dollar Card funding."),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              _buildPerkCard(
                context: context,
                title: "10% Airtime Bonus Boost",
                cost: "150 Z-Coins",
                desc: "Get 10% extra airtime value on MTN, Airtel, or Glo purchases.",
                onRedeem: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Airtime Bonus activated for your next top-up."),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              _buildPerkCard(
                context: context,
                title: "Exclusive Vaniti Crown Badge",
                cost: "300 Z-Coins",
                desc: "Unlock the Golden Crown icon on all public celebration spray leaderboards.",
                onRedeem: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Crown badge equipped on your profile!"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarnTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String reward,
    required String desc,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1916) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFB57510).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFB57510), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      reward,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00C27C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerkCard({
    required BuildContext context,
    required String title,
    required String cost,
    required String desc,
    required VoidCallback onRedeem,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1A14) : const Color(0xFFF9F7F3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFB57510).withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFB57510),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  cost,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: OutlinedButton(
              onPressed: onRedeem,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFB57510), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Redeem Perk",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB57510),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
