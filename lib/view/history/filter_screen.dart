import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
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
  static const _statuses = ["All Status", "Success", "Pending", "Failed", "Reversed"];
  static const _periods = [
    "Custom",
    "Current Week",
    "Last Week",
    "Current Month",
  ];

  String _selectedCategory = "All Category";
  String _selectedStatus = "All Status";
  String _selectedPeriod = "Custom";

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
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
      _startDate = null;
      _endDate = null;
    });
  }

  void _applyFilter() {
    context.pop(
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
        ),
        title: Text(
          "Filter",
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: AppDimensions.viewPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    _FilterCard(
                      title: "Category",
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _categories
                            .map((c) => FilterChipPill(
                                  label: c,
                                  isSelected: _selectedCategory == c,
                                  onTap: () => setState(() => _selectedCategory = c),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Status
                    _FilterCard(
                      title: "Status",
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _statuses
                            .map((s) => FilterChipPill(
                                  label: s,
                                  isSelected: _selectedStatus == s,
                                  onTap: () => setState(() => _selectedStatus = s),
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Period
                    _FilterCard(
                      title: "Period",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 28,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _periods.length,
                              separatorBuilder: (_, __) => SizedBox(width: 20),
                              itemBuilder: (context, i) {
                                final period = _periods[i];
                                final isSelected = _selectedPeriod == period;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedPeriod = period),
                                  child: Text(
                                    period,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.onSurface
                                          : Theme.of(context).colorScheme.scrim,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          _DateField(
                            label: "Start Date",
                            value: _formatDate(_startDate),
                            onTap: () => _pickDate(isStart: true),
                          ),
                          SizedBox(height: 10),
                          _DateField(
                            label: "End Date",
                            value: _formatDate(_endDate),
                            onTap: () => _pickDate(isStart: false),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: AppDimensions.viewPadding.copyWith(top: 0, bottom: 24),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: _clearAll,
                      actionText: "Clear All",
                      backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                      textColor: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      onPressed: _applyFilter,
                      actionText: "Apply Filter",
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
}

class _FilterCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(16),
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
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
              SvgPicture.asset(
                AppImages.infoCircle,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.scrim,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppImages.calendar,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.scrim,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
