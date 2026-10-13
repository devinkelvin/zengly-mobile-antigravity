import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class AddressVerificationScreen extends ConsumerStatefulWidget {
  const AddressVerificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressVerificationScreenState();
}

class _AddressVerificationScreenState
    extends ConsumerState<AddressVerificationScreen> {
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Address Verification",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: AppDimensions.viewPadding,
          width: double.infinity,
          child: AppButton(onPressed: () {}, actionText: "Continue"),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _addressController,
              labelText: "Address",
              autofillHints: [AutofillHints.streetAddressLevel1],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _stateController,
                    labelText: "State",
                    autofillHints: [AutofillHints.addressState],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    controller: _cityController,
                    labelText: "City",
                    autofillHints: [AutofillHints.addressCity],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            AppTextField(
              controller: _postalController,
              labelText: "Postal Code",
              autofillHints: [AutofillHints.postalCode],
            ),
            SizedBox(height: 32),
            Text(
              "Upload Proof of Address",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 16),
            ProofOfAddress(),
          ],
        ),
      ),
    );
  }
}
