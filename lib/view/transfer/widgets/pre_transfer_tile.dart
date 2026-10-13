import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PreTransferTile extends StatelessWidget {
  final String image, title, subTitle;
  final bool isComingSoon;
  final VoidCallback onTap;

  const PreTransferTile({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1A14) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF2A2218)
                    : const Color(0xFFFAF5ED),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF382F22)
                      : const Color(0xFFEBE3D7),
                ),
              ),
              child: SvgPicture.asset(
                image,
                colorFilter: ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      if (isComingSoon) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            "SOON",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 8.5,
                              letterSpacing: 0.4,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ],
        ),
      ),
    );
  }
}
