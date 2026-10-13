import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoDropDown extends StatelessWidget {
  final String title;
  final String icon;
  final String subTitle;
  const InfoDropDown({
    super.key,
    required this.title,
    required this.icon,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      collapsedBackgroundColor: Theme.of(context).colorScheme.outlineVariant,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      childrenPadding: EdgeInsets.all(16),
      tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
      iconColor: Theme.of(context).colorScheme.scrim,
      collapsedIconColor: Theme.of(context).colorScheme.scrim,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(icon),
          SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
          Spacer(),
        ],
      ),
      children: [
        Text(
          subTitle,
          style: GoogleFonts.openSans(
            color: Theme.of(context).colorScheme.scrim,
          ),
        ),
      ],
    );
  }
}
