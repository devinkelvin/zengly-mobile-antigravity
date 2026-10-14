import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  final _addressController =
      TextEditingController(text: "14 Admiralty Way, Lekki Phase 1");
  final _stateController = TextEditingController(text: "Lagos State");
  final _cityController = TextEditingController(text: "Eti-Osa");
  final _postalController = TextEditingController(text: "101233");
  String _documentType = "Electricity Utility Bill";
  bool _documentSelected = true;

  @override
  void dispose() {
    _addressController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_addressController.text.trim().isEmpty) {
      AppOverlays.showToast(
        context: context,
        message: "Please enter your street address",
      );
      return;
    }

    AppOverlays.bottomSheet(
      context: context,
      isSuccess: true,
      action: () {
        context.pop();
        context.pop();
      },
      title: "Address Submitted!",
      content:
          "Your proof of address has been uploaded and queued for Tier 3 verification.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Proof of Address",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: AppDimensions.viewPadding,
          width: double.infinity,
          child: AppButton(
            onPressed: _submit,
            actionText: "Submit Proof of Address",
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Residential Information",
              style: GoogleFonts.raleway(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Must match the address shown on your uploaded utility document.",
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            AppTextField(
              controller: _addressController,
              labelText: "Residential Street Address",
              autofillHints: const [AutofillHints.streetAddressLevel1],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _stateController,
                    labelText: "State",
                    autofillHints: const [AutofillHints.addressState],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    controller: _cityController,
                    labelText: "City / LGA",
                    autofillHints: const [AutofillHints.addressCity],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            AppTextField(
              controller: _postalController,
              labelText: "Postal / Zip Code",
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.postalCode],
            ),

            const SizedBox(height: 28),

            Text(
              "Select Document Type",
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE2D6C5),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _documentType,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: [
                    "Electricity Utility Bill",
                    "Bank Account Statement",
                    "Water Service Bill",
                    "Waste Management Bill",
                    "Tenancy Agreement Receipt",
                  ].map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc,
                      child: Text(
                        doc,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _documentType = val);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Proof of Address Upload Area
            GestureDetector(
              onTap: () {
                setState(() => _documentSelected = true);
                AppOverlays.showToast(
                  context: context,
                  title: "Document Attached",
                  message: "$_documentType (PDF/Image) ready for submission",
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262017) : const Color(0xFFF7F2E7),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _documentSelected
                        ? const Color(0xFF34C759)
                        : primaryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _documentSelected
                            ? const Color(0xFF34C759).withValues(alpha: 0.15)
                            : primaryColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _documentSelected
                            ? Icons.check_circle_rounded
                            : Icons.cloud_upload_outlined,
                        color: _documentSelected
                            ? const Color(0xFF34C759)
                            : primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _documentSelected
                          ? "Utility_Bill_IKEDC_Aug2026.pdf"
                          : "Tap to upload document (PDF, PNG, JPG)",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1E1A14),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _documentSelected
                          ? "Document verified • Ready for submission"
                          : "Must not be older than 3 months",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: _documentSelected
                            ? const Color(0xFF34C759)
                            : (isDark ? Colors.white54 : Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
