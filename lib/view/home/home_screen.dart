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
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF6B4400), Color(0xFFAD7210)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 130, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Unlock Your Zengly Experience 🎁",
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Complete quick verification steps and earn exclusive rewards at every level. The more you verify, the more you win.",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -4,
            bottom: 0,
            child: Image.asset(
              AppImages.handHold,
              height: 110,
            ),
          ),
        ],
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
