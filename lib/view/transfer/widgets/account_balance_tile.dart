import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';

class AccountBalanceTile extends StatelessWidget {
  const AccountBalanceTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Image.asset(AppImages.nigerianFlag, height: 20, width: 20),
          SizedBox(width: 8),
          Text(
            "NGN Balance",
            style: GoogleFonts.inter(fontSize: 12, letterSpacing: 0),
          ),
          Spacer(),
          Text(
            "₦ 1,207,882.00",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
