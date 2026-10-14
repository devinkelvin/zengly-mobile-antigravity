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

  final List<Sprayer> _allSprayers = [
    Sprayer(
      name: "Queenie Adenuga",
      amount: "₦2.5M",
      avatar: AppImages.queenie,
      badge: "👑",
      ringColor: const Color(0xFFFFB300),
    ),
    Sprayer(
      name: "Odogwu Malay",
      amount: "₦1.8M",
      avatar: AppImages.kunle,
      badge: "🥈",
      ringColor: const Color(0xFFC0C0C0),
    ),
    Sprayer(
      name: "Bella Maradona",
      amount: "₦1.2M",
      avatar: AppImages.bella,
      badge: "🥉",
      ringColor: const Color(0xFFCD7F32),
    ),
    Sprayer(
      name: "Chief Tunde Alabi",
      amount: "₦850K",
      avatar: AppImages.profilePicture,
      badge: "⚡",
      ringColor: const Color(0xFFB57510),
    ),
    Sprayer(
      name: "Fola Silver",
      amount: "₦620K",
      avatar: AppImages.queenie,
      badge: "⭐",
      ringColor: const Color(0xFF9E9E9E),
    ),
    Sprayer(
      name: "Dapo Spark",
      amount: "₦450K",
      avatar: AppImages.kunle,
      badge: "✨",
      ringColor: const Color(0xFFCD7F32),
    ),
    Sprayer(
      name: "Seyi VIP",
      amount: "₦380K",
      avatar: AppImages.bella,
      badge: "🔥",
      ringColor: const Color(0xFFE9974A),
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
    final primaryColor = const Color(0xFFB57510);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE);

    final first = _allSprayers[0];
    final second = _allSprayers[1];
    final third = _allSprayers[2];
    final runnersUp = _allSprayers.sublist(3);

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1612) : const Color(0xFFFAF7F2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vaniti Live Leaderboard",
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Owanbe Lagos • 1,204 Active Sprayers",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, size: 22, color: textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Period Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF262017) : const Color(0xFFEDE6DA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE5A93C), Color(0xFFB57510)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: textSecondary,
                labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: "Today"),
                  Tab(text: "This Week"),
                  Tab(text: "All-Time Legends"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Celebratory Top 3 Podium
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF282014), const Color(0xFF1E1810)]
                      : [const Color(0xFFFFF7EA), const Color(0xFFF6EEE1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 2nd Place
                  _buildPodiumColumn(
                    sprayer: second,
                    rank: 2,
                    pedestalHeight: 65,
                    ringColor: const Color(0xFFB0BEC5),
                    badge: "🥈",
                    isDark: isDark,
                  ),
                  // 1st Place (Winner)
                  _buildPodiumColumn(
                    sprayer: first,
                    rank: 1,
                    pedestalHeight: 90,
                    ringColor: const Color(0xFFFFB300),
                    badge: "👑",
                    isDark: isDark,
                  ),
                  // 3rd Place
                  _buildPodiumColumn(
                    sprayer: third,
                    rank: 3,
                    pedestalHeight: 50,
                    ringColor: const Color(0xFFCD7F32),
                    badge: "🥉",
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Runners-up List (Rank 4+)
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: runnersUp.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final sprayer = runnersUp[index];
                final rank = index + 4;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF221D16) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        alignment: Alignment.center,
                        child: Text(
                          "#$rank",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 38,
                        width: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: sprayer.ringColor, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.asset(sprayer.avatar, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(sprayer.badge, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sprayer.name,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        sprayer.amount,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Pinned User Rank Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2B2317) : const Color(0xFFF3ECE0),
              border: Border(
                top: BorderSide(
                  color: primaryColor.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(AppImages.profilePicture, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Position: #14",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          "@ability007 • ₦150,000 Sprayed",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Spray More",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn({
    required Sprayer sprayer,
    required int rank,
    required double pedestalHeight,
    required Color ringColor,
    required String badge,
    required bool isDark,
  }) {
    final avatarSize = rank == 1 ? 56.0 : 46.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: avatarSize,
              width: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: rank == 1 ? 3 : 2),
                boxShadow: rank == 1
                    ? [
                        BoxShadow(
                          color: ringColor.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: ClipOval(
                child: Image.asset(sprayer.avatar, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: -14,
              child: Text(badge, style: TextStyle(fontSize: rank == 1 ? 18 : 14)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          sprayer.name.split(" ").first,
          style: GoogleFonts.inter(
            fontSize: rank == 1 ? 13 : 11.5,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        Text(
          sprayer.amount,
          style: GoogleFonts.inter(
            fontSize: rank == 1 ? 13 : 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFB57510),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 72,
          height: pedestalHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: rank == 1
                  ? [const Color(0xFFD49B28), const Color(0xFFB57510)]
                  : (rank == 2
                      ? [const Color(0xFFB0BEC5), const Color(0xFF78909C)]
                      : [const Color(0xFFBCAAA4), const Color(0xFF8D6E63)]),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          alignment: Alignment.center,
          child: Text(
            "#$rank",
            style: GoogleFonts.raleway(
              fontSize: rank == 1 ? 22 : 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
