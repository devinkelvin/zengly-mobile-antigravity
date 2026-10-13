import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../view.dart';

class GiftcardQuantitySelector extends ConsumerWidget {
  const GiftcardQuantitySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(giftCardVm);
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quantity",
            style: GoogleFonts.inter(
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                  child: Text("${vm.quantitySelected}"),
                ),
              ),
              SizedBox(width: 10),
              Container(
                height: 48,
                //  padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        vm.decreaseQuantity(context: context);
                      },
                      child: Icon(Icons.remove),
                    ),
                    SizedBox(width: 12),
                    Container(
                      height: 48,
                      width: 1,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        vm.increaseQuantity();
                      },
                      child: Icon(Icons.add),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
