import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';

class HistoryState {
  final List<TransactionHistoryModel> transactions;
  final bool isLoading;

  const HistoryState({
    required this.transactions,
    this.isLoading = false,
  });

  HistoryState copyWith({
    List<TransactionHistoryModel>? transactions,
    bool? isLoading,
  }) {
    return HistoryState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier()
      : super(
          HistoryState(
            transactions: TransactionHistoryModel.mockList(),
          ),
        );

  void addTransaction(TransactionHistoryModel transaction) {
    state = state.copyWith(transactions: [transaction, ...state.transactions]);
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier();
});
