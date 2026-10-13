import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class SprayCashForm2 extends ConsumerStatefulWidget {
  const SprayCashForm2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SprayCashForm2State();
}

class _SprayCashForm2State extends ConsumerState<SprayCashForm2> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(sprayCashVm);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          AmountTextField(hasFee: false),
          SizedBox(height: 20),
          SprayCurrencyDropdown(),
          if (vm.currentStep >= 2)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SizedBox(height: 20), DenominationDropdown()],
            ),
          if (vm.currentStep >= 3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                SprayAnimationDropdown(),
                SizedBox(height: 20),
                Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Auto Spray Mode",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 0,
                        ),
                      ),

                      Spacer(),
                      Switch(
                        value: vm.isAutoSprayMode,
                        onChanged: (val) {
                          vm.updateAutoSprayMode(newMode: val);
                        },
                        activeThumbColor:
                            Theme.of(context).colorScheme.onPrimary,
                        activeTrackColor:
                            Theme.of(context).colorScheme.tertiary,
                        inactiveThumbColor:
                            Theme.of(context).colorScheme.onPrimary,
                        inactiveTrackColor:
                            Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (vm.selectedAnimation != null)
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: () {
                        vm.goToSelectRecipient();
                      },
                      actionText: "Choose Recipient",
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
