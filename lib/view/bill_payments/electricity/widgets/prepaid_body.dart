import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../electricity_vm.dart';
import 'widgets.dart';

class PrepaidBody extends ConsumerStatefulWidget {
  const PrepaidBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrepaidBodyState();
}

class _PrepaidBodyState extends ConsumerState<PrepaidBody> {
  final TextEditingController _meterNumberController =
      TextEditingController(text: "04289104821");
  final TextEditingController _amountController =
      TextEditingController(text: "10,000");
  String _selectedDisco = "Ikeja Electric (IKEDC)";
  final List<int> _quickAmounts = [2000, 5000, 10000, 20000, 50000];

  final List<Map<String, String>> _savedMeters = [
    {
      "label": "Home Lekki",
      "number": "04289104821",
      "disco": "Ikeja Electric (IKEDC)",
      "address": "14 Admiralty Way, Lekki Phase 1, Lagos",
    },
    {
      "label": "Office VI",
      "number": "01948201942",
      "disco": "Eko Electricity (EKEDC)",
      "address": "Plot 24 Adeola Odeku, Victoria Island, Lagos",
    },
  ];

  final List<Map<String, String>> _discos = [
    {"name": "Ikeja Electric (IKEDC)", "code": "IKEDC"},
    {"name": "Eko Electricity (EKEDC)", "code": "EKEDC"},
    {"name": "Abuja Electricity (AEDC)", "code": "AEDC"},
    {"name": "Ibadan Electricity (IBEDC)", "code": "IBEDC"},
    {"name": "Enugu Electricity (EEDC)", "code": "EEDC"},
    {"name": "Kano Electricity (KEDCO)", "code": "KEDCO"},
    {"name": "Port Harcourt (PHED)", "code": "PHED"},
    {"name": "Jos Electricity (JED)", "code": "JED"},
    {"name": "Kaduna Electric (KAEDCO)", "code": "KAEDCO"},
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
    return (amount / 68.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMeterValid = _meterNumberController.text.length >= 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saved Meters Quick Pills
        Text(
          "Saved Meter Profiles",
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : const Color(0xFF6B5E4A),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _savedMeters.map((m) {
            final isSelected = _meterNumberController.text == m["number"];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _meterNumberController.text = m["number"]!;
                  _selectedDisco = m["disco"]!;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFB57510).withValues(alpha: 0.15)
                      : (isDark ? const Color(0xFF241F18) : Colors.white),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFB57510)
                        : (isDark ? Colors.white10 : const Color(0xFFE2D6C5)),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 14,
                      color: isSelected
                          ? const Color(0xFFB57510)
                          : (isDark ? Colors.white60 : Colors.black54),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      m["label"]!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFFB57510)
                            : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Select Disco Dropdown Card
        Text(
          "Electric Distribution Company",
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : const Color(0xFF6B5E4A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF221D17) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? Colors.white10 : const Color(0xFFE2D6C5),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDisco,
              isExpanded: true,
              dropdownColor: isDark ? const Color(0xFF221D17) : Colors.white,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: _discos.map((d) {
                return DropdownMenuItem<String>(
                  value: d["name"],
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB57510).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bolt_rounded,
                          color: Color(0xFFB57510),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        d["name"]!,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF1E1A14),
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
            final isSelected =
                _amountController.text.replaceAll(',', '') == amt.toString();

            return ChoiceChip(
              label: Text("₦$formatted"),
              selected: isSelected,
              selectedColor: const Color(0xFFB57510),
              backgroundColor:
                  isDark ? const Color(0xFF241F18) : const Color(0xFFF2ECE1),
              labelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : const Color(0xFF1E1A14)),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFFB57510)
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
              color: const Color(0xFFB57510).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFB57510).withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.electric_meter_outlined,
                  size: 20,
                  color: Color(0xFFB57510),
                ),
                const SizedBox(width: 8),
                Text(
                  "Estimated Energy Units: ",
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                Text(
                  "~${_estimatedUnits.toStringAsFixed(1)} kWh",
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFB57510),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Continue Button
        AppButton.primary(
          onPressed: () {
            if (_meterNumberController.text.trim().isEmpty) {
              AppOverlays.showToast(
                context: context,
                message: "Please enter your meter number",
                toastType: ToastificationType.error,
              );
              return;
            }
            if (_amountController.text.trim().isEmpty) {
              AppOverlays.showToast(
                context: context,
                message: "Please enter a recharge amount",
                toastType: ToastificationType.error,
              );
              return;
            }

            ref.read(electricityVm).setTransactionDetails(
                  disco: _selectedDisco,
                  meterNumber: _meterNumberController.text,
                  amount: _amountController.text,
                  customerName: "Kelvin Ekuhoho",
                  address: "14 Admiralty Way, Lekki Phase 1, Lagos",
                  type: ElectricityType.prepaid,
                );

            context.pushNamed(AppRouter.electricityConfirmation);
          },
          actionText: "Continue to Payment",
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
