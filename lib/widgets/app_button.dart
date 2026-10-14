import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String actionText;
  final Color? backgroundColor, textColor;
  final double? borderRadius;
  final double? height;
  final BorderSide? borderSide;
  final double? fontSize;
  final double? horizontalPadding;
  final IconData? icon;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.actionText,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.borderSide,
    this.height,
    this.fontSize,
    this.horizontalPadding,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? const Color(0xFFB57510);
    // When using gold/primary, default text is always crisp white for contrast
    final effectiveTextColor = textColor ??
        (effectiveBg == const Color(0xFFB57510)
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface);

    return SizedBox(
      height: height ?? 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: effectiveBg,
          foregroundColor: effectiveTextColor,
          disabledBackgroundColor: effectiveBg.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white70,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: (fontSize ?? 15) + 3,
                      color: effectiveTextColor,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    actionText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: fontSize ?? 15,
                      color: effectiveTextColor,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
