import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import 'top_sprayers_section.dart';

class VanitiLeaderboardSheet extends StatefulWidget {
  const VanitiLeaderboardSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VanitiLeaderboardSheet(),
    );
  }

  @override
  State<VanitiLeaderboardSheet> createState() => _VanitiLeaderboardSheetState();
}

class _VanitiLeaderboardSheetState extends State<VanitiLeaderboardSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Sprayer> _extendedSprayers = [
    Sprayer(
      name: "Queenie Adenuga",
      amount: "₦2.5M",
      avatar: AppImages.queenie,
      badge: "👑",
      ringColor: Color(0xFFE85B81),
    ),
    Sprayer(
      name: "Odogwu Malay",
      amount: "₦1.8M",
      avatar: AppImages.kunle,
      badge: "🔥",
      ringColor: Color(0xFFE9974A),
    ),
    Sprayer(
      name: "Bella Maradona",
      amount: "₦1.2M",
      avatar: AppImages.bella,
      badge: "💎",
      ringColor: Color(0xFF4A90E2),
    ),
    Sprayer(
      name: "Chief Tunde Alabi",
      amount: "₦850K",
      avatar: AppImages.profilePicture,
      badge: "⚡",
      ringColor: Color(0xFFB57510),
    ),
    Sprayer(
      name: "Fola Silver",
      amount: "₦620K",
      avatar: AppImages.queenie,
      badge: "⭐",
      ringColor: Color(0xFF9E9E9E),
    ),
    Sprayer(
      name: "Dapo Spark",
      amount: "₦450K",
      avatar: AppImages.kunle,
      badge: "✨",
      ringColor: Color(0xFFCD7F32),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1A17) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 14, left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2E2A24) : const Color(0xFFE2D6C5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Vaniti Sprayers Leaderboard",
                style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 20, color: textSecondary),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Period Tabs
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF252018) : const Color(0xFFF3ECE0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: textSecondary,
              labelStyle: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700),
              tabs: const [
                Tab(text: "Today"),
                Tab(text: "This Week"),
                Tab(text: "All-Time Legends"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sprayers List
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: _extendedSprayers.length,
              separatorBuilder: (context, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final sprayer = _extendedSprayers[index];
                final rank = index + 1;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF242018) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: rank <= 3 ? primaryColor.withValues(alpha: 0.4) : borderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        alignment: Alignment.center,
                        child: Text(
                          "#$rank",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: rank == 1
                                ? const Color(0xFFFFB300)
                                : (rank == 2 ? const Color(0xFFB0BEC5) : (rank == 3 ? const Color(0xFFCD7F32) : textSecondary)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: sprayer.ringColor, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.asset(sprayer.avatar, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(sprayer.badge, style: const TextStyle(fontSize: 15)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sprayer.name,
                          style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: textPrimary),
                        ),
                      ),
                      Text(
                        sprayer.amount,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: primaryColor),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
