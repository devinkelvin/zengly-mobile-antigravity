import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../widgets/widgets.dart';

class TransactionDisputeScreen extends StatefulWidget {
  final String? preselectedRef;
  final String? preselectedAmount;
  final bool isBottomSheet;

  const TransactionDisputeScreen({
    super.key,
    this.preselectedRef,
    this.preselectedAmount,
    this.isBottomSheet = true,
  });

  static Future<void> show(
    BuildContext context, {
    String? preselectedRef,
    String? preselectedAmount,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: TransactionDisputeScreen(
          preselectedRef: preselectedRef,
          preselectedAmount: preselectedAmount,
          isBottomSheet: true,
        ),
      ),
    );
  }

  @override
  State<TransactionDisputeScreen> createState() =>
      _TransactionDisputeScreenState();
}

class _TransactionDisputeScreenState extends State<TransactionDisputeScreen> {
  late TextEditingController _refController;
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = "Debited but recipient did not receive";
  bool _isSubmitted = false;
  bool _isLoading = false;
  String _disputeTicket = "";

  final List<String> _categories = [
    "Debited but recipient did not receive",
    "Failed bill payment (Token not issued)",
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

  void _submitDispute() async {
    if (_refController.text.trim().isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Reference Required",
        message: "Please enter the transaction reference.",
        toastType: ToastificationType.warning,
      );
      return;
    }

    if (_descController.text.trim().isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Description Required",
        message: "Please explain the transaction issue.",
        toastType: ToastificationType.warning,
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _disputeTicket =
          "DISP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF1E1C18);
    const cardColor = Color(0xFF262420);
    const primaryAmber = Color(0xFFC58314);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E2C28),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ),
                Text(
                  "Report Transaction",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Body Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _isSubmitted ? _buildSubmittedState() : _buildForm(cardColor, primaryAmber),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(Color cardColor, Color primaryAmber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transaction Summary Pill
        if (widget.preselectedAmount != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: primaryAmber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: primaryAmber.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: primaryAmber,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  "Transaction Amount: ${widget.preselectedAmount}",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Reference input
        Text(
          "Transaction Reference",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: TextField(
            controller: _refController,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
            decoration: const InputDecoration(
              hintText: "e.g. TXN-9482019482",
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Dispute Category
        Text(
          "Dispute Category",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: cardColor,
              value: _selectedCategory,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
              style: GoogleFonts.inter(fontSize: 13.5, color: Colors.white),
              items: _categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat, maxLines: 1, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Issue Description
        Text(
          "Issue Description",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _descController,
            maxLines: 4,
            style: GoogleFonts.inter(fontSize: 13.5, color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Describe what happened in detail...",
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitDispute,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryAmber,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    "Submit Dispute",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSubmittedState() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: Color(0xFF00B050),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Dispute Logged",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Ticket ID: $_disputeTicket",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFC58314),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Our compliance and settlements team will investigate with the partner banking switch. Updates will be sent to your email within 24 hours.",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.white60,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC58314),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Done"),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
