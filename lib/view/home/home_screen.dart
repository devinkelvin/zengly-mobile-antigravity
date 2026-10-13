import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/data.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import '../view.dart';
import 'widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _ZenglyRewardsBanner extends StatelessWidget {
  const _ZenglyRewardsBanner();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(AppRouter.preVerification),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF593902), Color(0xFF9E6508)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF593902).withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left content column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          "Unlock your Zengly experience",
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.card_giftcard_rounded,
                          size: 13,
                          color: Color(0xFFFFD580),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Complete quick verification steps and earn exclusive rewards at every level.",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Verify now",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFFE082),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 12,
                        color: Color(0xFFFFE082),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right illustration - cleanly separated with fixed bounds
            SizedBox(
              width: 72,
              height: 72,
              child: Image.asset(
                AppImages.handHold,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(homeVm).getUserKycStatus();
      if (!mounted) return;
      if (ref.read(homeVm).showKycButton) {
        AppOverlays.kycPromptDialog(
          context: context,
          onVerify: () => context.pushNamed(AppRouter.ninScreen),
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vm = ref.watch(homeVm);
    final displayName =
        ref.watch(authNotifierProvider).valueOrNull?.displayName ??
        l10n.guestUser;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          onRefresh: () => Future.sync(() => vm.getUserKycStatus()),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppDimensions.viewPadding,
            child: Skeletonizer(
              enabled: vm.isLoading,
              child:
                  vm.hasError
                      ? AppErrorWidget(
                        message: vm.errorMessage,
                        onRetry: () => Future.sync(() => vm.getUserKycStatus()),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          // Header
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(
                                  AppImages.profilePicture,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  displayName.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const CoinWidget(),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap:
                                    () =>
                                        context.goNamed(AppRouter.notification),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                  ),
                                  padding: const EdgeInsets.all(9),
                                  child: SvgPicture.asset(AppImages.bellIcon),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Balance card
                          const AccountCard2(),
                          const SizedBox(height: 16),

                          // Action grid
                          const ActionPanel(),
                          const SizedBox(height: 16),

                          // Rewards banner
                          _ZenglyRewardsBanner(),
                          const SizedBox(height: 16),

                          // Today's Transactions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.recentTransactions,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.scrim,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.pushNamed(AppRouter.history),
                                child: Text(
                                  l10n.seeAll,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Color(0XFF009851),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Recent Transactions container
                          Builder(
                            builder: (context) {
                              final transactions = <TransactionHistoryModel>[];
                              if (transactions.isEmpty) {
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 36,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.outlineVariant,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.receipt_long_outlined,
                                            size: 26,
                                            color: Theme.of(context).colorScheme.scrim,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        "Your transactions will appear here",
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.scrim,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final isDark = Theme.of(context).brightness == Brightness.dark;
                              return Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF211D16)
                                      : Theme.of(context).colorScheme.outlineVariant,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: transactions.length,
                                  separatorBuilder: (context, index) => Divider(
                                    height: 1,
                                    thickness: 0.8,
                                    indent: 72,
                                    endIndent: 16,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.06)
                                        : Colors.black.withValues(alpha: 0.06),
                                  ),
                                  itemBuilder: (context, index) {
                                    final tx = transactions[index];
                                    return HistoryItemTile(
                                      transaction: tx,
                                      isGrouped: true,
                                      onTap: () {
                                        context.pushNamed(
                                          AppRouter.requestDetails,
                                          extra: tx,
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
