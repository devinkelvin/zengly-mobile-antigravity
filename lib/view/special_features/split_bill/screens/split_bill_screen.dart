import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../split_bill_vm.dart';

class SplitBillScreen extends ConsumerStatefulWidget {
  const SplitBillScreen({super.key});

  @override
  ConsumerState<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends ConsumerState<SplitBillScreen> {
  int _selectedTabIndex = 0; // 0: All, 1: Active, 2: Completed, 3: You Owe

  final List<String> _tabs = ["All", "Active", "Completed", "You Owe"];

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "dining":
        return Icons.restaurant_rounded;
      case "travel":
        return Icons.flight_takeoff_rounded;
      case "groceries":
        return Icons.shopping_basket_rounded;
      case "nightlife":
      case "party":
        return Icons.celebration_rounded;
      case "rent":
        return Icons.home_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "dining":
        return const Color(0xFFF5A623);
      case "travel":
        return const Color(0xFF3867D6);
      case "groceries":
        return const Color(0xFF20BF6B);
      case "nightlife":
      case "party":
        return const Color(0xFFEB3B5A);
      case "rent":
        return const Color(0xFF8854D0);
      default:
        return const Color(0xFFE5A93C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final splitState = ref.watch(splitBillProvider);
    final notifier = ref.read(splitBillProvider.notifier);

    List<SplitBillItem> filteredBills;
    switch (_selectedTabIndex) {
      case 1:
        filteredBills = splitState.bills.where((b) => b.status == "Active").toList();
        break;
      case 2:
        filteredBills = splitState.bills.where((b) => b.status == "Completed").toList();
        break;
      case 3:
        filteredBills = splitState.bills
            .where((b) => !b.isCreatedByYou && b.youParticipant != null && !b.youParticipant!.isPaid)
            .toList();
        break;
      default:
        filteredBills = splitState.bills;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0D0C0A) : const Color(0xFFFAF7F2);
    final buttonBg = isDark ? const Color(0xFF1E1D1A) : const Color(0xFFEDE4D4);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E1A14);

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
        title: Text(
          "Split Bill",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        actions: const [
          BalanceWidget(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Financial Dashboard Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF262013),
                    Color(0xFF181510),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFFE5A93C).withValues(alpha: 0.28),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE5A93C).withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative ambient glow orb
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE5A93C).withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5A93C).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFE5A93C).withValues(alpha: 0.35),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                "GROUP EXPENSES",
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: const Color(0xFFF5A623),
                                ),
                              ),
                            ),
                            Text(
                              "${splitState.bills.length} total bills",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "Divide expenses fairly",
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Track, settle & remind friends with zero awkwardness.",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Financial metrics pills
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.arrow_downward_rounded,
                                          size: 13,
                                          color: Color(0xFF2ED573),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "You're Owed",
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: Colors.white60,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      CurrencyFormatter.format(splitState.totalOwedToYou),
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2ED573),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.arrow_upward_rounded,
                                          size: 13,
                                          color: Color(0xFFFF4757),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "You Owe",
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            color: Colors.white60,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      CurrencyFormatter.format(splitState.totalYouOwe),
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFFF4757),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Action Buttons Row
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () => context.pushNamed(AppRouter.createBill),
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFF5A623), Color(0xFFE5A93C)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFF5A623).withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_rounded,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Create a Split Bill",
                                        style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => context.pushNamed(AppRouter.qrScanner),
                              child: Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tab Filter Pills
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedTabIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTabIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE5A93C) : const Color(0xFF1E1D1A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFE5A93C)
                              : Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Text(
                        _tabs[index],
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.black : Colors.white70,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // Bills List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Splits",
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pushNamed(AppRouter.splitBillHistory),
                  child: Text(
                    "History →",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE5A93C),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Bills List
            if (filteredBills.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF181714),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE5A93C).withValues(alpha: 0.12),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: Color(0xFFE5A93C),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "No bills in this view",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Start a new split bill with friends in seconds.",
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: Colors.white54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredBills.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final bill = filteredBills[index];
                  final isCompleted = bill.status == "Completed";
                  final catColor = _getCategoryColor(bill.category);

                  return GestureDetector(
                    onTap: () {
                      notifier.selectBill(bill.id);
                      context.pushNamed(AppRouter.splitBillDetailScreen);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF181714),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isCompleted
                              ? Colors.white.withValues(alpha: 0.06)
                              : catColor.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getCategoryIcon(bill.category),
                                  color: catColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            bill.title,
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isCompleted
                                                ? const Color(0xFF2ED573).withValues(alpha: 0.15)
                                                : const Color(0xFFE5A93C).withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            bill.status,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: isCompleted
                                                  ? const Color(0xFF2ED573)
                                                  : const Color(0xFFE5A93C),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "${bill.date} • ${bill.merchantName.isNotEmpty ? bill.merchantName : bill.category}",
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.white54,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: bill.progress,
                              minHeight: 6,
                              backgroundColor: Colors.white.withValues(alpha: 0.08),
                              valueColor: AlwaysStoppedAnimation(
                                isCompleted ? const Color(0xFF2ED573) : catColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Avatars + Amount Summary
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Participant avatar circles
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 28,
                                      width: (bill.participants.length.clamp(1, 4) * 20.0) + 12,
                                      child: Stack(
                                        children: List.generate(
                                          bill.participants.length.clamp(0, 4),
                                          (i) {
                                            final p = bill.participants[i];
                                            return Positioned(
                                              left: i * 18.0,
                                              child: Container(
                                                height: 28,
                                                width: 28,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: p.avatarColor,
                                                  border: Border.all(
                                                    color: const Color(0xFF181714),
                                                    width: 2,
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Stack(
                                                  alignment: Alignment.bottomRight,
                                                  children: [
                                                    Center(
                                                      child: Text(
                                                        p.avatarInitial.isNotEmpty
                                                            ? p.avatarInitial
                                                            : p.name[0],
                                                        style: GoogleFonts.inter(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    if (p.isPaid)
                                                      Container(
                                                        height: 10,
                                                        width: 10,
                                                        decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Color(0xFF2ED573),
                                                        ),
                                                        child: const Icon(
                                                          Icons.check,
                                                          size: 7,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        "${bill.paidCount}/${bill.participantsCount} paid",
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.white60,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Total Amount
                              Text(
                                CurrencyFormatter.format(bill.totalAmount),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
