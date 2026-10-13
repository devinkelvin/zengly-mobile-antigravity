import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import 'top_sprayers_section.dart';

class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({super.key});

  @override
  Widget build(BuildContext context) {
    final first = topSprayers[0];
    final second = topSprayers[1];
    final third = topSprayers[2];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C1100), Color(0xFF4F3307)],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE64444),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 6,
                      width: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "LIVE EVENT",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "1,204",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                Positioned.fill(
                  top: 40,
                  child: Image.asset(
                    AppImages.leaderboardPodium,
                    fit: BoxFit.contain,
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.62, -0.95),
                  child: _PodiumAvatar(
                    sprayer: second,
                    delay: const Duration(milliseconds: 350),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.0, -1.4),
                  child: _PodiumAvatar(
                    sprayer: first,
                    delay: const Duration(milliseconds: 700),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.62, -0.95),
                  child: _PodiumAvatar(sprayer: third, delay: Duration.zero),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumAvatar extends StatelessWidget {
  final Sprayer sprayer;
  final Duration delay;

  const _PodiumAvatar({required this.sprayer, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sprayer.name.split(" ").first,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: sprayer.ringColor, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(sprayer.avatar, fit: BoxFit.cover),
              ),
            ),
          ],
        )
        .animate(delay: delay)
        .fadeIn(duration: 250.ms)
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: 500.ms,
          curve: Curves.elasticOut,
        );
  }
}
