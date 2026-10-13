import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ElectricityTile extends StatelessWidget {
  final String title, content;
  const ElectricityTile({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,

              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Container(
            alignment: Alignment.centerRight,
            width: 150,
            child: Text(
              content,
              textAlign: TextAlign.right,
              maxLines: 2,
              style: GoogleFonts.inter(
                fontSize: 12,

                letterSpacing: 0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
