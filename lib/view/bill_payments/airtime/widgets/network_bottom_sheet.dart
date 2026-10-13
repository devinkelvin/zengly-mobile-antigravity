import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../view.dart';

class NetworkBottomSheet extends ConsumerWidget {
  const NetworkBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(airtimeVm);
    return Column(
      children: [
        Text(
          "Select Network Provider",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vm.networks.length,
          itemBuilder: (context, i) {
            final network = vm.networks[i];
            return NetworkSelector(
              isSelected: vm.selectedNetwork == network,
              model: network,
              index: i,
            );
          },
        ),
      ],
    );
  }
}

class NetworkSelector extends ConsumerWidget {
  final bool isSelected;
  final NetworkModel model;
  final int index;
  const NetworkSelector({
    super.key,
    required this.isSelected,
    required this.model,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final vm = ref.read(airtimeVm);
        vm.updateNetworkModel(index: index);
        context.pop();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.outlineVariant,
          border:
              isSelected
                  ? Border.all(
                    color: Theme.of(context).colorScheme.scrim,
                    width: 1,
                  )
                  : null,
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                shape: BoxShape.circle,
              ),
              child: Image.asset(model.image),
            ),
            SizedBox(width: 8),
            Text(model.name),
            Spacer(),
            if (isSelected)
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
  }
}
