import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceWidget extends StatefulWidget {
  final double? balance;
  final bool compact;
  final EdgeInsetsGeometry? margin;

  const BalanceWidget({
    super.key,
    this.balance = 2000000.0,
    this.compact = false,
    this.margin,
  });

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  static bool _globalVisibility = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFFB57510);

    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF262017)
            : const Color(0xFFF3EFE6),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _globalVisibility = !_globalVisibility);
        },
        borderRadius: BorderRadius.circular(100),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                size: 13,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _globalVisibility ? "₦2,000,000.00" : "₦••••••",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1E1A14),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _globalVisibility
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 13,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
