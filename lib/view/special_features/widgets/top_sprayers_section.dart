import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';

class Sprayer {
  final String name;
  final String amount;
  final String avatar;
  final String badge;
  final Color ringColor;

  const Sprayer({
    required this.name,
    required this.amount,
    required this.avatar,
    required this.badge,
    required this.ringColor,
  });
}

List<Sprayer> topSprayers = [
  Sprayer(
    name: "Queenie Adenuga",
    amount: "₦2.5M",
    avatar: AppImages.queenie,
    badge: "👑",
    ringColor: const Color(0xFFE85B81),
  ),
  Sprayer(
    name: "Odogwu Malay",
    amount: "₦500K",
    avatar: AppImages.kunle,
    badge: "🔥",
    ringColor: const Color(0xFFE9974A),
  ),
  Sprayer(
    name: "Bella Maradona",
    amount: "₦400K",
    avatar: AppImages.bella,
    badge: "💎",
    ringColor: const Color(0xFF4A90E2),
  ),
];

class TopSprayersSection extends StatelessWidget {
  final bool showHeader;
  final VoidCallback? onSeeMore;

  const TopSprayersSection({super.key, this.showHeader = true, this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Sprayers",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: onSeeMore,
                  child: Text(
                    "See More",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ...topSprayers.map(
          (sprayer) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF26211B)
                  : Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: sprayer.ringColor, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.asset(sprayer.avatar, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 10),
                Text(sprayer.badge, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    sprayer.name,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  sprayer.amount,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
