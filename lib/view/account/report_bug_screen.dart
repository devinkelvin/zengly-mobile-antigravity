import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../widgets/widgets.dart';

class ReportBugScreen extends StatefulWidget {
  const ReportBugScreen({super.key});

  @override
  State<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends State<ReportBugScreen> {
  final TextEditingController _descController = TextEditingController();
  String _selectedCategory = "UI / Visuals";
  bool _attachDiagnostics = true;
  bool _hasScreenshot = false;
  bool _isSubmitted = false;
  bool _isLoading = false;
  String _ticketId = "";

  final List<String> _categories = [
    "UI / Visuals",
    "Transfers",
    "Vaniti Spray",
    "Bills & Utilities",
    "Account / KYC",
    "Other",
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _submitBug() async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      AppOverlays.showToast(
        context: context,
        title: "Description Required",
        message: "Please describe the issue or bug encountered",
        toastType: ToastificationType.warning,
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _ticketId = "BUG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF14120E);
    const cardColor = Color(0xFF1F1D19);
    const inputBg = Color(0xFF262420);
    const primaryAmber = Color(0xFFC58314);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF25231F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          "Report a Bug",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: _isSubmitted
              ? _buildSubmittedView(primaryAmber)
              : _buildForm(primaryAmber, cardColor, inputBg),
        ),
      ),
    );
  }

  Widget _buildForm(Color primaryAmber, Color cardColor, Color inputBg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bug Category",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((cat) {
            final isSelected = cat == _selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? primaryAmber : cardColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        // Description field
        Text(
          "Describe the issue",
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: inputBg,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(14),
          child: TextField(
            controller: _descController,
            maxLines: 5,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
            decoration: const InputDecoration(
              hintText: "What went wrong? Steps to reproduce...",
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Screenshot upload box
        GestureDetector(
          onTap: () {
            setState(() => _hasScreenshot = !_hasScreenshot);
            AppOverlays.showToast(
              context: context,
              title: _hasScreenshot ? "Screenshot Attached" : "Screenshot Removed",
              message: _hasScreenshot
                  ? "screenshot_20261014.png attached"
                  : "Removed attachment",
              toastType: ToastificationType.info,
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hasScreenshot ? primaryAmber : Colors.white12,
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _hasScreenshot ? Icons.check_circle : Icons.camera_alt_outlined,
                  color: _hasScreenshot ? primaryAmber : Colors.white54,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  _hasScreenshot
                      ? "Screenshot Attached (Tap to change)"
                      : "Tap to attach screenshot (optional)",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: _hasScreenshot ? Colors.white : Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Diagnostic toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.perm_device_info_outlined,
                color: Colors.white70,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Include Diagnostics",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Device model, Android version & app logs",
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: _attachDiagnostics,
                activeTrackColor: primaryAmber,
                activeThumbColor: Colors.white,
                onChanged: (val) => setState(() => _attachDiagnostics = val),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitBug,
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
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.2,
                    ),
                  )
                : Text(
                    "Submit Bug Report",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmittedView(Color primaryAmber) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFF00B050),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Bug Report Submitted",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Ticket ID: $_ticketId",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryAmber,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Thank you for helping us make Zengly better. Our engineering team has received your logs and description.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: Colors.white60,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryAmber,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Return to Account"),
            ),
          ),
        ],
      ),
    );
  }
}
