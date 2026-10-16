import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../widgets/widgets.dart';
import 'electricity_confirmation_screen.dart';
import 'electricity_vm.dart';

class ElectricityScreen extends ConsumerStatefulWidget {
  const ElectricityScreen({super.key});

  @override
  ConsumerState<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends ConsumerState<ElectricityScreen> {
  bool _isPrepaid = true;

  // Selected DisCo
  String _selectedDiscoName = "Ikeja Electric (IKEDC)";
  String _selectedDiscoCoverage = "Lagos Mainland & Environs";
  Color _selectedDiscoColor = const Color(0xFFE55300);

  // Meter controllers & validation state
  final TextEditingController _meterController =
      TextEditingController(text: "57689464638");
  final TextEditingController _amountController =
      TextEditingController(text: "10000");

  bool _isValidatingMeter = false;
  bool _isMeterVerified = true;
  String _verifiedCustomerName = "ADEWALE OLUSOLA BABATUNDE";
  String _verifiedAddress = "Plot 14 Admiralty Way, Lekki Phase 1, Lagos";
  String _verifiedTariffBand = "Band A • 20+ Hrs/Day";

  // List of all 11 Licensed Nigerian Electricity Distribution Companies
  final List<Map<String, dynamic>> _discos = [
    {
      "name": "Ikeja Electric (IKEDC)",
      "coverage": "Lagos Mainland, Ikeja, Alimosho, Ikorodu",
      "color": Color(0xFFE55300),
      "short": "IKEDC",
    },
    {
      "name": "Eko Electricity (EKEDC)",
      "coverage": "Lagos Island, Victoria Island, Lekki, Epe",
      "color": Color(0xFF007ACC),
      "short": "EKEDC",
    },
    {
      "name": "Abuja Electricity (AEDC)",
      "coverage": "FCT Abuja, Kogi, Niger, Nasarawa",
      "color": Color(0xFF00875A),
      "short": "AEDC",
    },
    {
      "name": "Ibadan Electricity (IBEDC)",
      "coverage": "Oyo, Ogun, Osun, Kwara",
      "color": Color(0xFFD9381E),
      "short": "IBEDC",
    },
    {
      "name": "Kano Electricity (KEDCO)",
      "coverage": "Kano, Katsina, Jigawa",
      "color": Color(0xFF2684FF),
      "short": "KEDCO",
    },
    {
      "name": "Port Harcourt Electricity (PHED)",
      "coverage": "Rivers, Bayelsa, Cross River, Akwa Ibom",
      "color": Color(0xFF5243AA),
      "short": "PHED",
    },
    {
      "name": "Enugu Electricity (EEDC)",
      "coverage": "Enugu, Abia, Imo, Anambra, Ebonyi",
      "color": Color(0xFFFFAB00),
      "short": "EEDC",
    },
    {
      "name": "Jos Electricity (JEDC)",
      "coverage": "Plateau, Bauchi, Benue, Gombe",
      "color": Color(0xFF00B8D9),
      "short": "JEDC",
    },
    {
      "name": "Kaduna Electricity (KAEDCO)",
      "coverage": "Kaduna, Sokoto, Kebbi, Zamfara",
      "color": Color(0xFF36B37E),
      "short": "KAEDCO",
    },
    {
      "name": "Benin Electricity (BEDC)",
      "coverage": "Edo, Delta, Ondo, Ekiti",
      "color": Color(0xFFFF5630),
      "short": "BEDC",
    },
    {
      "name": "Yola Electricity (YEDC)",
      "coverage": "Adamawa, Borno, Taraba, Yobe",
      "color": Color(0xFF6554C0),
      "short": "YEDC",
    },
  ];

  // Quick Preset Amounts
  final List<int> _presetAmounts = [2000, 5000, 10000, 20000, 50000, 100000];

  // Saved Beneficiaries
  final List<Map<String, String>> _savedMeters = [
    {
      "label": "Home (Lekki)",
      "disco": "Eko Electricity (EKEDC)",
      "meter": "57689464638",
      "type": "Prepaid",
    },
    {
      "label": "Office (VI)",
      "disco": "Eko Electricity (EKEDC)",
      "meter": "04289104821",
      "type": "Postpaid",
    },
    {
      "label": "Parents (Ikeja)",
      "disco": "Ikeja Electric (IKEDC)",
      "meter": "10928374650",
      "type": "Prepaid",
    },
  ];

  @override
  void initState() {
    super.initState();
    _meterController.addListener(_onMeterChanged);
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _meterController.removeListener(_onMeterChanged);
    _meterController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onMeterChanged() {
    final clean = _meterController.text.trim();
    if (clean.length >= 10 && clean.length <= 13) {
      _validateMeterNumber(clean);
    } else {
      if (_isMeterVerified) {
        setState(() {
          _isMeterVerified = false;
        });
      }
    }
  }

  Future<void> _validateMeterNumber(String meter) async {
    setState(() {
      _isValidatingMeter = true;
      _isMeterVerified = false;
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    String name = "ADEWALE OLUSOLA BABATUNDE";
    String address = "Plot 14 Admiralty Way, Lekki Phase 1, Lagos";
    String band = "Band A • 20+ Hrs/Day";

    if (meter.startsWith("042") || meter.startsWith("109")) {
      name = "KELVIN EKUHOHO & ASSOCIATES";
      address = "Block 8, Suite 12, Victoria Island Commercial Hub, Lagos";
      band = "Band A • 24 Hrs/Day";
    } else if (meter.startsWith("200")) {
      name = "CHUKWUEMEKA OBI";
      address = "18 Independence Layout, Enugu";
      band = "Band B • 16+ Hrs/Day";
    } else if (meter.startsWith("803") || meter.startsWith("902")) {
      name = "FATIMA BELLO SULEIMAN";
      address = "45 Gana Street, Maitama, Abuja";
      band = "Band A • 20+ Hrs/Day";
    }

    setState(() {
      _isValidatingMeter = false;
      _isMeterVerified = true;
      _verifiedCustomerName = name;
      _verifiedAddress = address;
      _verifiedTariffBand = band;
    });
  }

  void _onSelectPreset(int amount) {
    HapticFeedback.lightImpact();
    setState(() {
      _amountController.text = amount.toString();
    });
  }

  void _pasteMeterNumber() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      final clean = data.text!.replaceAll(RegExp(r'[^0-9]'), '');
      if (clean.isNotEmpty) {
        _meterController.text = clean;
      }
    }
  }

  void _openDiscoPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16140F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String q = "";
        return StatefulBuilder(
          builder: (context, setPickerState) {
            final filtered = _discos.where((d) {
              final name = (d["name"] as String).toLowerCase();
              final cov = (d["coverage"] as String).toLowerCase();
              return name.contains(q.toLowerCase()) || cov.contains(q.toLowerCase());
            }).toList();

            return Container(
              padding: EdgeInsets.only(
                top: 18,
                left: 18,
                right: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Select Electricity Distribution Company (DisCo)",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Search
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF221F18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 18, color: Colors.white54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => setPickerState(() => q = val),
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 13.5),
                            decoration: const InputDecoration(
                              hintText: "Search DisCo or state coverage...",
                              hintStyle: TextStyle(color: Colors.white38),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
                      itemBuilder: (context, i) {
                        final d = filtered[i];
                        final isSel = d["name"] == _selectedDiscoName;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          leading: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (d["color"] as Color).withValues(alpha: 0.15),
                              border: Border.all(color: (d["color"] as Color).withValues(alpha: 0.4)),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.bolt_rounded, color: Color(0xFFE5A93C), size: 20),
                          ),
                          title: Text(
                            d["name"] as String,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w600,
                              color: isSel ? const Color(0xFFE5A93C) : Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            d["coverage"] as String,
                            style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white54),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: isSel
                              ? const Icon(Icons.check_circle_rounded, color: Color(0xFFE5A93C), size: 20)
                              : null,
                          onTap: () {
                            Navigator.pop(ctx);
                            setState(() {
                              _selectedDiscoName = d["name"] as String;
                              _selectedDiscoCoverage = d["coverage"] as String;
                              _selectedDiscoColor = d["color"] as Color;
                            });
                            if (_meterController.text.length >= 10) {
                              _validateMeterNumber(_meterController.text.trim());
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _onContinue() {
    final meter = _meterController.text.trim();
    final amtText = _amountController.text.trim();
    final amount = double.tryParse(amtText) ?? 0;

    if (meter.length < 10) {
      AppOverlays.showToast(
        context: context,
        title: "Invalid Meter Number",
        message: "Please enter a valid 10 to 13-digit meter number",
        toastType: ToastificationType.warning,
      );
      return;
    }

    if (amount <= 0) {
      AppOverlays.showToast(
        context: context,
        title: "Invalid Amount",
        message: "Please enter or select a valid recharge amount",
        toastType: ToastificationType.warning,
      );
      return;
    }

    // Save details to Riverpod ViewModel
    ref.read(electricityVm).setTransactionDetails(
          disco: _selectedDiscoName,
          meterNumber: meter,
          amount: amtText,
          customerName: _verifiedCustomerName,
          address: _verifiedAddress,
          type: _isPrepaid ? ElectricityType.prepaid : ElectricityType.postpaid,
        );

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

  double get _estimatedUnitsKwh {
    final amt = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amt <= 0) return 0.0;
    // Standard Band A commercial/residential NERC tariff ~ ₦225 / kWh
    return amt / 225.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0D0C0A) : const Color(0xFFFAF7F2);
    final cardColor = isDark ? const Color(0xFF181714) : Colors.white;
    final inputBg = isDark ? const Color(0xFF221F18) : const Color(0xFFF2ECE1);
    final buttonBg = isDark ? const Color(0xFF1E1D1A) : const Color(0xFFEDE4D4);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E1A14);
    const primaryGold = Color(0xFFE5A93C);

    final currentAmount = int.tryParse(_amountController.text.trim()) ?? 0;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                color: buttonBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: textPrimary,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          "Electricity Tokens",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: const [
          BalanceWidget(),
        ],
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Grid Liveness Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFE5A93C).withValues(alpha: 0.15),
                            const Color(0xFF1E1D1A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primaryGold.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryGold.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.bolt_rounded, color: primaryGold, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF2ED573),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "NERC National Grid: Online",
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Instant 20-digit STS meter token generation for all 11 DisCos.",
                                  style: GoogleFonts.inter(fontSize: 11, color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Meter Type Toggle: Prepaid Token vs Postpaid Bill
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isPrepaid = true),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _isPrepaid ? primaryGold : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.flash_on_rounded,
                                      size: 16,
                                      color: _isPrepaid ? Colors.black : Colors.white70,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Prepaid (Token)",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: _isPrepaid ? FontWeight.w700 : FontWeight.w500,
                                        color: _isPrepaid ? Colors.black : Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isPrepaid = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !_isPrepaid ? primaryGold : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.receipt_long_rounded,
                                      size: 16,
                                      color: !_isPrepaid ? Colors.black : Colors.white70,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Postpaid (Bill)",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: !_isPrepaid ? FontWeight.w700 : FontWeight.w500,
                                        color: !_isPrepaid ? Colors.black : Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // DisCo Selector Card
                    Text(
                      "Electricity Distribution Company",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _openDiscoPicker,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _selectedDiscoColor.withValues(alpha: 0.15),
                                border: Border.all(color: _selectedDiscoColor.withValues(alpha: 0.4)),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.bolt_rounded, color: primaryGold, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedDiscoName,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    _selectedDiscoCoverage,
                                    style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Meter Number Card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Meter Number (${_isPrepaid ? 'Prepaid STS' : 'Postpaid Account'})",
                          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: _pasteMeterNumber,
                          child: Text(
                            "PASTE",
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: primaryGold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _isMeterVerified ? const Color(0xFF2ED573) : Colors.white12,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _meterController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(13),
                              ],
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Enter 10-13 digit meter number",
                                hintStyle: TextStyle(color: Colors.white24, letterSpacing: 1.2),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_isValidatingMeter)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: primaryGold),
                            )
                          else if (_isMeterVerified)
                            const Icon(Icons.verified_rounded, color: Color(0xFF2ED573), size: 20),
                        ],
                      ),
                    ),

