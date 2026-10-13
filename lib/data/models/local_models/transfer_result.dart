class TransferResult {
  final String recipientName;
  final String recipientAccountNumber;
  final String recipientBank;
  final String sourceBank;
  final String sourceAccountNumber;
  final double amount;
  final String note;
  final double fee;
  final DateTime date;
  final String transactionReference;
  final String providerReference;

  const TransferResult({
    required this.recipientName,
    required this.recipientAccountNumber,
    required this.recipientBank,
    required this.sourceBank,
    required this.sourceAccountNumber,
    required this.amount,
    required this.note,
    required this.fee,
    required this.date,
    required this.transactionReference,
    required this.providerReference,
  });

  TransferResult copyWith({
    String? recipientName,
    String? recipientAccountNumber,
    String? recipientBank,
    String? sourceBank,
    String? sourceAccountNumber,
    double? amount,
    String? note,
    double? fee,
  }) {
    return TransferResult(
      recipientName: recipientName ?? this.recipientName,
      recipientAccountNumber:
          recipientAccountNumber ?? this.recipientAccountNumber,
      recipientBank: recipientBank ?? this.recipientBank,
      sourceBank: sourceBank ?? this.sourceBank,
      sourceAccountNumber: sourceAccountNumber ?? this.sourceAccountNumber,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      fee: fee ?? this.fee,
      date: date,
      transactionReference: transactionReference,
      providerReference: providerReference,
    );
  }
}
