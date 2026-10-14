import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class TransactionDisputeScreen extends StatefulWidget {
  final String? preselectedRef;
  final String? preselectedAmount;

  const TransactionDisputeScreen({
    super.key,
    this.preselectedRef,
    this.preselectedAmount,
  });

  @override
  State<TransactionDisputeScreen> createState() => _TransactionDisputeScreenState();
}

class _TransactionDisputeScreenState extends State<TransactionDisputeScreen> {
  late TextEditingController _refController;
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = "Debited but recipient did not receive";
  bool _isSubmitted = false;
  String _disputeTicket = "";

  final List<String> _categories = [
    "Debited but recipient did not receive",
    "Failed bill payment (Electricity token not issued)",
    "Airtime or Data purchase not delivered",
    "Unauthorized or duplicate debit",
    "Vaniti digital cash spray dispute",
    "Other transaction issue",
  ];

  @override
  void initState() {
    super.initState();
    _refController = TextEditingController(text: widget.preselectedRef ?? "");
  }

  @override
  void dispose() {
    _refController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submitDispute() {
    if (_refController.text.trim().isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Reference Required",
        message: "Please enter the transaction reference or session ID.",
        toastType: ToastificationType.error,
      );
      return;
    }

    if (_descController.text.trim().isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Details Required",
        message: "Please briefly describe the transaction issue.",
        toastType: ToastificationType.error,
      );
      return;
    }

    setState(() {
      _disputeTicket = "DISP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6B655D);
    final cardBg = isDark ? const Color(0xFF1E1A14) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEBE3D7);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Transaction Issue",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: _isSubmitted
            ? _buildSubmittedView(isDark, primaryColor, textPrimary, textSecondary, cardBg, borderColor)
            : _buildFormView(isDark, primaryColor, textPrimary, textSecondary, cardBg, borderColor),
      ),
    );
  }

  Widget _buildFormView(
    bool isDark,
    Color primaryColor,
    Color textPrimary,
    Color textSecondary,
    Color cardBg,
    Color borderColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top SLA info banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Icon(Icons.timer_outlined, size: 24, color: primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Resolution Guarantee",
                      style: GoogleFonts.raleway(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Interbank and utility reversals are investigated within 24 to 48 banking hours in line with CBN standards.",
                      style: GoogleFonts.inter(fontSize: 12, color: textSecondary, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Text(
          "Problem Category",
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedCategory,
              items: _categories.map((c) {
                return DropdownMenuItem<String>(
                  value: c,
                  child: Text(c, style: GoogleFonts.inter(fontSize: 13, color: textPrimary)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          "Transaction Reference / Session ID",
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _refController,
          style: GoogleFonts.inter(fontSize: 13, color: textPrimary),
          decoration: InputDecoration(
            hintText: "e.g. ZNG-TRX-20261014-9842",
            hintStyle: GoogleFonts.inter(fontSize: 13, color: textSecondary),
            filled: true,
            fillColor: cardBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          "Description & Details",
          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descController,
          maxLines: 4,
          style: GoogleFonts.inter(fontSize: 13, color: textPrimary),
          decoration: InputDecoration(
            hintText: "Explain what happened, amount involved, and any error message displayed...",
            hintStyle: GoogleFonts.inter(fontSize: 13, color: textSecondary),
            filled: true,
            fillColor: cardBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
          ),
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _submitDispute,
            child: Text("Submit Dispute Ticket", style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSubmittedView(
    bool isDark,
    Color primaryColor,
    Color textPrimary,
    Color textSecondary,
    Color cardBg,
    Color borderColor,
  ) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF34C759).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline_rounded, size: 54, color: Color(0xFF34C759)),
          ),
          const SizedBox(height: 18),
          Text(
            "Dispute Ticket Logged",
            style: GoogleFonts.raleway(fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              "Ticket: $_disputeTicket",
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: primaryColor),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Our Dispute & Reconciliation Desk has received your request. A confirmation and updates will be routed to your registered email address.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, color: textSecondary, height: 1.45),
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _buildSummaryRow("Category", _selectedCategory, textPrimary),
                const Divider(height: 18),
                _buildSummaryRow("Reference", _refController.text, textPrimary),
                const Divider(height: 18),
                _buildSummaryRow("Expected SLA", "Within 24–48 Banking Hours", const Color(0xFF34C759)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => context.pop(),
              child: Text("Done", style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12.5, color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: valueColor),
          ),
        ),
      ],
    );
  }
}
