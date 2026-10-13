import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class DenominationDropdown extends ConsumerWidget {
  const DenominationDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(sprayCashVm);
    return InkWell(
      onTap: () {
        AppOverlays.selectSprayDenominationSheet(context: context);
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
            vm.selectedDenomination == null
                ? Text(
                  "Select Denomination",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                )
                : Text(
                  "₦${vm.selectedDenomination}",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0,
                  ),
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

class DenominationBottomSheet extends ConsumerWidget {
  const DenominationBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(sprayCashVm);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Select Denomination (Banknotes)",
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0,
              ),
            ),
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vm.sprayDenomications.length,
          itemBuilder: (context, i) {
            final denomication = vm.sprayDenomications[i];
            return GestureDetector(
              onTap: () {
                vm.selectDenomination(newDenomination: denomication);
                context.pop();
              },
              child: Container(
                height: 56,
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color:
                      denomication == 100
                          ? Color(0XFFD6CFDC).withValues(alpha: 0.2)
                          : denomication == 200
                          ? Color(0XFFF88DB4).withValues(alpha: 0.2)
                          : denomication == 300
                          ? Color(0XFFB4CEC9).withValues(alpha: 0.2)
                          : Color(0XFFA9BACC).withValues(alpha: 0.2),
                  border:
                      vm.selectedDenomination == denomication
                          ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          )
                          : Border.all(width: 0),
                ),
                child: Row(
                  children: [
                    Text(
                      "$denomication",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0,
                      ),
                    ),
                    Spacer(),
                    if (vm.selectedDenomination == denomication)
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
