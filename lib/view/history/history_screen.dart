import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';
import 'widgets/widgets.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final List<TransactionHistoryModel> _transactions =
      TransactionHistoryModel.mockList();
  String _query = "";
  TransactionFilterResult? _filter;

  static const Map<String, TransactionStatus> _statusByLabel = {
    "Success": TransactionStatus.successful,
    "Pending": TransactionStatus.pending,
    "Failed": TransactionStatus.failed,
    "Reversed": TransactionStatus.reversed,
  };

  DateTime? _parseTransactionDate(String date) {
    try {
      return DateFormat("d MMM yyyy, h:mm:ss a").parse(date);
    } catch (_) {
      return null;
    }
  }

  List<TransactionHistoryModel> get _filteredTransactions {
    var results = _transactions;

    final filter = _filter;
    if (filter != null) {
      if (filter.category != null) {
        results =
            results
                .where((t) => t.category.label == filter.category)
                .toList();
      }
      if (filter.status != null) {
        final status = _statusByLabel[filter.status];
        results = results.where((t) => t.status == status).toList();
      }
      if (filter.startDate != null || filter.endDate != null) {
        results =
            results.where((t) {
              final date = _parseTransactionDate(t.date);
              if (date == null) return true;
              if (filter.startDate != null && date.isBefore(filter.startDate!)) {
                return false;
              }
              if (filter.endDate != null &&
                  date.isAfter(filter.endDate!.add(const Duration(days: 1)))) {
                return false;
              }
              return true;
            }).toList();
      }
    }

    if (_query.isNotEmpty) {
      final query = _query.toLowerCase();
      results =
          results.where((t) => t.title.toLowerCase().contains(query)).toList();
    }

    return results;
  }

  void _clearCategoryFilter() {
    final filter = _filter;
    if (filter == null) return;
    setState(
      () =>
          _filter = TransactionFilterResult(
            status: filter.status,
            startDate: filter.startDate,
            endDate: filter.endDate,
          ),
    );
  }

  void _clearStatusFilter() {
    final filter = _filter;
    if (filter == null) return;
    setState(
      () =>
          _filter = TransactionFilterResult(
            category: filter.category,
            startDate: filter.startDate,
            endDate: filter.endDate,
          ),
    );
  }

  void _clearDateFilter() {
    final filter = _filter;
    if (filter == null) return;
    setState(
      () =>
          _filter = TransactionFilterResult(
            category: filter.category,
            status: filter.status,
          ),
    );
  }

  String _dateRangeLabel(TransactionFilterResult filter) {
    final start = filter.startDate;
    final end = filter.endDate;
    if (start != null && end != null) {
      return "${DateFormat("d").format(start)} - ${DateFormat("d MMM yyyy").format(end)}";
    }
    if (start != null) return DateFormat("d MMM yyyy").format(start);
    return DateFormat("d MMM yyyy").format(end!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppDimensions.viewPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    if (Navigator.of(context).canPop()) ...[
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        "Transaction History",
                        style: GoogleFonts.raleway(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        AppOverlays.showToast(
                          context: context,
                          message: "Account statement exported to your email",
                          toastType: ToastificationType.success,
                        );
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB57510).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: const Color(0xFFB57510).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.download_rounded,
                              size: 15,
                              color: Color(0xFFB57510),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Statement",
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFB57510),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                HistorySearchBar(
                  onChanged: (value) => setState(() => _query = value),
                  hasActiveFilters: _filter?.hasActiveFilters ?? false,
                  onFilterChanged: (result) => setState(() => _filter = result),
                ),
                if (_filter?.hasActiveFilters ?? false) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_filter!.startDate != null || _filter!.endDate != null)
                        ActiveFilterChip(
                          label: _dateRangeLabel(_filter!),
                          onRemove: _clearDateFilter,
                        ),
                      if (_filter!.category != null)
                        ActiveFilterChip(
                          label: _filter!.category!,
                          onRemove: _clearCategoryFilter,
                        ),
                      if (_filter!.status != null)
                        ActiveFilterChip(
                          label: _filter!.status!,
                          onRemove: _clearStatusFilter,
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                if (_filteredTransactions.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF211D16)
                          : Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFB57510).withValues(alpha: 0.15),
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            size: 28,
                            color: Color(0xFFB57510),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          "No transactions found",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Try adjusting your search terms or active filters",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: Theme.of(context).colorScheme.scrim,
                          ),
                        ),
                        if ((_filter?.hasActiveFilters ?? false) || _query.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _filter = null;
                                _query = "";
                              });
                            },
                            child: Text(
                              "Reset Filters",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFB57510),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF211D16)
                          : Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredTransactions.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        thickness: 0.8,
                        indent: 72,
                        endIndent: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                      itemBuilder: (context, index) {
                        final transaction = _filteredTransactions[index];
                        return HistoryItemTile(
                          transaction: transaction,
                          isGrouped: true,
                          onTap: () {
                            context.pushNamed(
                              AppRouter.requestDetails,
                              extra: transaction,
                            );
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 12),
                if ((_filter?.hasActiveFilters ?? false) || _query.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "All matching transactions displayed",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                  )
                else
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Showing recent 30-day activity",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.scrim,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
