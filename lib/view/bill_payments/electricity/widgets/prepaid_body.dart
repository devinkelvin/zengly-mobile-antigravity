import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../../../view.dart';

class PrepaidBody extends ConsumerStatefulWidget {
  const PrepaidBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrepaidBodyState();
}

class _PrepaidBodyState extends ConsumerState<PrepaidBody> {
  final TextEditingController _meterNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _meterNumberController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _meterNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMeterNumberComplete = _meterNumberController.text.length == 11;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdownTextField(
          labelText: "Select Electric Disco",
          items:
              ["Ikeja Electric", "Ibadan Electric"]
                  .map(
                    (String gender) => DropdownMenuItem(
                      value: gender,
                      child: Row(
                        children: [
                          Image.asset(AppImages.airtel, height: 20),
                          SizedBox(width: 10),
                          Text(gender, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (val) {},
        ),
        SizedBox(height: 16),
        AppTextField(
          controller: _meterNumberController,
          labelText: "Meter Number",
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
        ),
        if (isMeterNumberComplete) ...[
          SizedBox(height: 16),
          ElectricityAccountPreview(),
        ],
        SizedBox(height: 16),
        AppTextField(
          controller: _amountController,
          labelText: "Amount",
          keyboardType: TextInputType.numberWithOptions(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ThousandsFormatter(),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              context.pushNamed(AppRouter.electricityConfirmation);
            },
            actionText: "Continue",
          ),
        ),
      ],
    );
  }
}
