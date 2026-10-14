import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../electricity_vm.dart';
import 'widgets.dart';

class PostpaidBody extends ConsumerStatefulWidget {
  const PostpaidBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostpaidBodyState();
}

class _PostpaidBodyState extends ConsumerState<PostpaidBody> {
  final TextEditingController _meterNumberController =
      TextEditingController(text: "01849201948");
  final TextEditingController _amountController =
      TextEditingController(text: "42,500");
  String _selectedDisco = "Ikeja Electric (IKEDC)";
  bool _payFullBill = true;

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMeterValid = _meterNumberController.text.length >= 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Select Disco Dropdown
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
                          Icons.receipt_long_rounded,
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
          labelText: "Postpaid Account / Meter Number",
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
          const SizedBox(height: 14),

          // Outstanding Balance Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2B1F19) : const Color(0xFFFDF2EC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD9480F).withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.pending_actions_rounded,
                          color: Color(0xFFD9480F),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Current Bill Balance",
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9480F).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "Due in 6 Days",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFD9480F),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "₦42,500.00",
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFD9480F),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text("Pay Full ₦42,500")),
                        selected: _payFullBill,
                        selectedColor: const Color(0xFFB57510),
                        backgroundColor: isDark
                            ? const Color(0xFF1F1A14)
                            : const Color(0xFFEDE5D5),
                        labelStyle: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _payFullBill
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        onSelected: (val) {
                          setState(() {
                            _payFullBill = true;
                            _amountController.text = "42,500";
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text("Pay Partial")),
                        selected: !_payFullBill,
                        selectedColor: const Color(0xFFB57510),
                        backgroundColor: isDark
                            ? const Color(0xFF1F1A14)
                            : const Color(0xFFEDE5D5),
                        labelStyle: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: !_payFullBill
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        onSelected: (val) {
                          setState(() {
                            _payFullBill = false;
                            _amountController.text = "20,000";
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Amount Field
        AppTextField(
          controller: _amountController,
          labelText: "Settlement Amount (₦)",
          keyboardType: const TextInputType.numberWithOptions(),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ThousandsFormatter(),
          ],
        ),

        const SizedBox(height: 24),

        // Continue Button
        SizedBox(
          width: double.infinity,
          child: AppButton.primary(
            onPressed: () {
              if (_meterNumberController.text.trim().isEmpty) {
                AppOverlays.showToast(
                  context: context,
                  message: "Enter your postpaid account number",
                  toastType: ToastificationType.error,
                );
                return;
              }
              if (_amountController.text.trim().isEmpty) {
                AppOverlays.showToast(
                  context: context,
                  message: "Enter an amount to settle",
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
                    type: ElectricityType.postpaid,
                  );

              context.pushNamed(AppRouter.electricityConfirmation);
            },
            actionText: "Settle Postpaid Bill",
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
