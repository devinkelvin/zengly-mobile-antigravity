import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AlternativeOption extends ConsumerWidget {
  final String image, title;
  final VoidCallback onPressed;
  final bool isBluetooth;
  const AlternativeOption({
    super.key,
    required this.image,
    required this.title,
    required this.onPressed,
    required this.isBluetooth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(image),
            SizedBox(width: 14),
            Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
