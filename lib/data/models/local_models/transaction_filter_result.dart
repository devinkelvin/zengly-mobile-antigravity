class TransactionFilterResult {
  final String? category;
  final String? status;
  final DateTime? startDate;
  final DateTime? endDate;

  const TransactionFilterResult({
    this.category,
    this.status,
    this.startDate,
    this.endDate,
  });

  bool get hasActiveFilters =>
      category != null || status != null || startDate != null || endDate != null;
}
