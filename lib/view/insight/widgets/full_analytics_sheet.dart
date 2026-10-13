import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class FullAnalyticsSheet extends StatelessWidget {
  final VoidCallback onNotify;

  const FullAnalyticsSheet({super.key, required this.onNotify});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppImages.walletPurse, height: 110),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Coming soon",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Deep spending insights \ncash flow, category trends, \nforecasts",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          "Expected in next update",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.scrim,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: onNotify,
            actionText: "Notify me when it's ready",
            backgroundColor: const Color(0xFFDB443A),
            borderRadius: 30,
          ),
        ),
      ],
    );
  }
}
