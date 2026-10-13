import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';
import '../../view.dart';

class SelectCardType extends ConsumerStatefulWidget {
  const SelectCardType({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectCardTypeState();
}

class _SelectCardTypeState extends ConsumerState<SelectCardType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Select Card Type",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Seamlessly top up & renew subscriptions",
              style: GoogleFonts.inter(
                fontSize: 12,
                letterSpacing: 0,
                color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
              ),
            ),
            SizedBox(height: 20),
            SelectCardTypeWidget(
              title: "Mastercard",
              subTitle: "Seamlessly top up & renew ",
            ),
            SelectCardTypeWidget(
              title: "Visa Card",
              subTitle: "Shop across 100s of stores globally",
            ),
            SelectCardTypeWidget(
              title: "Dollar Card",
              subTitle: "Seamlessly top up & renew ",
            ),
          ],
        ),
      ),
    );
  }
}
