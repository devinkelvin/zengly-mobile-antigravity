import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'widgets/top_sprayers_section.dart';
import 'widgets/vaniti_host_event_sheet.dart';
import 'widgets/vaniti_leaderboard_sheet.dart';

class PreSpecialFeaturesScreen extends ConsumerWidget {
  const PreSpecialFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            : null,
        title: Text(
          "Vaniti",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        actions: [
          const BalanceWidget(),
          IconButton(
            onPressed: () => AppOverlays.vanitiIntroDialog(
              context: context,
              onProceed: () => context.pushNamed(AppRouter.sprayCash),
            ),
            icon: Icon(
              Icons.help_outline_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 22,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card 1: Spray Money (Deep Indigo Luxury Gradient)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E2478), Color(0xFF191448)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E2478).withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1.2,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Opacity(
                      opacity: 0.9,
                      child: Image.asset(
                        AppImages.money,
                        height: 145,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 120, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("🎉", style: TextStyle(fontSize: 11)),
                              const SizedBox(width: 4),
                              Text(
                                "LIVE CELEBRATION",
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Make It Rain, Digitally",
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Celebrate real moments by spraying money live with QR, NFC, or username with customized currency styles.",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            height: 1.4,
                            color: Colors.white.withValues(alpha: 0.82),
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppButton.compact(
                          onPressed: () => context.pushNamed(AppRouter.sprayCash),
                          actionText: "Start Spraying",
                          icon: Icons.celebration_rounded,
                          backgroundColor: const Color(0xFFFFB300),
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card 2: Host An Event (Golden Champagne Card with Vault Safe)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFDEAC4), Color(0xFFECC272)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFECC272).withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFFB57510).withValues(alpha: 0.3),
                  width: 1.2,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -5,
                    bottom: -5,
                    child: Image.asset(
                      AppImages.vaultSafe,
                      height: 145,
                      width: 145,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 125, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5A4416).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("👑", style: TextStyle(fontSize: 11)),
                              const SizedBox(width: 4),
                              Text(
                                "VIP EVENT HOSTING",
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: const Color(0xFF47340D),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Own the Moment",
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            height: 1.2,
                            color: const Color(0xFF221706),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Create your event, generate your unique QR code, invite guests to spray you, and track cash gifts live.",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            height: 1.4,
                            color: const Color(0xFF4A3815),
                          ),
                        ),
                        const SizedBox(height: 18),
                        AppButton.compact(
                          onPressed: () => VanitiHostEventSheet.show(context),
                          actionText: "Host My Event",
                          icon: Icons.qr_code_2_rounded,
                          backgroundColor: const Color(0xFF1E1810),
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Top Sprayers Section
            TopSprayersSection(onSeeMore: () => VanitiLeaderboardSheet.show(context)),
            const SizedBox(height: 12),

            // See More Sprayers standardized button
            SizedBox(
              width: double.infinity,
              child: AppButton.secondary(
                onPressed: () => VanitiLeaderboardSheet.show(context),
                actionText: "See Live Leaderboard",
                icon: Icons.leaderboard_rounded,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
