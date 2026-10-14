import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import 'widgets/widgets.dart';

class TransactionFilterScreen extends StatefulWidget {
  const TransactionFilterScreen({super.key});

  @override
  State<TransactionFilterScreen> createState() =>
      _TransactionFilterScreenState();
}

class _TransactionFilterScreenState extends State<TransactionFilterScreen> {
  static const _categories = [
    "All Category",
    "Wallet Topup",
    "Service Request",
    "Electricity Payment",
  ];
  static const _statuses = [
    "All Status",
    "Success",
    "Pending",
    "Failed",
    "Reversed",
  ];
  static const _periods = [
    "Custom",
    "Current Week",
    "Last Week",
    "Current Month",
  ];

  String _selectedCategory = "All Category";
  String _selectedStatus = "All Status";
  String _selectedPeriod = "Custom";

  DateTime? _startDate = DateTime(2024, 11, 25);
  DateTime? _endDate = DateTime(2024, 11, 25);

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: initialDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFB57510),
              onPrimary: Colors.white,
              surface: Color(0xFF231E18),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "25 Nov 2024";
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  void _clearAll() {
    setState(() {
      _selectedCategory = "All Category";
      _selectedStatus = "All Status";
      _selectedPeriod = "Custom";
      _startDate = DateTime(2024, 11, 25);
      _endDate = DateTime(2024, 11, 25);
    });
  }

  void _applyFilter() {
    Navigator.of(context).pop(
      TransactionFilterResult(
        category: _selectedCategory == "All Category" ? null : _selectedCategory,
        status: _selectedStatus == "All Status" ? null : _selectedStatus,
        startDate: _startDate,
        endDate: _endDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFF221E18);
    const borderColor = Color(0xFF2D271F);
    const primaryAmber = Color(0xFFB57510);
    const unselectedPillBg = Color(0xFF2C251C);

    return Scaffold(
      backgroundColor: const Color(0xFF16140F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Filter",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CATEGORY SECTION (Screenshot 2)
                    _buildFilterGroup(
                      title: "Category",
                      cardBg: cardBg,
                      borderColor: borderColor,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _categories.map((c) {
                          final isSelected = _selectedCategory == c;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = c),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryAmber : unselectedPillBg,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                c,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // STATUS SECTION (Screenshot 2)
                    _buildFilterGroup(
                      title: "Status",
                      cardBg: cardBg,
                      borderColor: borderColor,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _statuses.map((s) {
                          final isSelected = _selectedStatus == s;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedStatus = s),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryAmber : unselectedPillBg,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                s,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // PERIOD SECTION (Screenshot 2)
                    _buildFilterGroup(
                      title: "Period",
                      cardBg: cardBg,
                      borderColor: borderColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Horizontal Period Pills
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: _periods.map((p) {
                                final isSelected = _selectedPeriod == p;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedPeriod = p),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF14120E)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.white.withValues(alpha: 0.25)
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Text(
                                      p,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Start Date Field (Screenshot 2)
                          _buildDateRow(
                            label: "Start Date",
                            value: _formatDate(_startDate),
                            onTap: () => _pickDate(isStart: true),
                          ),

                          const SizedBox(height: 10),

                          // End Date Field (Screenshot 2)
                          _buildDateRow(
                            label: "End Date",
                            value: _formatDate(_endDate),
                            onTap: () => _pickDate(isStart: false),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // BOTTOM ACTION BUTTONS: "Clear All" & "Apply Filter" (Screenshot 2)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                children: [
                  // Clear All Button (Dark pill)
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF26211A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        onPressed: _clearAll,
                        child: Text(
                          "Clear All",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Apply Filter Button (Amber pill)
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryAmber,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        onPressed: _applyFilter,
                        child: Text(
                          "Apply Filter",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterGroup({
    required String title,
    required Color cardBg,
    required Color borderColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              Icon(
                Icons.info_outline_rounded,
                size: 17,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildDateRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2C251C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
