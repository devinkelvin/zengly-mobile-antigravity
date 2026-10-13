import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LineDetail extends StatelessWidget {
  final String title, detail;
  final bool isSuperBold;

  final bool isRaleway;
  const LineDetail({
    super.key,
    required this.title,
    required this.detail,
    this.isSuperBold = false,

    this.isRaleway = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                isRaleway
                    ? GoogleFonts.raleway(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                      color: Theme.of(context).colorScheme.scrim,
                    )
                    : GoogleFonts.inter(
                      fontSize: 12,
                      letterSpacing: 0,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
          ),
          Text(
            detail,
            style:
                isRaleway
                    ? GoogleFonts.raleway(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    )
                    : isSuperBold
                    ? GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0,
                    )
                    : GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
          ),
        ],
      ),
    );
  }
}

class SecondLineDetail extends StatelessWidget {
  final String title, detail;

  const SecondLineDetail({
    super.key,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
        Text(
          detail,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            color: Theme.of(context).colorScheme.scrim,
          ),
        ),
      ],
    );
  }
}
