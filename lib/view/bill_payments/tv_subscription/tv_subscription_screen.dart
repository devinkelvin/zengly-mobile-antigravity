import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import '../../../widgets/widgets.dart';

class TvSubscriptionScreen extends ConsumerStatefulWidget {
  const TvSubscriptionScreen({super.key});

  @override
  ConsumerState<TvSubscriptionScreen> createState() =>
      _TvSubscriptionScreenState();
}

class _TvSubscriptionScreenState extends ConsumerState<TvSubscriptionScreen> {
  final _smartNumberController = TextEditingController(text: "7029184510");
  String _selectedProviderName = "DStv";
  String _selectedPackageName = "DStv Compact";
  int _selectedPackagePrice = 15700;
  String _selectedDuration = "1 Month";
  int _durationMultiplier = 1;
  bool _autoRenew = false;

  bool _isValidatingSmartcard = false;
  bool _isSmartcardVerified = true;
  String _verifiedCustomerName = "KELVIN EKUHOHO";
  String _verifiedCurrentBouquet = "DStv Compact (Active until 18 Nov)";

  final List<Map<String, dynamic>> _providers = [
    {
      "name": "DStv",
      "logo": Icons.tv_rounded,
      "color": Color(0xFF005DAA),
      "tagline": "MultiChoice Premium Digital TV",
    },
    {
      "name": "GOtv",
      "logo": Icons.live_tv_rounded,
      "color": Color(0xFF00A859),
      "tagline": "Affordable Family Digital Terrestrial",
    },
    {
      "name": "StarTimes",
      "logo": Icons.connected_tv_rounded,
      "color": Color(0xFFFF6600),
      "tagline": "Direct-to-Home & Terrestrial TV",
    },
    {
      "name": "Showmax",
      "logo": Icons.movie_filter_rounded,
      "color": Color(0xFF9900CC),
      "tagline": "Live Sports & Video-on-Demand",
    },
  ];

  final Map<String, List<Map<String, dynamic>>> _packageDetails = {
    "DStv": [
      {
        "name": "DStv Premium",
        "price": 37000,
        "channels": "165+ Channels",
        "badge": "VIP • All Channels & UCL",
      },
      {
        "name": "DStv Compact Plus",
        "price": 25000,
        "channels": "145+ Channels",
        "badge": "Premier League & Serie A",
      },
      {
        "name": "DStv Compact",
        "price": 15700,
        "channels": "130+ Channels",
        "badge": "POPULAR • Sports & Movies",
      },
      {
        "name": "DStv Confam",
        "price": 9300,
        "channels": "105+ Channels",
        "badge": "Family Entertainment",
      },
      {
        "name": "DStv Yanga",
        "price": 5100,
        "channels": "85+ Channels",
        "badge": "Budget Friendly",
      },
      {
        "name": "DStv Padi",
        "price": 3600,
        "channels": "45+ Channels",
        "badge": "Entry Tier",
      },
    ],
    "GOtv": [
      {
        "name": "GOtv Supa Plus",
        "price": 15700,
        "channels": "80+ Channels",
        "badge": "EPL & All SuperSport",
      },
      {
        "name": "GOtv Supa",
        "price": 9600,
        "channels": "70+ Channels",
        "badge": "Expanded Family Tier",
      },
      {
        "name": "GOtv Max",
        "price": 7200,
        "channels": "60+ Channels",
        "badge": "Sports & Drama",
      },
      {
        "name": "GOtv Jolli",
        "price": 4850,
        "channels": "50+ Channels",
        "badge": "Local Entertainment",
      },
      {
        "name": "GOtv Jinja",
        "price": 3300,
        "channels": "35+ Channels",
        "badge": "Starter Tier",
      },
    ],
    "StarTimes": [
      {
        "name": "StarTimes Super",
        "price": 7500,
        "channels": "100+ Channels",
        "badge": "Full Sports & Series",
      },
      {
        "name": "StarTimes Classic",
        "price": 4500,
        "channels": "75+ Channels",
        "badge": "POPULAR",
      },
      {
        "name": "StarTimes Basic",
        "price": 3300,
        "channels": "50+ Channels",
        "badge": "Daily News & Family",
      },
      {
        "name": "StarTimes Nova",
        "price": 1700,
        "channels": "30+ Channels",
        "badge": "Basic Channels",
      },
    ],
    "Showmax": [
      {
        "name": "Showmax Premier League",
        "price": 2900,
        "channels": "Live Mobile Stream",
        "badge": "Every Premier League Game Live",
      },
      {
        "name": "Showmax Entertainment",
        "price": 2900,
        "channels": "All Devices (2 Screens)",
        "badge": "HBO, Originals & Kids",
      },
      {
        "name": "Showmax Pro Mobile",
        "price": 3200,
        "channels": "Live Sports + Stream",
        "badge": "Full Sports Mobile",
      },
    ],
  };

