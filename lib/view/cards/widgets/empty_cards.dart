import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class EmptyCards extends ConsumerWidget {
  final bool isPhysicalCards;
  const EmptyCards({super.key, required this.isPhysicalCards});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 100),
          SvgPicture.asset(AppImages.emptyCards),
          SizedBox(height: 20),
          Text(
            isPhysicalCards ? "No Card Created Yet 💳" : "No Virtual Card Yet?",
            style: GoogleFonts.raleway(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 20),
          Text(
            isPhysicalCards
                ? "It looks like you haven’t set up a card yet. Don’t worry—it’s quick and easy!\n\nHit the ‘Create Card’ button to begin. 🚀"
                : "Create one in seconds for secure online payments. Tap ‘Create Virtual Card’ to get started!",
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () {
                context.pushNamed(AppRouter.selectCardType);
              },
              actionText:
                  isPhysicalCards
                      ? "+ Create a New Debit Card"
                      : "+ Get a New Virtual Card",
            ),
          ),
        ],
      ),
    );
  }
}
