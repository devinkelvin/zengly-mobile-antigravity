import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../view.dart';

class SprayCashForm1 extends ConsumerStatefulWidget {
  const SprayCashForm1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SprayCashForm1State();
}

class _SprayCashForm1State extends ConsumerState<SprayCashForm1> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(sprayCashVm);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          "Who are you spraying?",
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          itemCount: vm.sprayRecipientTypes.length,
          itemBuilder: (context, i) {
            final sprayItem = vm.sprayRecipientTypes[i];
            return SelectSprayType(
              title: sprayItem.title,
              isSelected: sprayItem.id == vm.selectedRecipientType?.id,
              onTap: () {
                vm.selectSprayRecipientType(id: sprayItem.id);
              },
            );
          },
        ),
      ],
    );
  }
}

class SelectSprayType extends ConsumerWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const SelectSprayType({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 18),
        width: double.infinity,
        alignment: Alignment.centerLeft,

        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(8),
          border:
              isSelected
                  ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  )
                  : null,
        ),
        child: Text(
          title,
          style: GoogleFonts.openSans(fontSize: 16, letterSpacing: 0),
        ),
      ),
    );
  }
}