  final List<Map<String, dynamic>> _durations = [
    {"label": "1 Month", "multiplier": 1, "discount": ""},
    {"label": "3 Months", "multiplier": 3, "discount": "2% Off"},
    {"label": "6 Months", "multiplier": 6, "discount": "5% Off"},
    {"label": "1 Year", "multiplier": 12, "discount": "10% Off"},
  ];

  @override
  void initState() {
    super.initState();
    _smartNumberController.addListener(_onSmartcardChanged);
  }

  @override
  void dispose() {
    _smartNumberController.removeListener(_onSmartcardChanged);
    _smartNumberController.dispose();
    super.dispose();
  }

  void _onSmartcardChanged() {
    final clean = _smartNumberController.text.trim();
    if (clean.length >= 10 && clean.length <= 11) {
      _validateSmartcard(clean);
    } else {
      if (_isSmartcardVerified) {
        setState(() => _isSmartcardVerified = false);
      }
    }
  }

  Future<void> _validateSmartcard(String smartcard) async {
    setState(() {
      _isValidatingSmartcard = true;
      _isSmartcardVerified = false;
    });

    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;

    setState(() {
      _isValidatingSmartcard = false;
      _isSmartcardVerified = true;
      _verifiedCustomerName = "KELVIN EKUHOHO";
      _verifiedCurrentBouquet = "$_selectedProviderName Active • Expiry: 18 Nov";
    });
  }

  int get _calculatedTotal {
    double base = (_selectedPackagePrice * _durationMultiplier).toDouble();
    if (_durationMultiplier == 3) base *= 0.98;
    if (_durationMultiplier == 6) base *= 0.95;
    if (_durationMultiplier == 12) base *= 0.90;
    return base.toInt();
  }

