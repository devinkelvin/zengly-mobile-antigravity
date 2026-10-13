import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTab extends StatelessWidget implements PreferredSize {
  final TabController tabController;
  final List<String> titles;
  final bool hasPadding;
  const AppTab({
    super.key,
    required this.tabController,
    required this.titles,
    this.hasPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Container(
          margin:
              hasPadding
                  ? const EdgeInsets.symmetric(horizontal: 20)
                  : EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          child: TabBar(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            indicatorSize: TabBarIndicatorSize.tab,
            controller: tabController,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            indicatorColor: Colors.transparent,
            unselectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 0,
            ),
            labelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            tabs:
                titles.map((e) {
                  return Tab(text: e, height: 40);
                }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget get child => AppTab(tabController: tabController, titles: titles);

  @override
  Size get preferredSize => const Size.fromHeight(40);
}

class AppTab2 extends StatelessWidget implements PreferredSize {
  final TabController tabController;
  final List<String> titles;
  const AppTab2({super.key, required this.tabController, required this.titles});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: tabController,
            dividerColor: Colors.transparent,
            indicatorWeight: 3,
            indicatorColor: Theme.of(context).colorScheme.primary,
            unselectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0,
            ),
            labelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            tabs:
                titles.map((e) {
                  return Tab(text: e, height: 50);
                }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget get child => AppTab(tabController: tabController, titles: titles);

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
