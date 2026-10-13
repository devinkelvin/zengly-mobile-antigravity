import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/widgets.dart';

class ApplyLoanScreen extends StatefulWidget {
  final double initialAmount;

  const ApplyLoanScreen({super.key, this.initialAmount = 50000});

  @override
  State<ApplyLoanScreen> createState() => _ApplyLoanScreenState();
}

class _ApplyLoanScreenState extends State<ApplyLoanScreen> {
  late double _amount;
  int _tenorDays = 30;
  String _loanPurpose = "Personal / Emergency";
  bool _agreedToTerms = true;

  final List<int> _tenorOptions = [30, 60, 90];
  final List<String> _purposes = [
    "Personal / Emergency",
    "Business / Inventory",
    "Medical / Healthcare",
    "Education / Courses",
    "Bills & Utilities",
  ];

  @override
  void initState() {
    super.initState();
    _amount = widget.initialAmount;
  }

  double get _monthlyInterestRate => 0.035; // 3.5% per month transparent rate
  double get _processingFee => _amount * 0.01; // 1% processing fee
  double get _totalInterest => _amount * _monthlyInterestRate * (_tenorDays / 30);
  double get _totalRepayment => _amount + _totalInterest + _processingFee;

  void _submitApplication() {
    if (!_agreedToTerms) {
      AppOverlays.showToast(
        context: context,
        title: "Terms Required",
        message: "Please review and agree to the credit terms & risk disclosures.",
        toastType: ToastificationType.warning,
      );
      return;
    }

    final currencyFormat = NumberFormat.currency(symbol: "₦", decimalDigits: 0);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1C1A17)
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Icon(Icons.check_circle_rounded, color: Color(0xFF34C759), size: 48),
            const SizedBox(height: 12),
            Text(
              "Application Approved!",
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              "Your credit facility of ${currencyFormat.format(_amount)} has been approved and credited to your Zengly Wallet.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12.5, color: Theme.of(context).colorScheme.scrim, height: 1.4),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF26211A)
                    : const Color(0xFFF7F3EB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Disbursed Amount", style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.scrim)),
                      Text(currencyFormat.format(_amount), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Repayment", style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.scrim)),
                      Text(currencyFormat.format(_totalRepayment), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Repayment Due", style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.scrim)),
                      Text(
                        DateFormat('MMM d, yyyy').format(DateTime.now().add(Duration(days: _tenorDays))),
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              actionText: "Done • View Wallet",
              borderRadius: 100,
              onPressed: () {
                Navigator.of(ctx).pop();
                context.pop(); // Return to lending hub
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE);
    final currencyFormat = NumberFormat.currency(symbol: "₦", decimalDigits: 0);

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
          "Apply for Micro-Credit",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Slider Header
            Text(
              "How much do you need?",
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textSecondary),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                currencyFormat.format(_amount),
                style: GoogleFonts.inter(fontSize: 34, fontWeight: FontWeight.w800, color: primaryColor),
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: primaryColor,
                inactiveTrackColor: isDark ? const Color(0xFF2C241A) : const Color(0xFFEAE3D5),
                thumbColor: primaryColor,
                overlayColor: primaryColor.withValues(alpha: 0.15),
              ),
              child: Slider(
                value: _amount,
                min: 10000,
                max: 250000,
                divisions: 24,
                onChanged: (val) => setState(() => _amount = val),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₦10,000 min", style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
                Text("₦250,000 max limit", style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
              ],
            ),
            const SizedBox(height: 20),

            // Tenor Selector
            Text("Repayment Duration", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 8),
            Row(
              children: _tenorOptions.map((days) {
                final isSelected = _tenorDays == days;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(() => _tenorDays = days),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : (isDark ? const Color(0xFF1E1A14) : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? primaryColor : borderColor),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$days Days",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // Purpose Selector
            Text("Loan Purpose", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _loanPurpose,
                  isExpanded: true,
                  dropdownColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
                  items: _purposes.map((p) => DropdownMenuItem(value: p, child: Text(p, style: GoogleFonts.inter(fontSize: 13, color: textPrimary)))).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _loanPurpose = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loan Breakdown Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Requested Principal", style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                      Text(currencyFormat.format(_amount), style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Interest Rate (3.5% / mo)", style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                      Text(currencyFormat.format(_totalInterest), style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Processing Fee (1.0%)", style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                      Text(currencyFormat.format(_processingFee), style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Repayment Amount", style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                      Text(currencyFormat.format(_totalRepayment), style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: primaryColor)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Terms checkbox
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  activeColor: primaryColor,
                  onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                ),
                Expanded(
                  child: Text(
                    "I agree to the transparent credit terms, interest schedule, and automatic wallet deduction on the due date.",
                    style: GoogleFonts.inter(fontSize: 11, color: textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Submit Button
            AppButton(
              actionText: "Accept Offer • Instant Disbursal",
              borderRadius: 100,
              onPressed: _submitApplication,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
