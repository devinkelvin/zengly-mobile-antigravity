import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class SprayAnimationDropdown extends ConsumerWidget {
  const SprayAnimationDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(sprayCashVm);
    return InkWell(
      onTap: () {
        AppOverlays.selectSprayAnimationSheet(context: context);
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
            vm.selectedAnimation == null
                ? Text(
                  "Spray Animation",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                )
                : Text(
                  "${vm.selectedAnimation}",
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

class SprayAnimationBottomSheet extends ConsumerWidget {
  const SprayAnimationBottomSheet({super.key});

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
              "Select Animation",
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
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.sprayAnimations.length,
          itemBuilder: (context, i) {
            final animation = vm.sprayAnimations[i];
            return GestureDetector(
              onTap: () {
                vm.selectAnimation(newAnimation: animation);
                context.pop();
              },
              child: Container(
                height: 56,
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).colorScheme.outlineVariant,
                  border:
                      vm.selectedAnimation == animation
                          ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          )
                          : null,
                ),
                child: Row(
                  children: [
                    Text(
                      animation,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0,
                      ),
                    ),
                    Spacer(),
                    if (vm.selectedAnimation == animation)
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
