import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/widgets.dart';
import 'electricity_confirmation_screen.dart';

class ElectricityScreen extends ConsumerStatefulWidget {
  const ElectricityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ElectricityScreenState();
}

class _ElectricityScreenState extends ConsumerState<ElectricityScreen> {
  bool _isPrepaid = true;
  final TextEditingController _meterController =
      TextEditingController(text: "57689464638");
  final TextEditingController _amountController =
      TextEditingController(text: "10000");

  @override
  void dispose() {
    _meterController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onSelectPreset(int amount) {
    HapticFeedback.lightImpact();
    setState(() {
      _amountController.text = amount.toString();
    });
  }

  void _onContinue() {
    final meter = _meterController.text.trim();
    final amtText = _amountController.text.trim();
    final amount = double.tryParse(amtText) ?? 0;

    if (meter.length < 8) {
      AppOverlays.showToast(
        context: context,
        title: "Invalid Meter Number",
        message: "Please enter a valid meter number",
        toastType: ToastificationType.warning,
      );
      return;
    }

    if (amount <= 0) {
      AppOverlays.showToast(
        context: context,
        title: "Invalid Amount",
        message: "Please select or enter an amount",
        toastType: ToastificationType.warning,
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ElectricityConfirmationScreen(
          meterNumber: meter,
          amount: amount,
          meterType: _isPrepaid ? "Prepaid" : "Postpaid",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF14120E);
    const cardColor = Color(0xFF1F1D19);
    const inputBg = Color(0xFF262420);
    const primaryAmber = Color(0xFFC58314);
    const dividerColor = Color(0xFF2C2822);

    final currentAmount = int.tryParse(_amountController.text.trim()) ?? 0;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF25231F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          "Bulk Purchase",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card 1: Select Meter Type
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Meter Type",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Prepaid Row
                          InkWell(
                            onTap: () => setState(() => _isPrepaid = true),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Prepaid",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _isPrepaid
                                          ? primaryAmber
                                          : Colors.white38,
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: _isPrepaid
                                      ? Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: primaryAmber,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 24,
                            thickness: 1,
                            color: dividerColor,
                          ),
                          // Postpaid Row
                          InkWell(
                            onTap: () => setState(() => _isPrepaid = false),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Postpaid",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: !_isPrepaid
                                          ? primaryAmber
                                          : Colors.white38,
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: !_isPrepaid
                                      ? Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: primaryAmber,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Card 2: Meter Number
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Meter Number",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Saved Beneficiaries",
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white54,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: inputBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: TextField(
                              controller: _meterController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Enter meter no. (e.g., 57689464638)",
                                hintStyle: TextStyle(color: Colors.white38),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Card 3: Amount with 2x3 Grid
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Amount",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                              const Icon(
                                Icons.info_outline,
                                color: Colors.white54,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          // 2x3 Grid of 6 buttons
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [5000, 10000, 20000, 50000, 100000, 200000]
                                .map((amt) {
                              final isSelected = currentAmount == amt;
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width - 80) / 3,
                                child: InkWell(
                                  onTap: () => _onSelectPreset(amt),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryAmber
                                          : const Color(0xFF2B2823),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "₦${NumberFormat('#,###').format(amt)}",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 18),

                          // Custom Amount
                          Text(
                            "Custom Amount",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: inputBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "₦ ",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: "0.00",
                                      hintStyle:
                                          TextStyle(color: Colors.white38),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF322E28),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "NGN",
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Continue Button matching Screenshot
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAmber,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
