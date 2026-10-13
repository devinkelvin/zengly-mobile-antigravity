import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String actionText;
  final Color? backgroundColor, textColor;
  final double? borderRadius;
  final double? height;
  final BorderSide? borderSide;
  final double? fontSize;
  final double? horizontalPadding;
  final IconData? icon;
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
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0.5,
          backgroundColor:
              backgroundColor ?? Theme.of(context).colorScheme.primary,
          foregroundColor: textColor ?? Theme.of(context).colorScheme.onSurface,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 48,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
            side: borderSide ?? BorderSide(color: Colors.transparent, width: 0),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: (fontSize ?? 14) + 4,
                color: textColor ?? Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(width: 8),
            ],
            Text(
              actionText,
              maxLines: 1,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: fontSize ?? 14,
                color: textColor ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
