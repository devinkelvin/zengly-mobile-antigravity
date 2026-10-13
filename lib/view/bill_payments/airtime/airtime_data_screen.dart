import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class AirtimeDataScreen extends ConsumerStatefulWidget {
  const AirtimeDataScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AirtimeDataScreenState();
}

class _AirtimeDataScreenState extends ConsumerState<AirtimeDataScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          "Airtime & Data",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        actions: [BalanceWidget()],
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
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _AirtimeDataTabs(controller: _tabController),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [AirtimeBody(), DataBody()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Two standalone cards rather than a segmented control — the selected one
/// carries a gold outline and a check badge notched into its top-right corner.
class _AirtimeDataTabs extends StatelessWidget {
  final TabController controller;
  const _AirtimeDataTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          children: [
            Expanded(
              child: _TabCard(
                label: "Airtime",
                selected: controller.index == 0,
                onTap: () => controller.animateTo(0),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _TabCard(
                label: "Data",
                selected: controller.index == 1,
                onTap: () => controller.animateTo(1),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TabCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: scheme.outlineVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    color: selected
                        ? scheme.onSurface
                        : scheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
              if (selected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 22,
                    width: 26,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
