import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/app_images.dart';
import '../../../utils/utils.dart';

class CoinWidget extends StatelessWidget {
  const CoinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.pushNamed(AppRouter.zCoins);
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF262016) : const Color(0xFFFFF7EC),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: const Color(0xFFB57510).withValues(alpha: 0.45),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB57510).withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Image.asset(AppImages.coinGif),
            ),
            const SizedBox(width: 6),
            Text(
              "450 Z-Coins",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFFFFD54F) : const Color(0xFFB57510),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: isDark ? const Color(0xFFFFD54F) : const Color(0xFFB57510),
            ),
          ],
        ),
      ),
    );
  }
}
