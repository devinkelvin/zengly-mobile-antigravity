import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';
import '../cards_vm.dart';

class CardDetailsScreen extends ConsumerStatefulWidget {
  final String cardId;
  const CardDetailsScreen({super.key, this.cardId = "card_v_01"});

  @override
  ConsumerState<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends ConsumerState<CardDetailsScreen> {
  bool _revealed = false;

  void _copy(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$label copied to clipboard"),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    required String rawCopyValue,
    bool isSensitive = false,
  }) {
    final displayValue = (isSensitive && !_revealed) ? "••••" : value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              Text(
                displayValue,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _copy(title, rawCopyValue),
                child: const Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: Color(0xFFB57510),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardsState = ref.watch(cardsProvider);
    final card = cardsState.cards.firstWhere(
      (c) => c.id == widget.cardId,
      orElse: () => cardsState.cards.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Card Details & Billing",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _revealed ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFFB57510),
            ),
            tooltip: _revealed ? "Hide details" : "Reveal details",
            onPressed: () {
              setState(() {
                _revealed = !_revealed;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimensions.viewPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Security tip banner
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFB57510).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFB57510).withOpacity(0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFFB57510),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Keep your CVV and card numbers secure. Use these credentials for online international transactions.",
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          height: 1.4,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "CARD INFORMATION",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFFB57510),
                ),
              ),
              const SizedBox(height: 10),

              _buildDetailRow(
                title: "Card Number",
                value: card.formattedPan,
                rawCopyValue: card.pan,
                isSensitive: true,
              ),
              _buildDetailRow(
                title: "Cardholder Name",
                value: card.cardHolderName,
                rawCopyValue: card.cardHolderName,
              ),
              _buildDetailRow(
                title: "Expiry Date",
                value: card.expiryDate,
                rawCopyValue: card.expiryDate,
              ),
              _buildDetailRow(
                title: "CVV / CVC",
                value: card.cvv,
                rawCopyValue: card.cvv,
                isSensitive: true,
              ),

              const SizedBox(height: 20),

              Text(
                "BILLING ADDRESS (FOR US CHECKOUTS)",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFFB57510),
                ),
              ),
              const SizedBox(height: 10),

              _buildDetailRow(
                title: "Street Address",
                value: card.billingAddress,
                rawCopyValue: card.billingAddress,
              ),
              _buildDetailRow(
                title: "City & State",
                value: card.city,
                rawCopyValue: card.city,
              ),
              _buildDetailRow(
                title: "Postal Code",
                value: card.postalCode,
                rawCopyValue: card.postalCode,
              ),
              _buildDetailRow(
                title: "Country",
                value: card.country,
                rawCopyValue: card.country,
              ),

              const SizedBox(height: 20),

              Text(
                "LIMITS & STATUS",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFFB57510),
                ),
              ),
              const SizedBox(height: 10),

              _buildDetailRow(
                title: "Card Status",
                value: card.isFrozen ? "Frozen ❄️" : "Active & Verified ✅",
                rawCopyValue: card.isFrozen ? "Frozen" : "Active",
              ),
              _buildDetailRow(
                title: "Daily Spending Limit",
                value: "\$${card.dailyLimit.toStringAsFixed(0)}",
                rawCopyValue: card.dailyLimit.toStringAsFixed(0),
              ),
              _buildDetailRow(
                title: "Spent Today",
                value: "\$${card.spentToday.toStringAsFixed(2)}",
                rawCopyValue: card.spentToday.toStringAsFixed(2),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
