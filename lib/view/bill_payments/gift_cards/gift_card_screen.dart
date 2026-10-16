import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import '../../../widgets/widgets.dart';

class GiftCardScreen extends ConsumerStatefulWidget {
  const GiftCardScreen({super.key});

  @override
  ConsumerState<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends ConsumerState<GiftCardScreen> {
  int _activeMode = 0; // 0: Buy Digital Gift Cards, 1: Sell / Redeem to Naira Cash

  String _selectedCountry = "United States (USD)";
  String _currencySymbol = "\$";
  double _exchangeRate = 1520.0;
  String _selectedBrand = "Apple & App Store";
  int _selectedDenomination = 50;
  int _quantity = 1;

  final TextEditingController _redeemCardCodeController = TextEditingController();
  final TextEditingController _redeemCardAmountController = TextEditingController();

  final List<Map<String, dynamic>> _countries = [
    {"name": "United States (USD)", "symbol": "\$", "rate": 1520.0, "flag": "🇺🇸"},
    {"name": "United Kingdom (GBP)", "symbol": "£", "rate": 1980.0, "flag": "🇬🇧"},
    {"name": "Europe (EUR)", "symbol": "€", "rate": 1650.0, "flag": "🇪🇺"},
    {"name": "Canada (CAD)", "symbol": "C\$", "rate": 1120.0, "flag": "🇨🇦"},
    {"name": "Nigeria (NGN)", "symbol": "₦", "rate": 1.0, "flag": "🇳🇬"},
  ];

  final List<Map<String, dynamic>> _brands = [
    {
      "name": "Apple & App Store",
      "icon": Icons.apple,
      "color": Color(0xFFA2AAAD),
      "tagline": "Apps, games, music & iCloud storage",
    },
    {
      "name": "Amazon",
      "icon": Icons.shopping_bag_rounded,
      "color": Color(0xFFFF9900),
      "tagline": "Millions of global items on Amazon",
    },
    {
      "name": "Steam",
      "icon": Icons.sports_esports_rounded,
      "color": Color(0xFF171A21),
      "tagline": "PC Games, DLCs & Community market",
    },
    {
      "name": "Google Play",
      "icon": Icons.play_arrow_rounded,
      "color": Color(0xFF0086F8),
      "tagline": "Android apps, books & movies",
    },
    {
      "name": "PlayStation Store",
      "icon": Icons.gamepad_rounded,
      "color": Color(0xFF003791),
      "tagline": "PS5/PS4 games, PS Plus & Add-ons",
    },
    {
      "name": "Xbox Game Pass",
      "icon": Icons.videogame_asset_rounded,
      "color": Color(0xFF107C10),
      "tagline": "Consoles, PC Game Pass & Digital titles",
    },
    {
      "name": "Netflix",
      "icon": Icons.movie_rounded,
      "color": Color(0xFFE50914),
      "tagline": "Movies, TV series & original shows",
    },
    {
      "name": "Spotify",
      "icon": Icons.music_note_rounded,
      "color": Color(0xFF1ED760),
      "tagline": "Ad-free music & podcast streaming",
    },
    {
      "name": "Razer Gold",
      "icon": Icons.monetization_on_rounded,
      "color": Color(0xFFFFD700),
      "tagline": "In-game credits & virtual gaming currency",
    },
  ];

  final List<int> _denominations = [25, 50, 100, 200, 500];

  double get _totalNaira => _selectedDenomination * _quantity * _exchangeRate;

  @override
  void dispose() {
    _redeemCardCodeController.dispose();
    _redeemCardAmountController.dispose();
    super.dispose();
  }

  void _showPurchaseConfirmation() async {
    final formattedNaira = NumberFormat('#,##0.00').format(_totalNaira);
    final pin = await TransactionPinBottomSheet.show(
      context,
      title: "Authorize Gift Card Purchase",
      amountSummary: "₦$formattedNaira • $_selectedBrand",
    );
    if (pin == null || !mounted) return;

    AppOverlays.showLoadingDialog(context: context);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    context.pop(); // close loader

    final generatedCode = "ZG-${_selectedBrand.substring(0, 3).toUpperCase()}-9482-1049-5512";
    final pinCode = "8841-2091";

    if (!mounted) return;
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
                child: const Icon(Icons.card_giftcard_rounded, color: Colors.black, size: 34),
              ),
              const SizedBox(height: 16),
              Text(
                "Gift Card Purchased!",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "$_quantity x $_selectedBrand ($_currencySymbol$_selectedDenomination)",
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 20),

              // Digital Redeem Code Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1D19),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5A93C).withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      "DIGITAL CLAIM CODE",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE5A93C),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      generatedCode,
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "PIN: $pinCode",
                      style: GoogleFonts.sourceCodePro(fontSize: 12, color: Colors.white60),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          label: const Text("Copy Code"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE5A93C),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: "$generatedCode (PIN: $pinCode)"));
                            AppOverlays.showToast(
                              context: context,
                              title: "Code Copied",
                              message: "Redemption code copied to clipboard",
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white12,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.pop();
                  },
                  child: Text(
                    "Back to Bills Hub",
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

  void _showRedeemConfirmation() async {
    final code = _redeemCardCodeController.text.trim();
    final amtText = _redeemCardAmountController.text.trim();
    if (code.isEmpty || amtText.isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Incomplete Details",
        message: "Please input gift card code and denomination amount to redeem",
        toastType: ToastificationType.warning,
      );
      return;
    }

    AppOverlays.showLoadingDialog(context: context);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    context.pop(); // close loader

    final payoutNaira = (double.tryParse(amtText) ?? 50.0) * _exchangeRate * 0.96;

    AppOverlays.showToast(
      context: context,
      title: "Redemption Submitted",
      message: "₦${NumberFormat('#,##0.00').format(payoutNaira)} credited to your Zengly Wallet after instant automated card verification!",
      toastType: ToastificationType.success,
    );
    _redeemCardCodeController.clear();
    _redeemCardAmountController.clear();
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

    final selectedBrandData = _brands.firstWhere(
      (b) => b["name"] == _selectedBrand,
      orElse: () => _brands.first,
    );

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
          "Digital Gift Cards",
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
                    // Dual Mode Switcher: Buy Gift Cards vs Sell / Redeem Card
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
                              onTap: () => setState(() => _activeMode = 0),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _activeMode == 0 ? primaryGold : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_bag_rounded,
                                      size: 16,
                                      color: _activeMode == 0 ? Colors.black : Colors.white70,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Buy Gift Cards",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: _activeMode == 0 ? FontWeight.w700 : FontWeight.w500,
                                        color: _activeMode == 0 ? Colors.black : Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _activeMode = 1),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _activeMode == 1 ? primaryGold : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.currency_exchange_rounded,
                                      size: 16,
                                      color: _activeMode == 1 ? Colors.black : Colors.white70,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Redeem to Cash",
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: _activeMode == 1 ? FontWeight.w700 : FontWeight.w500,
                                        color: _activeMode == 1 ? Colors.black : Colors.white70,
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

                    // Country / Currency Region Selector
                    Text(
                      "Card Region / Currency",
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCountry,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1E1D1A),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54),
                          items: _countries.map((c) {
                            return DropdownMenuItem<String>(
                              value: c["name"] as String,
                              child: Row(
                                children: [
                                  Text(c["flag"] as String, style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 10),
                                  Text(
                                    c["name"] as String,
                                    style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "Rate: ₦${NumberFormat('#,###').format(c["rate"])}",
                                    style: GoogleFonts.inter(fontSize: 11.5, color: primaryGold, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              final match = _countries.firstWhere((c) => c["name"] == val);
                              setState(() {
                                _selectedCountry = val;
                                _currencySymbol = match["symbol"] as String;
                                _exchangeRate = match["rate"] as double;
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (_activeMode == 0) ...[
                      // BUY MODE: Brand Carousel
                      Text(
                        "Select Brand / Store",
                        style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      const SizedBox(height: 10),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          childAspectRatio: 1.15,
                        ),
                        itemCount: _brands.length,
                        itemBuilder: (context, i) {
                          final b = _brands[i];
                          final isSelected = b["name"] == _selectedBrand;
                          final color = b["color"] as Color;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedBrand = b["name"]),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryGold.withValues(alpha: 0.15) : cardColor,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? primaryGold : Colors.white10,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(b["icon"] as IconData, color: isSelected ? primaryGold : color, size: 24),
                                  const SizedBox(height: 6),
                                  Text(
                                    b["name"] as String,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: isSelected ? primaryGold : Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      // Selected Brand Perks Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: (selectedBrandData["color"] as Color).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: (selectedBrandData["color"] as Color).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(selectedBrandData["icon"] as IconData, size: 18, color: primaryGold),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                selectedBrandData["tagline"] as String,
                                style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white70),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFF2ED573).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
                              child: Text("Instant Token", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF2ED573))),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Denominations Grid
                      Text(
                        "Card Denomination ($_currencySymbol)",
                        style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _denominations.map((denom) {
                          final isSelected = _selectedDenomination == denom;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedDenomination = denom),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryGold : cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? primaryGold : Colors.white10),
                              ),
                              child: Text(
                                "$_currencySymbol$denom",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 18),

                      // Quantity Stepper
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Quantity",
                            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 16, color: Colors.white70),
                                  onPressed: () {
                                    if (_quantity > 1) setState(() => _quantity--);
                                  },
                                ),
                                Text(
                                  "$_quantity",
                                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16, color: Colors.white70),
                                  onPressed: () {
                                    if (_quantity < 10) setState(() => _quantity++);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // REDEEM / SELL CARD TO NAIRA
                      Text(
                        "Input Card Code to Redeem for Cash",
                        style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                        child: TextField(
                          controller: _redeemCardCodeController,
                          style: GoogleFonts.sourceCodePro(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "e.g. ZG-APP-9482-1049-5512",
                            hintStyle: TextStyle(color: Colors.white24),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "Card Face Value ($_currencySymbol)",
                        style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white70),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                        child: TextField(
                          controller: _redeemCardAmountController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "e.g. 50, 100",
                            hintStyle: const TextStyle(color: Colors.white24),
                            border: InputBorder.none,
                            prefixText: "$_currencySymbol ",
                            prefixStyle: const TextStyle(color: primaryGold, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2ED573).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF2ED573).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flash_on_rounded, color: Color(0xFF2ED573), size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Instant Automated Payout",
                                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                                  ),
                                  Text(
                                    "Your card balance will be validated and credited in Naira to your Zengly wallet in under 60 seconds.",
                                    style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
              ),
              child: Row(
                children: [
                  if (_activeMode == 0) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Total Cost ($_currencySymbol${_selectedDenomination * _quantity})",
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.white54),
                        ),
                        Text(
                          "₦${NumberFormat('#,###').format(_totalNaira)}",
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: primaryGold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                  ],
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
                        onPressed: _activeMode == 0 ? _showPurchaseConfirmation : _showRedeemConfirmation,
                        child: Text(
                          _activeMode == 0 ? "Buy Gift Card" : "Redeem to Naira Cash",
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
