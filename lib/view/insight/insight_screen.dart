import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/utils.dart';
import '../dashboard/dashboard_vm.dart';
import 'insight_vm.dart';
import 'models/insight_models.dart';
import 'widgets/widgets.dart';

class InsightScreen extends ConsumerStatefulWidget {
  const InsightScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InsightScreenState();
}

class _InsightScreenState extends ConsumerState<InsightScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(insightVm);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2);
    final buttonBg = isDark ? const Color(0xFF25231F) : const Color(0xFFEDE4D4);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => ref.read(dashboardVm).switchPage(0),
            child: Container(
              decoration: BoxDecoration(
                color: buttonBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: textPrimary,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          "AI Insights",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InsightTabSelector(
              selected: vm.selectedTab,
              onChanged: vm.selectTab,
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildTab(vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(InsightNotifier vm) {
    switch (vm.selectedTab) {
      case InsightTab.all:
        return InsightAllTab(cards: vm.allCards);
      case InsightTab.analytics:
        return InsightAnalyticsTab(
          points: vm.analyticsPoints,
          selectedPeriod: vm.analyticsPeriod,
          onPeriodChanged: vm.selectAnalyticsPeriod,
        );
      case InsightTab.assistant:
        return InsightChatTab(
          messages: vm.messages,
          suggestedPrompts: vm.suggestedPrompts,
          isAiTyping: vm.isAiTyping,
          showBanner: vm.showAiBanner,
          onDismissBanner: vm.dismissAiBanner,
          onSendPrompt: vm.sendPrompt,
        );
      case InsightTab.spending:
        return InsightSpendingTab(
          categories: vm.spendingCategories,
          selectedPeriod: vm.spendingPeriod,
          onPeriodChanged: vm.selectSpendingPeriod,
          selectedIndex: vm.selectedSpendingIndex,
          onCategoryTap: vm.selectSpendingCategory,
          dateRange: vm.spendingDateRange,
          onDateRangeChanged: vm.updateSpendingDateRange,
        );
    }
  }
}
