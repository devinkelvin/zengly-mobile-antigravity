import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cards_vm.dart';
import '../screens/card_details_screen.dart';
import '../screens/fund_card_screen.dart';
import 'empty_cards.dart';
import 'zengly_card.dart';

class VirtualCards extends ConsumerWidget {
  const VirtualCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsState = ref.watch(cardsProvider);
    final virtualCards = cardsState.cards.where((c) => !c.isPhysical).toList();

    if (virtualCards.isEmpty) {
      return const EmptyCards(isPhysicalCards: false);
    }

    final card = virtualCards.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Luxury Zengly Virtual Card
          ZenglyCard(
            card: card,
            showSensitiveDetails: cardsState.showSensitiveDetails,
            onToggleSensitive: () {
              ref.read(cardsProvider.notifier).toggleSensitiveDetails();
            },
          ),

          const SizedBox(height: 16),

          // Primary Quick Action Buttons
          Row(
            children: [
              // Fund Card Action
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.add_circle_outline_rounded,
                  label: "Fund Card",
                  color: const Color(0xFFB57510),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FundCardScreen(cardId: card.id),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              // Freeze / Unfreeze Action
              Expanded(
                child: _QuickActionButton(
                  icon: card.isFrozen
                      ? Icons.lock_open_rounded
                      : Icons.ac_unit_rounded,
                  label: card.isFrozen ? "Unfreeze" : "Freeze",
                  color: card.isFrozen ? Colors.cyan : Colors.blueGrey,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    ref.read(cardsProvider.notifier).toggleCardFrozen(card.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          card.isFrozen
                              ? "Card unfrozen and active"
                              : "Card frozen for your protection",
                        ),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              // Card Details Action
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.receipt_long_rounded,
                  label: "Details",
                  color: isDark ? Colors.white70 : Colors.black87,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CardDetailsScreen(cardId: card.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Spending Limit Progress Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daily Limit Usage",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "\$${card.spentToday.toStringAsFixed(0)} / \$${card.dailyLimit.toStringAsFixed(0)}",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB57510),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (card.spentToday / card.dailyLimit).clamp(0.0, 1.0),
                    minHeight: 7,
                    backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB57510)),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "\$${(card.dailyLimit - card.spentToday).toStringAsFixed(2)} remaining today",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recent Online Transactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Card Transactions",
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "USD Wallet",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB57510),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...cardsState.recentTransactions.map((tx) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB57510).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Color(0xFFB57510),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.merchant,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${tx.date} • ${tx.category}",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    tx.category == "Funding"
                        ? "+\$${tx.amountUsd.toStringAsFixed(2)}"
                        : "-\$${tx.amountUsd.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: tx.category == "Funding"
                          ? const Color(0xFF2E7D32)
                          : null,
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
