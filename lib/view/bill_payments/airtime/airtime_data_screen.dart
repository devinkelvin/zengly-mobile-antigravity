import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class AirtimeDataScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;
  const AirtimeDataScreen({super.key, this.initialTabIndex = 0});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AirtimeDataScreenState();
}

class _AirtimeDataScreenState extends ConsumerState<AirtimeDataScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: (widget.initialTabIndex >= 0 && widget.initialTabIndex < 2)
          ? widget.initialTabIndex
          : 0,
    );

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0D0C0A) : const Color(0xFFFAF7F2);
    final buttonBg = isDark ? const Color(0xFF1E1D1A) : const Color(0xFFEDE4D4);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);

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
        title: AnimatedBuilder(
          animation: _tabController,
          builder: (context, _) {
            final title =
                _tabController.index == 1 ? "Data Bundles" : "Airtime Top-up";
            return Text(
              title,
              style: GoogleFonts.raleway(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textPrimary,
                letterSpacing: 0,
              ),
            );
          },
        ),
        actions: const [BalanceWidget()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PromoBanner(
              title: "Enjoy fast top ups with Zengly",
              subtitle: "Instant. Secure, Always",
              image: AppImages.smartPhone,
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _AirtimeDataTabs(controller: _tabController),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [AirtimeBody(), DataBody()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Unified, luxury segmented tab control matching the Zengly Bills & Payments family
class _AirtimeDataTabs extends StatelessWidget {
  final TabController controller;
  const _AirtimeDataTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryGold = const Color(0xFFB57510);
    final tabBg = isDark ? const Color(0xFF191714) : const Color(0xFFEEE7DC);
    final borderColor = isDark ? Colors.white10 : const Color(0xFFDFD7CA);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: tabBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SegmentTabItem(
                  label: "Airtime",
                  icon: Icons.phone_android_rounded,
                  selected: controller.index == 0,
                  onTap: () => controller.animateTo(0),
                  primaryGold: primaryGold,
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _SegmentTabItem(
                  label: "Data Bundles",
                  icon: Icons.wifi_rounded,
                  selected: controller.index == 1,
                  onTap: () => controller.animateTo(1),
                  primaryGold: primaryGold,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentTabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color primaryGold;
  final bool isDark;

  const _SegmentTabItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.primaryGold,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 44,
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? const Color(0xFF28231B) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: selected
              ? Border.all(color: primaryGold.withValues(alpha: 0.5), width: 1.2)
              : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected
                  ? primaryGold
                  : (isDark ? Colors.white54 : const Color(0xFF7A6E5D)),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? (isDark ? Colors.white : const Color(0xFF1E1A14))
                    : (isDark ? Colors.white60 : const Color(0xFF7A6E5D)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
