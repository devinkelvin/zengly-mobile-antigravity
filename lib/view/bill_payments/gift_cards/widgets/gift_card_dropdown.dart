import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class GiftCardDropdown extends ConsumerWidget {
  const GiftCardDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(giftCardVm);
    return InkWell(
      onTap: () {
        AppOverlays.giftCardOptions(
          context: context,
          title: "Choose Gift cards",
          options: vm.giftcardOptions,
          selectedOption: vm.selectedGiftcard,
          onPressed: (id) {
            vm.selectGiftCard(id);
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
            vm.selectedGiftcard == null
                ? Text(
                  "Select Gift Cards",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                )
                : Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(50),
                      child: Image.asset(
                        vm.selectedGiftcard!.image!,
                        width: 36,
                        height: 36,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(vm.selectedGiftcard!.name!),
                  ],
                ),
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
