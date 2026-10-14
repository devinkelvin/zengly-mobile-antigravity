import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/widgets.dart';
import 'apply_loan_screen.dart';

class P2pLendingScreen extends StatefulWidget {
  const P2pLendingScreen({super.key});

  @override
  State<P2pLendingScreen> createState() => _P2pLendingScreenState();
}

class _P2pLendingScreenState extends State<P2pLendingScreen>
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "P2P Lending & Credit",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shield_outlined, color: textPrimary, size: 20),
            onPressed: () {
              AppOverlays.showToast(
                context: context,
                title: "Lending Security",
                message: "All loans are backed by KYC verification, credit scoring, and automatic escrow settlement.",
                toastType: ToastificationType.info,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Credit Limit Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF382709), Color(0xFF221A0F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: primaryColor.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "AVAILABLE CREDIT LIMIT",
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: primaryColor),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded, size: 12, color: Color(0xFF34C759)),
                            const SizedBox(width: 4),
                            Text(
                              "Score: 780 (Tier 2)",
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFF34C759)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "₦250,000.00",
                    style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Instant disbursement directly to your Zengly Wallet upon acceptance.",
                    style: GoogleFonts.inter(fontSize: 11.5, color: Colors.white.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    actionText: "Request Instant Loan",
                    borderRadius: 100,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ApplyLoanScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tab bar: Borrow vs Lend
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1A14) : const Color(0xFFF0EBE1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: textSecondary,
                labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: "Borrow Options"),
                  Tab(text: "Lend & Earn (12% APY)"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Loan Packages
            Text(
              "Tailored Credit Packages",
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
            ),
            const SizedBox(height: 10),

            _LoanPackageCard(
              title: "Quick Salary Advance",
              amountRange: "₦10,000 – ₦50,000",
              tenor: "30 Days",
              rate: "3.5% / month",
              description: "Fast funds to bridge you to your next salary date.",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ApplyLoanScreen(initialAmount: 30000)),
                );
              },
            ),
            _LoanPackageCard(
              title: "SME Working Capital",
              amountRange: "₦50,000 – ₦250,000",
              tenor: "60 to 90 Days",
              rate: "3.2% / month",
              description: "Stock up on business inventory and fulfill client orders.",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ApplyLoanScreen(initialAmount: 150000)),
                );
              },
            ),
            _LoanPackageCard(
              title: "Emergency Healthcare Cushion",
              amountRange: "₦20,000 – ₦100,000",
              tenor: "60 Days",
              rate: "3.0% / month",
              description: "Zero upfront fee medical credit with flexible repayment.",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ApplyLoanScreen(initialAmount: 50000)),
                );
              },
            ),
            const SizedBox(height: 20),

            // Compliance & Risk Notice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1A14) : const Color(0xFFF7F3EC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "P2P Lending is operated under sandbox developmental compliance. Interest terms are transparently disclosed prior to contract acceptance.",
                      style: GoogleFonts.inter(fontSize: 11, color: textSecondary, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _LoanPackageCard extends StatelessWidget {
  final String title;
  final String amountRange;
  final String tenor;
  final String rate;
  final String description;
  final VoidCallback onTap;

  const _LoanPackageCard({
    required this.title,
    required this.amountRange,
    required this.tenor,
    required this.rate,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1A14) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    tenor,
                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(description, style: GoogleFonts.inter(fontSize: 11.5, color: textSecondary)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(amountRange, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: primaryColor)),
                Row(
                  children: [
                    Text("Apply", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
                    Icon(Icons.chevron_right_rounded, size: 16, color: textPrimary),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
