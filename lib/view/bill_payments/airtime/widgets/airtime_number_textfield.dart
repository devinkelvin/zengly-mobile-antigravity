import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class AirtimeNumberTextfield extends ConsumerStatefulWidget {
  final TextEditingController controller;
  const AirtimeNumberTextfield({super.key, required this.controller});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AirtimeNumberTextfieldState();
}

class _AirtimeNumberTextfieldState
    extends ConsumerState<AirtimeNumberTextfield> {
  @override
  void initState() {
    super.initState();
    ref.read(airtimeVm).initalizeNetwork();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(airtimeVm);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.outlineVariant,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: GestureDetector(
              onTap: () {
                AppOverlays.networkSheet(context: context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(vm.selectedNetwork!.image, height: 24, width: 24),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down_outlined, size: 16),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            width: 2,
            height: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                PhoneNumberFormatter(),
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 0,
                ),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () {
                    AppOverlays.contactSheet(context: context);
                  },
                  icon: SvgPicture.asset(AppImages.accountCircle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
