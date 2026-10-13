import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class SprayCurrencyDropdown extends ConsumerWidget {
  const SprayCurrencyDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(sprayCashVm);
    return InkWell(
      onTap: () {
        AppOverlays.selectSprayCurrencySheet(context: context);
      },
      radius: 15,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 19, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            vm.selectedCurrencyType == null
                ? Text(
                  "Choose Currency",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                )
                : Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(50),
                      child: Image.asset(
                        vm.selectedCurrencyType!.image,
                        width: 36,
                        height: 36,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(vm.selectedCurrencyType!.name),
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
