import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class GiftCardScreen extends ConsumerStatefulWidget {
  const GiftCardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends ConsumerState<GiftCardScreen> {
  @override
  void initState() {
    final vm = ref.read(giftCardVm);
    vm.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Gift Card",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        centerTitle: false,
        actions: [BalanceWidget()],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              "Select Country",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
              ),
            ),
            SizedBox(height: 10),
            CountryDropdown(),
            SizedBox(height: 10),
            GiftCardDropdown(),
            SizedBox(height: 10),
            AmountDropdown(),
            SizedBox(height: 10),
            GiftcardQuantitySelector(),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () {
                  AppOverlays.confirmGiftcard(context: context);
                },
                actionText: "Continue",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
