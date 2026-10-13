import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dashed-outline promo card used at the top of the bill-payment flows
/// (airtime/data, electricity). Artwork sits on the right and is allowed to
/// bleed past the card bounds, trimmed by the rounded clip.
class PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  /// Pinned so the artwork can't grow into the text column.
  final double imageWidth;
  final double height;

  const PromoBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.imageWidth = 84,
    this.height = 88,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(12),
        color: primary,
        dashPattern: const [6, 4],
        strokeWidth: 1.2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          // A minimum rather than a fixed height: keeps the intended look at
          // normal sizes but grows instead of overflowing when the copy wraps
          // on narrow screens or the user scales text up.
          constraints: BoxConstraints(minHeight: height),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 14,
                top: -6,
                bottom: -14,
                width: imageWidth,
                child: Image.asset(image, fit: BoxFit.contain),
              ),
              // Non-positioned, so this sizes the Stack.
              Padding(
                padding: EdgeInsets.fromLTRB(16, 12, imageWidth + 22, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        letterSpacing: 0,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
