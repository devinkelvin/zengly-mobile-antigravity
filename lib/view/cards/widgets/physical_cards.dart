import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../cards_vm.dart';
import '../screens/card_details_screen.dart';
import 'zengly_card.dart';

class PhysicalCards extends ConsumerWidget {
  const PhysicalCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsState = ref.watch(cardsProvider);
    final physicalCards = cardsState.cards.where((c) => c.isPhysical).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (physicalCards.isNotEmpty) {
      final card = physicalCards.first;

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            ZenglyCard(
              card: card,
              showSensitiveDetails: cardsState.showSensitiveDetails,
              onToggleSensitive: () {
                ref.read(cardsProvider.notifier).toggleSensitiveDetails();
              },
            ),
            const SizedBox(height: 16),

            // Card Status Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2E7D32).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Physical Debit Card is active with NFC Contactless payments enabled.",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "PHYSICAL CARD MANAGEMENT",
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: const Color(0xFFB57510),
              ),
            ),
            const SizedBox(height: 12),

            _buildActionTile(
              context: context,
              icon: Icons.pin_rounded,
              title: "Change Card PIN",
              subtitle: "Update your 4-digit ATM / POS security PIN",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("PIN change OTP sent to your registered phone number"),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            _buildActionTile(
              context: context,
              icon: card.isFrozen ? Icons.lock_open_rounded : Icons.ac_unit_rounded,
              title: card.isFrozen ? "Unfreeze Physical Card" : "Freeze Physical Card",
              subtitle: "Instantly disable POS, ATM, and swipe transactions",
              onTap: () {
                HapticFeedback.mediumImpact();
                ref.read(cardsProvider.notifier).toggleCardFrozen(card.id);
              },
            ),
            _buildActionTile(
              context: context,
              icon: Icons.receipt_long_rounded,
              title: "Card & Billing Details",
              subtitle: "View full PAN, limits, and verified billing address",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CardDetailsScreen(cardId: card.id),
                  ),
                );
              },
            ),
            _buildActionTile(
              context: context,
              icon: Icons.report_problem_outlined,
              title: "Report Lost or Stolen",
              subtitle: "Block card immediately and request a replacement",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Block Physical Card?"),
                    content: const Text(
                      "This will permanently block your current card and initiate a new card delivery to your address.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Card blocked. Replacement order initiated."),
                            ),
                          );
                        },
                        child: const Text("Block & Replace", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    }

    // If no physical card yet
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Illustration / Icon container
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFB57510).withOpacity(0.12),
            ),
            child: const Icon(
              Icons.credit_card_rounded,
              color: Color(0xFFB57510),
              size: 46,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "Get Your Zengly Debit Card",
            style: GoogleFonts.raleway(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Spend seamlessly at 40M+ merchants worldwide and withdraw cash at any ATM globally.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Key Benefits List
          _buildBenefitItem(
            context,
            Icons.contactless_rounded,
            "Tap & Pay NFC Contactless",
            "Speed through checkouts with secure contactless technology",
          ),
          _buildBenefitItem(
            context,
            Icons.atm_rounded,
            "Zero Foreign ATM Markup",
            "Standard bank rates on cash withdrawals worldwide",
          ),
          _buildBenefitItem(
            context,
            Icons.notifications_active_outlined,
            "Real-Time Instant Alerts",
            "Immediate push notification for every swipe, tap, or online charge",
          ),
          _buildBenefitItem(
            context,
            Icons.shield_outlined,
            "Bank-Grade Security",
            "Freeze or unfreeze your physical card in a single tap",
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              actionText: "Request Physical Card (₦3,500)",
              onPressed: () {
                context.pushNamed(AppRouter.selectCardType);
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFB57510).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFB57510), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    IconData icon,
    String title,
    String desc,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFB57510).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFB57510), size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
