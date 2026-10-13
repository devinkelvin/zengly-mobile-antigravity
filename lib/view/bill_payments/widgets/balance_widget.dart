import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Text(
            "Balance",
            style: GoogleFonts.inter(
              letterSpacing: 0,
              fontSize: 12,
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
          ),
          SizedBox(width: 5),
          Text(
            "₦345,778.90",
            style: GoogleFonts.inter(
              letterSpacing: 0,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
