import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SquareActionButton extends StatelessWidget {
  final String actionText, icon;
  final VoidCallback onTap;
  final Color color;
  const SquareActionButton({
    super.key,
    required this.actionText,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: color.withValues(alpha: 0.1),
            ),
            child: SvgPicture.asset(icon),
          ),
          SizedBox(height: 8),
          Text(
            actionText,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