  void _showSuccessReceipt() {
    final cleanPrice = NumberFormat('#,###').format(_calculatedTotal);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16140F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
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
                  color: Color(0xFF2ED573),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.black, size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                "Subscription Activated!",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "$_selectedPackageName ($_selectedDuration) successfully activated",
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1D19),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    _receiptRow("Provider", _selectedProviderName),
                    _receiptRow("Customer", _verifiedCustomerName),
                    _receiptRow("IUC / Smartcard", _smartNumberController.text),
                    _receiptRow("Package", _selectedPackageName),
                    _receiptRow("Duration", _selectedDuration),
                    _receiptRow("Total Paid", "₦$cleanPrice", isHighlight: true),
                    _receiptRow("Status", "Instant Active", isStatus: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE5A93C),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.pop();
                  },
                  child: Text(
                    "Done",
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _receiptRow(String label, String value, {bool isStatus = false, bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 12.5, color: Colors.white54)),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isStatus
                  ? const Color(0xFF2ED573)
                  : (isHighlight ? const Color(0xFFE5A93C) : Colors.white),
            ),
          ),
        ],
      ),
    );
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

    final currentPackages = _packageDetails[_selectedProviderName] ?? [];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => context.pop(),
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
          "TV & Cable Subscription",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
        actions: const [BalanceWidget()],
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
                    // Provider Selector Grid
                    Text(
                      "Select Service Provider",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: _providers.map((p) {
                        final isSelected = p["name"] == _selectedProviderName;
                        final color = p["color"] as Color;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedProviderName = p["name"];
                                final pkgs = _packageDetails[p["name"]]!;
                                _selectedPackageName = pkgs.first["name"];
                                _selectedPackagePrice = pkgs.first["price"];
                              });
                              if (_smartNumberController.text.length >= 10) {
                                _validateSmartcard(_smartNumberController.text.trim());
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryGold.withValues(alpha: 0.18)
                                    : cardColor,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? primaryGold : Colors.white10,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    p["logo"] as IconData,
                                    color: isSelected ? primaryGold : color,
                                    size: 22,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    p["name"] as String,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: isSelected ? primaryGold : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 18),

                    // Smartcard Number Card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Smartcard / IUC Number",
                          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final data = await Clipboard.getData(Clipboard.kTextPlain);
                            if (data != null && data.text != null) {
                              _smartNumberController.text = data.text!.replaceAll(RegExp(r'[^0-9]'), '');
                            }
                          },
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
                          color: _isSmartcardVerified ? const Color(0xFF2ED573) : Colors.white12,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _smartNumberController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                              ],
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Enter 10-11 digit smartcard/IUC",
                                hintStyle: TextStyle(color: Colors.white24, letterSpacing: 1.2),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_isValidatingSmartcard)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: primaryGold),
                            )
                          else if (_isSmartcardVerified)
                            const Icon(Icons.verified_rounded, color: Color(0xFF2ED573), size: 20),
                        ],
                      ),
                    ),

                    // Smartcard Verification Result
                    if (_isSmartcardVerified) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2ED573).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2ED573).withValues(alpha: 0.3)),
                        ),
                        child: Row(
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
                                  Text(
                                    "$_selectedProviderName • $_verifiedCurrentBouquet",
                                    style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF2ED573)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),

                    // Bouquet / Package Selector
                    Text(
                      "Select Bouquet / Package Tier",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentPackages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final pkg = currentPackages[i];
                        final name = pkg["name"] as String;
                        final price = pkg["price"] as int;
                        final channels = pkg["channels"] as String;
                        final badge = pkg["badge"] as String;
                        final isSelected = name == _selectedPackageName;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPackageName = name;
                              _selectedPackagePrice = price;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryGold.withValues(alpha: 0.15)
                                  : cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? primaryGold : Colors.white10,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? primaryGold : Colors.white38,
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: isSelected
                                      ? Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: primaryGold,
                                            shape: BoxShape.circle,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              name,
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.white10,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              channels,
                                              style: GoogleFonts.inter(fontSize: 10, color: Colors.white70),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        badge,
                                        style: GoogleFonts.inter(fontSize: 11, color: isSelected ? primaryGold : Colors.white54),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "₦${NumberFormat('#,###').format(price)}",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected ? primaryGold : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 18),

                    // Subscription Duration Selector
                    Text(
                      "Subscription Tenure",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: _durations.map((d) {
                        final isSelected = d["label"] == _selectedDuration;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDuration = d["label"];
                                _durationMultiplier = d["multiplier"] as int;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryGold : cardColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: isSelected ? primaryGold : Colors.white10),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    d["label"] as String,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? Colors.black : Colors.white70,
                                    ),
                                  ),
                                  if ((d["discount"] as String).isNotEmpty)
                                    Text(
                                      d["discount"] as String,
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? Colors.black87 : const Color(0xFF2ED573),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Auto Renew Option
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Auto-Renew Subscription",
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Never miss a match or episode when active period ends",
                                  style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: _autoRenew,
                            onChanged: (val) => setState(() => _autoRenew = val),
                            activeThumbColor: primaryGold,
                            activeTrackColor: primaryGold.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Payment Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Total Amount",
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
                      ),
                      Text(
                        "₦${NumberFormat('#,###').format(_calculatedTotal)}",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: primaryGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGold,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
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
                            amountSummary: "₦${NumberFormat('#,###').format(_calculatedTotal)} • $_selectedPackageName",
                          );
                          if (pin == null || !context.mounted) return;

                          AppOverlays.showLoadingDialog(context: context);
                          await Future.delayed(const Duration(milliseconds: 1400));
                          if (!context.mounted) return;
                          context.pop(); // close loader

                          _showSuccessReceipt();
                        },
                        child: Text(
                          "Renew Bouquet",
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
