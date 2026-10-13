class PurchaseReceiptData {
  final String type;
  final String amount;
  final String phoneNumber;
  final String paymentMethod;
  final String transactionDate;
  final String transactionReference;
  final String providerReference;
  final String? cashback;
  final String? planLabel;

  const PurchaseReceiptData({
    required this.type,
    required this.amount,
    required this.phoneNumber,
    this.paymentMethod = "Wallet Balance",
    required this.transactionDate,
    required this.transactionReference,
    required this.providerReference,
    this.cashback,
    this.planLabel,
  });
}
