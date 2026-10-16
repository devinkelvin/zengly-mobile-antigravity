import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';
import '../split_bill_vm.dart';

class SplitBillHistoryScreen extends ConsumerStatefulWidget {
  const SplitBillHistoryScreen({super.key});

  @override
  ConsumerState<SplitBillHistoryScreen> createState() =>
      _SplitBillHistoryScreenState();
}

class _SplitBillHistoryScreenState extends ConsumerState<SplitBillHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splitState = ref.watch(splitBillProvider);
    final notifier = ref.read(splitBillProvider.notifier);

    final pendingBills = splitState.bills.where((b) => b.status == "Active").toList();
    final completedBills = splitState.bills.where((b) => b.status == "Completed").toList();

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
          "Split Bill History",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        actions: const [
          BalanceWidget(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF181714),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFFE5A93C),
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white60,
              labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
              tabs: [
                Tab(text: "Active & Pending (${pendingBills.length})"),
                Tab(text: "Completed (${completedBills.length})"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBillList(pendingBills, notifier, "No pending splits"),
          _buildBillList(completedBills, notifier, "No completed splits yet"),
        ],
      ),
    );
  }

  Widget _buildBillList(
    List<SplitBillItem> bills,
    SplitBillNotifier notifier,
    String emptyMessage,
  ) {
    if (bills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE5A93C).withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFFE5A93C),
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bills.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final bill = bills[index];
        final isCompleted = bill.status == "Completed";

        return GestureDetector(
          onTap: () {
            notifier.selectBill(bill.id);
            context.pushNamed(AppRouter.splitBillDetailScreen);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF181714),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                const SizedBox(height: 4),
                Text(
                  "${bill.date} • ${bill.merchantName.isNotEmpty ? bill.merchantName : bill.category}",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: bill.progress,
                    minHeight: 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation(
                      isCompleted ? const Color(0xFF2ED573) : const Color(0xFFE5A93C),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${bill.paidCount} of ${bill.participantsCount} paid",
                      style: GoogleFonts.inter(fontSize: 11, color: Colors.white60),
                    ),
                    Text(
                      bill.status,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isCompleted
                            ? const Color(0xFF2ED573)
                            : const Color(0xFFE5A93C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
