import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../widgets/widgets.dart';
import 'airtime_to_cash_vm.dart';

class AirtimeToCashScreen extends ConsumerStatefulWidget {
  const AirtimeToCashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AirtimeToCashScreenState();
}

class _AirtimeToCashScreenState extends ConsumerState<AirtimeToCashScreen> {
  final _phoneController = TextEditingController();
  final _sharePinController = TextEditingController();
  String _amount = "";

  @override
  void dispose() {
    _phoneController.dispose();
    _sharePinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(airtimeToCashVm);
    final receivable = vm.receivableAmount(_amount);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Airtime to Cash",
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [BalanceWidget()],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.6,
              ),
              itemCount: vm.networks.length,
              itemBuilder: (context, index) {
                final network = vm.networks[index];
                final isSelected = network.name == vm.selectedNetwork.name;
                return GestureDetector(
                  onTap: () => vm.selectNetwork(network),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                network.image,
                                height: 28,
                                width: 28,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              network.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            height: 18,
                            width: 18,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _phoneController,
              labelText: "Enter phone number",
              keyboardType: TextInputType.phone,
              icon: AppImages.accountCircle,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                PhoneNumberFormatter(),
              ],
            ),
            const SizedBox(height: 16),
            AmountTextField(
              hasFee: false,
              onAmountChanged: (value) => setState(() => _amount = value),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "You will receive",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.scrim,
                  ),
                ),
                Text(
                  "₦${NumberFormat("#,##0.00").format(receivable)}",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _sharePinController,
              labelText: "Enter your ${vm.selectedNetwork.name} Share PIN",
              keyboardType: TextInputType.number,
              isPassword: true,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text:
                    "This is the PIN required by your network provider to transfer your airtime to us. ",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.scrim,
                ),
                children: [
                  TextSpan(
                    text:
                        "Learn how to get your ${vm.selectedNetwork.name} Share PIN",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap =
                              () => AppOverlays.sharePinHelpSheet(
                                context: context,
                                networkName: vm.selectedNetwork.name,
                              ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed:
                    () => vm.startConversion(
                      context: context,
                      phone: _phoneController.text.replaceAll('-', ''),
                      amount: _amount,
                      sharePin: _sharePinController.text,
                    ),
                actionText: "Continue",
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
