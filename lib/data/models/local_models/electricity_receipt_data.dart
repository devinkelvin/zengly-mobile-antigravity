class ElectricityReceiptData {
  final String distributionCompany;
  final String meterNumber;
  final String customerName;
  final String serviceAddress;
  final String purchaseType;
  final String unitsPurchased;
  final String token;
  final String amount;
  final String date;
  final String transactionId;

  const ElectricityReceiptData({
    required this.distributionCompany,
    required this.meterNumber,
    required this.customerName,
    required this.serviceAddress,
    required this.purchaseType,
    required this.unitsPurchased,
    required this.token,
    required this.amount,
    required this.date,
    required this.transactionId,
  });
}
