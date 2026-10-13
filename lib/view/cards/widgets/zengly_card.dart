import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';

class ZenglyCard extends StatelessWidget {
  const ZenglyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: AspectRatio(
          aspectRatio: 5 / 3,
          child: Container(
            width: Responsive.width(context) < 320 ? double.infinity : 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF303030), Color(0xFF181818)],
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 20),
                Column(
                  children: [
                    SizedBox(height: 30),
                    GradientText(
                      "Zengly",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                      colors: [
                        Color(0XFFC33E6A),
                        Theme.of(context).colorScheme.primary,
                      ],
                    ),
                  ],
                ),
                Spacer(),
                SvgPicture.asset(
                  AppImages.africa,
                  height: 180,
                  fit: BoxFit.fitHeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
