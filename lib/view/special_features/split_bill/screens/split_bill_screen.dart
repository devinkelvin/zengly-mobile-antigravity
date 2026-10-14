import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/widgets.dart';

class _BillHistoryItem {
  final String title;
  final String date;
  final String amount;

  const _BillHistoryItem({
    required this.title,
    required this.date,
    required this.amount,
  });
}

class SplitBillScreen extends ConsumerStatefulWidget {
  const SplitBillScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SplitBillScreenState();
}

class _SplitBillScreenState extends ConsumerState<SplitBillScreen> {
  static const _billHistory = [
    _BillHistoryItem(
      title: "Lola's Birthday Dinner",
      date: "18 Apr 2026",
      amount: "₦500k",
    ),
    _BillHistoryItem(
      title: "Dubai Trip 2026",
      date: "18 Apr 2026",
      amount: "₦500k",
    ),
    _BillHistoryItem(
      title: "August shopping",
      date: "18 Apr 2026",
      amount: "₦500k",
    ),
  ];

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
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          "Split Bill",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0,
          ),
        ),
        actions: const [
          BalanceWidget(),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  // Warm brown, lighter at the top-left as in the design.
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF8A5A1A), Color(0xFF6E4413)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Sphere cluster anchored to the right, bleeding off the
                    // bottom-right corner and trimmed by the card's clip.
                    Positioned(
                      right: -12,
                      bottom: -12,
                      child: Opacity(
                        // Sits back into the banner rather than reading as a
                        // solid object on top of it.
                        opacity: 0.55,
                        child: Image.asset(
                          AppImages.bill,
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Non-positioned, so this is what gives the Stack — and the
                    // card — its height. No fixed height means no overflow.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 22, 105, 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "SPLIT BILL",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: Colors.white.withValues(alpha: 0.72),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Divide expenses fairly",
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                              height: 1.15,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "add friends using NFC, QR, or username.",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              letterSpacing: 0,
                              color: Colors.white.withValues(alpha: 0.72),
                            ),
                          ),
                          const SizedBox(height: 18),
                          AppButton.compact(
                            onPressed: () => context.pushNamed(AppRouter.createBill),
                            actionText: "Create a Split Bill",
                            backgroundColor: const Color(0xFFE8A317),
                            textColor: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bill History",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            context.pushNamed(AppRouter.splitBillHistory),
                        child: Text(
                          "See More",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ..._billHistory.asMap().entries.map((entry) {
                    final isLast = entry.key == _billHistory.length - 1;
                    final bill = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                      child: GestureDetector(
                        onTap: () =>
                            context.pushNamed(AppRouter.splitBillDetailScreen),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              // Pre-composed overlapping avatar cluster.
                              Image.asset(AppImages.billHistory, height: 32),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bill.title,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      bill.date,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        letterSpacing: 0,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.scrim,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                bill.amount,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
