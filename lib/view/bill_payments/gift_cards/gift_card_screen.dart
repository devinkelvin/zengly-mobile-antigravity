import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';
import 'gift_card_vm.dart';

class GiftCardScreen extends ConsumerStatefulWidget {
  const GiftCardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends ConsumerState<GiftCardScreen> {
  String _selectedCountry = "United States (USD)";
  String _currencySymbol = "\$";
  double _exchangeRate = 1520.0;
  String _selectedBrand = "Apple & iTunes";
  int _selectedDenomination = 50;
  int _quantity = 1;

  final List<Map<String, dynamic>> _brands = [
    {"name": "Apple & iTunes", "icon": Icons.apple, "color": Colors.grey},
    {"name": "Amazon", "icon": Icons.shopping_bag_rounded, "color": Color(0xFFFF9900)},
    {"name": "Steam", "icon": Icons.sports_esports_rounded, "color": Color(0xFF171A21)},
    {"name": "Google Play", "icon": Icons.play_arrow_rounded, "color": Color(0xFF0086F8)},
    {"name": "PlayStation", "icon": Icons.gamepad_rounded, "color": Color(0xFF003791)},
    {"name": "Xbox", "icon": Icons.videogame_asset_rounded, "color": Color(0xFF107C10)},
  ];

  final List<int> _denominations = [25, 50, 100, 200, 500];

  double get _totalNaira => _selectedDenomination * _quantity * _exchangeRate;

  void _showPurchaseConfirmation() async {
    final pin = await TransactionPinBottomSheet.show(
      context,
      title: "Authorize Gift Card Purchase",
      amountSummary: "₦${NumberFormat('#,##0.00').format(_totalNaira)} • $_selectedBrand",
    );
    if (pin == null || !mounted) return;

    AppOverlays.showLoadingDialog(context: context);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    context.pop(); // close loader

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final generatedCode = "ZG-${_selectedBrand.substring(0, 3).toUpperCase()}-9482-1049-5512";

    if (!mounted) return;
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
                child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 34),
              ),
              const SizedBox(height: 16),
              Text(
                "Gift Card Purchased!",
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1E1A14),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "$_quantity x $_selectedBrand ($_currencySymbol$_selectedDenomination)",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              // Code Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262017) : const Color(0xFFF7F2E7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      "DIGITAL REDEEM CODE",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      generatedCode,
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: const Text("Copy Code"),
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: generatedCode));
                        AppOverlays.showToast(
                          context: context,
                          title: "Code Copied",
                          message: "Redemption code copied to clipboard",
                        );
                      },
                    ),
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

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
          "Buy Gift Cards",
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

            // Country Selector Dropdown
            Text(
              "Card Region / Currency",
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
                  value: _selectedCountry,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: [
                    "United States (USD)",
                    "United Kingdom (GBP)",
                    "Canada (CAD)",
                    "Europe (EUR)",
                  ].map((c) {
                    return DropdownMenuItem<String>(
                      value: c,
                      child: Text(
                        c,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCountry = val;
                        if (val.contains("GBP")) {
                          _currencySymbol = "£";
                          _exchangeRate = 1950.0;
                        } else if (val.contains("EUR")) {
                          _currencySymbol = "€";
                          _exchangeRate = 1680.0;
                        } else if (val.contains("CAD")) {
                          _currencySymbol = "CA\$";
                          _exchangeRate = 1140.0;
                        } else {
                          _currencySymbol = "\$";
                          _exchangeRate = 1520.0;
                        }
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Live Rate Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up_rounded, size: 16, color: primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    "Current Rate: 1 ${_currencySymbol == '\$' ? 'USD' : _currencySymbol} = ₦${NumberFormat('#,##0').format(_exchangeRate)}",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Select Brand Grid
            Text(
              "Select Gift Card Brand",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1,
              ),
              itemCount: _brands.length,
              itemBuilder: (context, idx) {
                final b = _brands[idx];
                final isSelected = b["name"] == _selectedBrand;
                return GestureDetector(
                  onTap: () => setState(() => _selectedBrand = b["name"] as String),
                  child: Container(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          b["icon"] as IconData,
                          size: 26,
                          color: isSelected ? primaryColor : (b["color"] as Color),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          b["name"] as String,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? primaryColor
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Denomination Selector Chips
            Text(
              "Select Card Amount",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _denominations.map((val) {
                final isSelected = val == _selectedDenomination;
                return ChoiceChip(
                  label: Text("$_currencySymbol$val"),
                  selected: isSelected,
                  selectedColor: primaryColor,
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                  labelStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(
                      color: isSelected
                          ? primaryColor
                          : (isDark ? Colors.white12 : const Color(0xFFE2D6C5)),
                    ),
                  ),
                  onSelected: (_) => setState(() => _selectedDenomination = val),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Quantity selector & Total Cost Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quantity",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline_rounded),
                            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                          ),
                          Text(
                            "$_quantity",
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded),
                            onPressed: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount to Pay",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        "₦${NumberFormat('#,##0.00').format(_totalNaira)}",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Purchase Button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: _showPurchaseConfirmation,
                actionText: "Buy Now (₦${NumberFormat('#,##0').format(_totalNaira)})",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
