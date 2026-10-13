import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';
import 'models/insight_models.dart';

class InsightNotifier extends ChangeNotifier {
  InsightTab selectedTab = InsightTab.all;
  bool showAiBanner = true;
  bool isAiTyping = false;
  String analyticsPeriod = "1M";
  String spendingPeriod = "1M";
  int? selectedSpendingIndex;

  void selectTab(InsightTab tab) {
    selectedTab = tab;
    notifyListeners();
  }

  void dismissAiBanner() {
    showAiBanner = false;
    notifyListeners();
  }

  void selectAnalyticsPeriod(String period) {
    analyticsPeriod = period;
    notifyListeners();
  }

  DateTimeRange spendingDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  late List<SpendingCategory> spendingCategories;

  InsightNotifier() {
    _buildSpendingCategories(multiplier: 1.0, txScale: 1.0);
  }

  void selectSpendingPeriod(String period) {
    spendingPeriod = period;
    final now = DateTime.now();
    switch (period) {
      case "1D":
        spendingDateRange = DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: now,
        );
        _buildSpendingCategories(multiplier: 0.05, txScale: 0.1);
        break;
      case "1W":
        spendingDateRange = DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );
        _buildSpendingCategories(multiplier: 0.25, txScale: 0.25);
        break;
      case "1M":
        spendingDateRange = DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
        _buildSpendingCategories(multiplier: 1.0, txScale: 1.0);
        break;
      case "6M":
        spendingDateRange = DateTimeRange(
          start: DateTime(now.year, now.month - 6, now.day),
          end: now,
        );
        _buildSpendingCategories(multiplier: 5.6, txScale: 5.0);
        break;
      case "1Y":
        spendingDateRange = DateTimeRange(
          start: DateTime(now.year - 1, now.month, now.day),
          end: now,
        );
        _buildSpendingCategories(multiplier: 11.4, txScale: 10.0);
        break;
      case "CUSTOM":
        _updateCategoriesForDays(spendingDateRange.duration.inDays);
        break;
    }
    notifyListeners();
  }

  void updateSpendingDateRange(DateTimeRange range) {
    spendingDateRange = range;
    spendingPeriod = "CUSTOM";
    _updateCategoriesForDays(range.duration.inDays);
    notifyListeners();
  }

  void _updateCategoriesForDays(int days) {
    final effectiveDays = days.clamp(1, 3650);
    final mult = effectiveDays / 30.0;
    _buildSpendingCategories(multiplier: mult, txScale: mult);
  }

  void _buildSpendingCategories({
    required double multiplier,
    required double txScale,
  }) {
    final rawList = [
      (
        label: "Transfers",
        base: 128500.0,
        color: const Color(0xFF3B82F6),
        icon: Icons.swap_horiz_rounded,
        baseTx: 18,
      ),
      (
        label: "Food & Dining",
        base: 78200.0,
        color: const Color(0xFFEC4899),
        icon: Icons.restaurant_rounded,
        baseTx: 34,
      ),
      (
        label: "Electricity & Bills",
        base: 42000.0,
        color: const Color(0xFF14B8A6),
        icon: Icons.bolt_rounded,
        baseTx: 6,
      ),
      (
        label: "Phone Bills & Data",
        base: 28500.0,
        color: const Color(0xFFB57510),
        icon: Icons.phone_android_rounded,
        baseTx: 14,
      ),
      (
        label: "Subscriptions",
        base: 24000.0,
        color: const Color(0xFF8B5CF6),
        icon: Icons.subscriptions_rounded,
        baseTx: 5,
      ),
      (
        label: "Others & Shopping",
        base: 16800.0,
        color: const Color(0xFF6366F1),
        icon: Icons.shopping_bag_outlined,
        baseTx: 8,
      ),
    ];

    final maxVal = rawList.first.base * multiplier;
    spendingCategories =
        rawList.map((item) {
          final amt = (item.base * multiplier).roundToDouble();
          final txCount = ((item.baseTx * txScale).round()).clamp(1, 9999);
          final wFactor = maxVal > 0 ? (amt / maxVal).clamp(0.15, 1.0) : 0.5;
          return SpendingCategory(
            label: item.label,
            amount: amt,
            color: item.color,
            widthFactor: wFactor,
            icon: item.icon,
            transactionCount: txCount,
          );
        }).toList();
  }

  void selectSpendingCategory(int index) {
    selectedSpendingIndex = selectedSpendingIndex == index ? null : index;
    notifyListeners();
  }

  final List<InsightCardModel> allCards = [
    InsightCardModel(
      icon: AppImages.insightsBell,
      iconBackground: Color(0xFFB57510),
      hasAlert: true,
      title: "Great job! You're saving well this month",
      description:
          "You saved 36% of your income. Keep it up to hit your financial goals faster.",
      chips: [InsightChip(label: "Insight", value: "")],
      linkText: "Invest savings",
    ),
    InsightCardModel(
      icon: AppImages.insightsBell,
      iconBackground: Color(0xFFB57510),
      hasAlert: true,
      title: "Airtime & Data Draining Cash",
      description:
          "You've spent ₦18,500 on airtime and ₦12,000 on data bundles this month "
          " that's ₦30,500 total. Switching to a monthly plan could save you ₦9,000.",
      chips: [
        InsightChip(label: "Amount", value: "₦30,500"),
        InsightChip(label: "Impact", value: "24%"),
      ],
      linkText: "See Cheaper Plans",
    ),
    InsightCardModel(
      icon: AppImages.insightsFund,
      iconBackground: Color(0xFF1E3A8A),
      hasAlert: true,
      title: "Japa Fund on Track",
      description:
          "You're saving ₦45,000/month towards your Japa Fund. At this rate you'll "
          "hit ₦500k by November keep the momentum!",
      chips: [
        InsightChip(label: "Amount", value: "₦30,500"),
        InsightChip(label: "Impact", value: "9%"),
      ],
      linkText: "View Goals",
    ),
    InsightCardModel(
      icon: AppImages.insightsFund,
      iconBackground: Color(0xFF1E3A8A),
      title: "DSTV Renewal in 3 Days",
      description:
          "Your DSTV GOtv Max subscription (₦18,500) renews on April 1st. Ensure "
          "your GTBank account has sufficient funds to avoid service interruption.",
      linkText: "Manage Subscription",
    ),
  ];

  final List<AnalyticsPoint> analyticsPoints = const [
    AnalyticsPoint(label: "Sep", income: 180000, expense: 160000),
    AnalyticsPoint(label: "Oct", income: 210000, expense: 200000),
    AnalyticsPoint(label: "Nov", income: 195000, expense: 230000),
    AnalyticsPoint(label: "Dec", income: 260000, expense: 250000),
    AnalyticsPoint(label: "Jan", income: 240000, expense: 280000),
    AnalyticsPoint(label: "Feb", income: 300000, expense: 290000),
    AnalyticsPoint(label: "March", income: 320000, expense: 320000),
  ];


  final List<ChatMessage> messages = [
    const ChatMessage(
      text:
          "Hey Kelvin 👋 I'm your Zengly AI. I can see you've spent ₦8,550 in "
          "hidden fees this month alone  POS charges, NIP transfer fees, and "
          "maintenance. Want me to help you eliminate those?",
      isUser: false,
      timestamp: "3d",
    ),
  ];

  final List<String> suggestedPrompts = const [
    "Why are my POS fees so high?",
    "How much airtime did i buy?",
    "Help me save ₦50K extra",
    "Show my transfer fee report",
    "What are my biggest expenses?",
    "How to reduce bank charges?",
  ];

  static const Map<String, String> _cannedResponses = {
    "Why are my POS fees so high?":
        "You paid ₦4,200 in POS charges this month across ~14 transactions 😅 "
        "Each POS cash withdrawal typically attracts ₦100–₦200 fee from the "
        "agent. Instead, use your GTBank debit card directly at checkout — "
        "zero fee. You'd save around ₦4,200 monthly doing this!",
    "How much airtime did i buy?":
        "You've spent ₦18,500 on airtime and ₦12,000 on data bundles this "
        "March, totalling ₦30,500. That's quite a lot! Switching to a "
        "monthly data plan (e.g. MTN 30GB for ₦7,500) instead of ad-hoc "
        "recharges could save you roughly ₦9,000/month.",
    "Help me save ₦50K extra":
        "You're already saving ₦130,000 this month (26% of income)  solid! "
        "To add an extra ₦50k: cut airtime/data spend by ₦10k, eliminate "
        "POS fees (₦4.2k), reduce food spend by ₦15k, and batch transfers "
        "(₦3k saved). That's already ₦32k. Cut one night out and you're "
        "there 💪",
    "Show my transfer fee report":
        "Your ₦68,000 in transfers this month came with ₦3,150 in NIP "
        "charges. You made multiple small transfers each ₦10–₦50 fee adds "
        "up. Try batching: instead of 6 transfers to family, do 1 large "
        "one. You could cut transfer fees by 60%!",
    "What are my biggest expenses?":
        "Here's where your ₦320,000 went this month:\n\n"
        "Food & Eating — ₦72,000\n"
        "Transfers — ₦68,000\n"
        "Bills & DSTV — ₦52,000\n"
        "Transport — ₦38,000\n"
        "Airtime & Data — ₦30,500 🛩️\n"
        "Bank Fees — ₦7350 (sneaky!)",
    "How to reduce bank charges?":
        "3 ways to slash bank charges right now:\n\n"
        "1. POS withdrawals: Stop withdrawing cash — pay by card directly\n"
        "2. Transfer fees: Batch multiple transfers into one. Use Kuda or "
        "OPay (free transfers)\n"
        "3. Maintenance fees: GTBank charges ₦1,200/month. Moving bulk "
        "salary to Kuda saves this completely\n\n"
        "Total potential savings: ~₦8,000+/month 🚀",
  };

  Future<void> sendPrompt(String prompt) async {
    if (prompt.trim().isEmpty) return;
    messages.add(ChatMessage(text: prompt, isUser: true, timestamp: "now"));
    isAiTyping = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    messages.add(
      ChatMessage(
        text:
            _cannedResponses[prompt] ??
            "I'm still learning! I don't have an answer for that just yet, "
                "but I'm keeping an eye on your spending and will let you "
                "know if anything stands out.",
        isUser: false,
        timestamp: "now",
      ),
    );
    isAiTyping = false;
    notifyListeners();
  }
}

final insightVm = ChangeNotifierProvider<InsightNotifier>((ref) {
  return InsightNotifier();
});
