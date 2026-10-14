import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplitBillItem {
  final String id;
  final String title;
  final double totalAmount;
  final String date;
  final int participantsCount;
  final int paidCount;
  final String status;

  const SplitBillItem({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.date,
    required this.participantsCount,
    required this.paidCount,
    this.status = "Active",
  });

  double get progress => participantsCount > 0 ? (paidCount / participantsCount) : 0.0;
}

class SplitBillState {
  final List<SplitBillItem> bills;
  final bool isLoading;

  const SplitBillState({
    required this.bills,
    this.isLoading = false,
  });

  SplitBillState copyWith({
    List<SplitBillItem>? bills,
    bool? isLoading,
  }) {
    return SplitBillState(
      bills: bills ?? this.bills,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SplitBillNotifier extends StateNotifier<SplitBillState> {
  SplitBillNotifier()
      : super(
          const SplitBillState(
            bills: [
              SplitBillItem(
                id: "sb_1",
                title: "Lola's Birthday Dinner",
                totalAmount: 500000.0,
                date: "18 Apr 2026",
                participantsCount: 5,
                paidCount: 4,
                status: "Active",
              ),
              SplitBillItem(
                id: "sb_2",
                title: "Dubai Trip 2026",
                totalAmount: 1200000.0,
                date: "15 Apr 2026",
                participantsCount: 6,
                paidCount: 6,
                status: "Completed",
              ),
              SplitBillItem(
                id: "sb_3",
                title: "August shopping",
                totalAmount: 250000.0,
                date: "10 Apr 2026",
                participantsCount: 3,
                paidCount: 1,
                status: "Active",
              ),
            ],
          ),
        );

  void addBill(SplitBillItem bill) {
    state = state.copyWith(bills: [bill, ...state.bills]);
  }
}

final splitBillProvider =
    StateNotifierProvider<SplitBillNotifier, SplitBillState>((ref) {
  return SplitBillNotifier();
});
