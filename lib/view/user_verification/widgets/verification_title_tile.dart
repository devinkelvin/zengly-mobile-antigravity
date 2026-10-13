import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';

class VerificationTitleTile extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final VoidCallback onTap;
  const VerificationTitleTile({
    super.key,
    required this.title,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isCompleted ? null : onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        height: 56,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.shadow,
                ),
              ),
            ),

            isCompleted
                ? SvgPicture.asset(AppImages.tickSquare)
                : SvgPicture.asset(AppImages.arrowRight),
          ],
        ),
      ),
    );
  }
}
