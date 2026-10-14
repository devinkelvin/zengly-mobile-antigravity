import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  final _phoneController = TextEditingController(text: "08031234567");
  final _amountController = TextEditingController(text: "5000");
  final _sharePinController = TextEditingController(text: "1234");
  bool _obscurePin = true;

  final List<int> _quickAmounts = [1000, 2000, 5000, 10000, 20000];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    _sharePinController.dispose();
    super.dispose();
  }

  void _showUssdHelp(String network) {
    String dialCode = "*321#";
    if (network == "AIRTEL") dialCode = "*432#";
    if (network == "GLO") dialCode = "*131#";
    if (network == "9MOBILE") dialCode = "*223#";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF221D17)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.info_outline_rounded,
                color: Color(0xFFB57510), size: 22),
            const SizedBox(width: 8),
            Text(
              "$network Share PIN",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "To transfer airtime, your network requires a 4-digit transfer PIN.",
              style: GoogleFonts.inter(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFB57510).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.dialpad_rounded,
                      color: Color(0xFFB57510), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Dial $dialCode on your phone to create or reset your transfer PIN.",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFB57510),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Got it",
                style: TextStyle(
                    color: Color(0xFFB57510), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = ref.watch(airtimeToCashVm);
    final rawAmount = _amountController.text.replaceAll(',', '');
    final receivable = vm.receivableAmount(rawAmount);
    final fee = vm.feeAmount(rawAmount);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        title: Text(
          "Airtime to Cash",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        actions: [const BalanceWidget()],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              "Convert your excess mobile airtime directly to cash into your Zengly wallet balance.",
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            // Network Selector with Rate Badges
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.1,
              ),
              itemCount: vm.networks.length,
              itemBuilder: (context, index) {
                final network = vm.networks[index];
                final isSelected = network.name == vm.selectedNetwork.name;
                final rate = vm.getRateFor(network.name);
                final ratePct = (rate * 100).toInt();

                return GestureDetector(
                  onTap: () => vm.selectNetwork(network),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFB57510).withValues(alpha: 0.15)
                          : (isDark ? const Color(0xFF221D17) : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFB57510)
                            : (isDark
                                ? Colors.white10
                                : const Color(0xFFE2D6C5)),
                        width: isSelected ? 1.8 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFB57510)
                                    .withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            network.image,
                            height: 32,
                            width: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.cell_tower_rounded,
                              size: 26,
                              color: Color(0xFFB57510),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                network.name,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                "$ratePct% Return",
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFB57510),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFB57510),
                            ),
                            child: const Icon(Icons.check,
                                size: 12, color: Colors.white),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 18),

            // Phone Number Input
            AppTextField(
              controller: _phoneController,
              labelText: "${vm.selectedNetwork.name} Phone Number",
              keyboardType: TextInputType.phone,
              icon: AppImages.accountCircle,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                PhoneNumberFormatter(),
              ],
            ),

            const SizedBox(height: 16),

            // Airtime Amount Input
            AppTextField(
              controller: _amountController,
              labelText: "Airtime Amount to Send (₦)",
              keyboardType: const TextInputType.numberWithOptions(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsFormatter(),
              ],
            ),

            const SizedBox(height: 10),

            // Quick Amount Pills
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
                  backgroundColor: isDark
                      ? const Color(0xFF221D17)
                      : const Color(0xFFEDE5D5),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 11.5,
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

            const SizedBox(height: 16),

            // Live Conversion Breakdown Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF221D17) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE5DEC8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Airtime Amount",
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      Text(
                        "₦${NumberFormat("#,##0.00").format(double.tryParse(rawAmount) ?? 0)}",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Carrier Processing Fee (${((1.0 - vm.currentRate) * 100).toInt()}%)",
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      Text(
                        "-₦${NumberFormat("#,##0.00").format(fee)}",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFD9480F),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: isDark ? Colors.white10 : const Color(0xFFEDE4D4),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_rounded,
                            size: 18,
                            color: Color(0xFFB57510),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Wallet Cash to Receive",
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "₦${NumberFormat("#,##0.00").format(receivable)}",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFB57510),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Share PIN Field with Guide Button
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF221D17) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE2D6C5),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sharePinController,
                      obscureText: _obscurePin,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText:
                            "${vm.selectedNetwork.name} Share & Transfer PIN",
                        labelStyle: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                        hintText: "••••",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        setState(() => _obscurePin = !_obscurePin),
                    icon: Icon(
                      _obscurePin
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 20,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showUssdHelp(vm.selectedNetwork.name),
                    icon: const Icon(
                      Icons.help_outline_rounded,
                      size: 20,
                      color: Color(0xFFB57510),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () => vm.startConversion(
                  context: context,
                  phone: _phoneController.text.replaceAll('-', ''),
                  amount: _amountController.text,
                  sharePin: _sharePinController.text,
                ),
                actionText: "Convert Airtime to Cash",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
