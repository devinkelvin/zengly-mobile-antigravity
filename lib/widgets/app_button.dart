import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppButtonVariant { primary, secondary, outline, destructive, textButton }

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
  final AppButtonVariant variant;

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
    this.variant = AppButtonVariant.primary,
  });

  const AppButton.primary({
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
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
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
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
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
  }) : variant = AppButtonVariant.outline;

  const AppButton.destructive({
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
  }) : variant = AppButtonVariant.destructive;

  const AppButton.compact({
    super.key,
    required this.onPressed,
    required this.actionText,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
    this.borderSide,
    this.height = 38,
    this.fontSize = 12,
    this.horizontalPadding = 14,
    this.icon,
    this.isLoading = false,
    this.variant = AppButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color effectiveBg;
    Color effectiveTextColor;
    BorderSide effectiveBorder = borderSide ?? BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        effectiveBg = backgroundColor ?? const Color(0xFFB57510);
        effectiveTextColor = textColor ?? Colors.white;
        break;
      case AppButtonVariant.secondary:
        effectiveBg = backgroundColor ??
            (isDark
                ? const Color(0xFF26211B)
                : Theme.of(context).colorScheme.outlineVariant);
        effectiveTextColor = textColor ??
            (isDark ? Colors.white : const Color(0xFF1A1A1A));
        break;
      case AppButtonVariant.outline:
        effectiveBg = backgroundColor ?? Colors.transparent;
        effectiveTextColor = textColor ??
            (isDark ? Colors.white : const Color(0xFF1A1A1A));
        effectiveBorder = borderSide ??
            BorderSide(
              color: isDark ? Colors.white24 : const Color(0xFFD2C7B4),
              width: 1.2,
            );
        break;
      case AppButtonVariant.destructive:
        effectiveBg = backgroundColor ?? const Color(0xFFEF4444);
        effectiveTextColor = textColor ?? Colors.white;
        break;
      case AppButtonVariant.textButton:
        effectiveBg = Colors.transparent;
        effectiveTextColor = textColor ?? const Color(0xFFB57510);
        break;
    }

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
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 16),
            side: effectiveBorder,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: effectiveTextColor,
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
