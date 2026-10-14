import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';
import 'tv_subscription_vm.dart';

class TvSubscriptionScreen extends ConsumerStatefulWidget {
  const TvSubscriptionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TvSubscriptionScreenState();
}

class _TvSubscriptionScreenState extends ConsumerState<TvSubscriptionScreen> {
  final _smartNumberController = TextEditingController();
  String _selectedProviderName = "DStv";
  String _selectedPackage = "DStv Compact - ₦15,700/mo";
  bool _autoRenew = false;

  final List<Map<String, dynamic>> _providers = [
    {"name": "DStv", "logo": Icons.tv_rounded, "color": Color(0xFF005DAA)},
    {"name": "GOtv", "logo": Icons.live_tv_rounded, "color": Color(0xFF00A859)},
    {"name": "StarTimes", "logo": Icons.connected_tv_rounded, "color": Color(0xFFFF6600)},
    {"name": "Showmax", "logo": Icons.movie_filter_rounded, "color": Color(0xFF9900CC)},
  ];

  final Map<String, List<String>> _packages = {
    "DStv": [
      "DStv Compact - ₦15,700/mo",
      "DStv Premium - ₦37,000/mo",
      "DStv Confam - ₦9,300/mo",
      "DStv Yanga - ₦5,100/mo",
      "DStv Padi - ₦3,600/mo",
    ],
    "GOtv": [
      "GOtv Supa Plus - ₦15,700/mo",
      "GOtv Supa - ₦9,600/mo",
      "GOtv Max - ₦7,200/mo",
      "GOtv Jolli - ₦4,850/mo",
      "GOtv Jinja - ₦3,300/mo",
    ],
    "StarTimes": [
      "StarTimes Super - ₦7,500/mo",
      "StarTimes Classic - ₦4,500/mo",
      "StarTimes Basic - ₦3,300/mo",
      "StarTimes Nova - ₦1,700/mo",
    ],
    "Showmax": [
      "Showmax Pro Mobile - ₦3,200/mo",
      "Showmax Entertainment - ₦2,900/mo",
      "Showmax Premier League - ₦2,900/mo",
    ],
  };

  @override
  void initState() {
    super.initState();
    _smartNumberController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _smartNumberController.dispose();
    super.dispose();
  }

  void _showSuccessReceipt() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1C1813) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF34C759),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                "Subscription Activated!",
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1E1A14),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "$_selectedProviderName bouquet renewed successfully",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262017) : const Color(0xFFF7F2E7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _receiptRow("Customer", "Kelvin Ekuhoho", isDark),
                    _receiptRow("Smartcard", _smartNumberController.text, isDark),
                    _receiptRow("Package", _selectedPackage.split(" - ").first, isDark),
                    _receiptRow("Amount", _selectedPackage.split(" - ").last, isDark),
                    _receiptRow("Status", "Instant Active", isDark, isStatus: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  actionText: "Done",
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _receiptRow(String label, String value, bool isDark, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isStatus
                  ? const Color(0xFF34C759)
                  : (isDark ? Colors.white : const Color(0xFF1A1A1A)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isSmartcardValid = _smartNumberController.text.length >= 10;
    final currentPackages = _packages[_selectedProviderName] ?? [];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        title: Text(
          "TV Subscription",
          style: GoogleFonts.raleway(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: false,
        actions: const [BalanceWidget()],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Provider Selector Chips
            Text(
              "Select Service Provider",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: _providers.map((p) {
                final isSelected = p["name"] == _selectedProviderName;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedProviderName = p["name"];
                        _selectedPackage = _packages[p["name"]]!.first;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor.withValues(alpha: 0.15)
                            : Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : (isDark ? Colors.white12 : const Color(0xFFE2D6C5)),
                          width: isSelected ? 1.8 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            p["logo"] as IconData,
                            color: isSelected ? primaryColor : (p["color"] as Color),
                            size: 24,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            p["name"] as String,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? primaryColor
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Smartcard Number Field
            AppTextField(
              controller: _smartNumberController,
              labelText: "Smartcard / IUC / Account Number",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),

            if (isSmartcardValid) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262017) : const Color(0xFFF7F2E7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF34C759).withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded, color: Color(0xFF34C759), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kelvin Ekuhoho",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF1E1A14),
                            ),
                          ),
                          Text(
                            "$_selectedProviderName • Card # ${_smartNumberController.text} • Active",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Package Selector Dropdown
            Text(
              "Select Bouquet / Package",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
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
                  value: currentPackages.contains(_selectedPackage)
                      ? _selectedPackage
                      : currentPackages.first,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: currentPackages.map((pkg) {
                    return DropdownMenuItem<String>(
                      value: pkg,
                      child: Text(
                        pkg,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedPackage = val);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Auto Renew Switch
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Auto-Renew Monthly",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "Never lose signal when your bill expires",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _autoRenew,
                    onChanged: (val) => setState(() => _autoRenew = val),
                    activeThumbColor: Theme.of(context).colorScheme.onPrimary,
                    activeTrackColor: primaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () async {
                  if (_smartNumberController.text.trim().isEmpty) {
                    AppOverlays.showToast(
                      context: context,
                      message: "Please enter your smartcard or IUC number",
                      toastType: ToastificationType.error,
                    );
                    return;
                  }
                  final pin = await TransactionPinBottomSheet.show(
                    context,
                    title: "Authorize TV Subscription",
                    amountSummary: "$_selectedPackage • $_selectedProviderName",
                  );
                  if (pin == null || !context.mounted) return;

                  AppOverlays.showLoadingDialog(context: context);
                  await Future.delayed(const Duration(milliseconds: 1500));
                  if (!context.mounted) return;
                  context.pop(); // close loader

                  _showSuccessReceipt();
                },
                actionText: "Renew Subscription",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
