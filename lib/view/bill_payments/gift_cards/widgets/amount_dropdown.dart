import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class AmountDropdown extends ConsumerWidget {
  const AmountDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(giftCardVm);
    return InkWell(
      onTap: () {
        AppOverlays.giftCardOptions(
          context: context,
          title: "Choose Amount",
          options: vm.amountOptions,
          selectedOption: vm.selectedAmount,
          onPressed: (id) {
            vm.selectAmount(id);
          },
        );
      },
      radius: 15,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 19, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            vm.selectedAmount == null
                ? Text(
                  "Select An Amount",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                )
                : Row(children: [Text(vm.selectedAmount!.amount!)]),
            Spacer(),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ],
        ),
      ),
    );
  }
}