                    // Real-time Verified NERC Customer Badge
                    if (_isMeterVerified) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2ED573).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2ED573).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.verified_user_rounded, color: Color(0xFF2ED573), size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _verifiedCustomerName,
                                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _verifiedAddress,
                                    style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    _verifiedTariffBand,
                                    style: GoogleFonts.inter(fontSize: 10.5, fontWeight: FontWeight.w600, color: const Color(0xFF2ED573)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // Saved Beneficiaries Quick Select
                    Text(
                      "Saved Meter Beneficiaries",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: _savedMeters.map((m) {
                          final isSelected = _meterController.text == m["meter"];
                          return GestureDetector(
                            onTap: () {
                              _meterController.text = m["meter"]!;
                              setState(() {
                                _selectedDiscoName = m["disco"]!;
                                _isPrepaid = m["type"] == "Prepaid";
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryGold.withValues(alpha: 0.2)
                                    : cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? primaryGold : Colors.white10,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.home_work_rounded,
                                    size: 14,
                                    color: isSelected ? primaryGold : Colors.white54,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${m["label"]} • ${m["meter"]!.substring(0, 5)}...",
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? primaryGold : Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Amount Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recharge Amount",
                          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                        ),
                        if (_isPrepaid && _estimatedUnitsKwh > 0)
                          Flexible(
                            child: Text(
                              "Est. Units: ~${_estimatedUnitsKwh.toStringAsFixed(1)} kWh",
                              style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w700, color: primaryGold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Custom Amount Field
                    Container(
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Row(
                        children: [
                          Text(
                            "₦",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: primaryGold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                hintText: "0",
                                hintStyle: TextStyle(color: Colors.white24),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "NGN",
                              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 6-pack Preset Amounts Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 2.2,
                      ),
                      itemCount: _presetAmounts.length,
                      itemBuilder: (context, i) {
                        final amt = _presetAmounts[i];
                        final isSelected = currentAmount == amt;
                        final formatted = NumberFormat('#,###').format(amt);
                        return InkWell(
                          onTap: () => _onSelectPreset(amt),
                          borderRadius: BorderRadius.circular(10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: isSelected ? primaryGold : cardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? primaryGold : Colors.white10,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "₦$formatted",
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.black : Colors.white70,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Continue Button Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isPrepaid ? "Buy Electricity Token" : "Pay Postpaid Bill",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
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
