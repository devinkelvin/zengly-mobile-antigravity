import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import 'widgets.dart';

class PrepaidBody extends ConsumerStatefulWidget {
  const PrepaidBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrepaidBodyState();
}

class _PrepaidBodyState extends ConsumerState<PrepaidBody> {
  final TextEditingController _meterNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedDisco = "Ikeja Electric (IKEDC)";
  final List<int> _quickAmounts = [1000, 2000, 5000, 10000, 20000];

  final List<Map<String, String>> _discos = [
    {"name": "Ikeja Electric (IKEDC)", "code": "IKEDC"},
    {"name": "Eko Electricity (EKEDC)", "code": "EKEDC"},
    {"name": "Abuja Electricity (AEDC)", "code": "AEDC"},
    {"name": "Ibadan Electricity (IBEDC)", "code": "IBEDC"},
    {"name": "Enugu Electricity (EEDC)", "code": "EEDC"},
    {"name": "Kano Electricity (KEDCO)", "code": "KEDCO"},
    {"name": "Port Harcourt (PHED)", "code": "PHED"},
  ];

  @override
  void initState() {
    super.initState();
    _meterNumberController.addListener(() => setState(() {}));
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _meterNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  double get _estimatedUnits {
    final text = _amountController.text.replaceAll(',', '').trim();
    final amount = double.tryParse(text) ?? 0;
    if (amount <= 0) return 0;
    // Standard Band A/B tariff estimate ~₦68/kWh
    return (amount / 68.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isMeterValid = _meterNumberController.text.length >= 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Select Disco Dropdown
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
              value: _selectedDisco,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: _discos.map((d) {
                return DropdownMenuItem<String>(
                  value: d["name"],
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.bolt_rounded,
                          color: primaryColor,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        d["name"]!,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedDisco = val);
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Meter Number
        AppTextField(
          controller: _meterNumberController,
          labelText: "Prepaid Meter Number",
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
        ),

        if (isMeterValid) ...[
          const SizedBox(height: 14),
          ElectricityAccountPreview(
            meterNumber: _meterNumberController.text,
            customerName: "Kelvin Ekuhoho",
            address: "14 Admiralty Way, Lekki Phase 1, Lagos",
          ),
        ],

        const SizedBox(height: 16),

        // Amount Field
        AppTextField(
          controller: _amountController,
          labelText: "Recharge Amount (₦)",
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ThousandsFormatter(),
          ],
        ),

        const SizedBox(height: 12),

        // Quick Amount Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickAmounts.map((amt) {
            final formatted = NumberFormat("#,##0").format(amt);
            final isSelected = _amountController.text.replaceAll(',', '') == amt.toString();

            return ChoiceChip(
              label: Text("₦$formatted"),
              selected: isSelected,
              selectedColor: primaryColor,
              backgroundColor: Theme.of(context).colorScheme.outlineVariant,
              labelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(
                  color: isSelected
                      ? primaryColor
                      : (isDark ? Colors.white12 : const Color(0xFFE2D6C5)),
                ),
              ),
              onSelected: (_) {
                _amountController.text = formatted;
              },
            );
          }).toList(),
        ),

        if (_estimatedUnits > 0) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                Icon(Icons.electric_meter_outlined, size: 18, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  "Estimated Power: ",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  "~${_estimatedUnits.toStringAsFixed(1)} kWh",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Continue Button
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              if (_meterNumberController.text.trim().isEmpty) {
                AppOverlays.showToast(
                  context: context,
                  message: "Please enter your meter number",
                );
                return;
              }
              if (_amountController.text.trim().isEmpty) {
                AppOverlays.showToast(
                  context: context,
                  message: "Please enter a recharge amount",
                );
                return;
              }
              context.pushNamed(AppRouter.electricityConfirmation);
            },
            actionText: "Continue to Payment",
          ),
        ),
      ],
    );
  }
}
