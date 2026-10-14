import '../../../data/app_images.dart';

enum TransactionStatus { successful, pending, failed, reversed }

enum TransactionCategory {
  walletTopup,
  serviceRequest,
  electricityPayment,
  transfer,
  walletReversal,
  airtime,
  data,
  sprayCash,
  tvSubscription,
}

extension TransactionCategoryLabel on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.walletTopup:
        return "Wallet Top-up";
      case TransactionCategory.serviceRequest:
        return "Service Request";
      case TransactionCategory.electricityPayment:
        return "Electricity Payment";
      case TransactionCategory.transfer:
        return "Transfer";
      case TransactionCategory.walletReversal:
        return "Wallet Reversal";
      case TransactionCategory.airtime:
        return "Airtime Top-up";
      case TransactionCategory.data:
        return "Data Bundle";
      case TransactionCategory.sprayCash:
        return "Vaniti Spray Cash";
      case TransactionCategory.tvSubscription:
        return "TV & Cable";
    }
  }

  String get imagePath {
    switch (this) {
      case TransactionCategory.walletTopup:
        return AppImages.txCryptoWallet;
      case TransactionCategory.serviceRequest:
        return AppImages.txLightbulb;
      case TransactionCategory.electricityPayment:
        return AppImages.txLightbulb;
      case TransactionCategory.transfer:
        return AppImages.txTransfer;
      case TransactionCategory.walletReversal:
        return AppImages.txWalletReversal;
      case TransactionCategory.airtime:
        return AppImages.txPinFlag;
      case TransactionCategory.data:
        return AppImages.txPinFlag;
      case TransactionCategory.sprayCash:
        return AppImages.goldMoneyBag;
      case TransactionCategory.tvSubscription:
        return AppImages.txLightbulb;
    }
  }
}

extension TransactionStatusLabel on TransactionStatus {
  String get label {
    switch (this) {
      case TransactionStatus.successful:
        return "Successful";
      case TransactionStatus.pending:
        return "Pending";
      case TransactionStatus.failed:
        return "Failed";
      case TransactionStatus.reversed:
        return "Reversed";
    }
  }
}

class TransactionHistoryModel {
  final String title;
  final String date;
  final double amount;
  final bool isCredit;
  final TransactionStatus status;
  final TransactionCategory category;
  final String? recipient;
  final String? bank;

  const TransactionHistoryModel({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.status,
    required this.category,
    this.recipient,
    this.bank,
  });

  String get displayImage => category.imagePath;

  static List<TransactionHistoryModel> mockList() {
    return [
      const TransactionHistoryModel(
        title: "Transfer to Tiwa Savage",
        date: "Today, 10:45 AM",
        amount: 50000,
        isCredit: false,
        status: TransactionStatus.successful,
        category: TransactionCategory.transfer,
        recipient: "Tiwa Savage",
        bank: "Zengly Wallet",
      ),
      const TransactionHistoryModel(
        title: "Vaniti Spray: Baller Stack",
        date: "Today, 09:12 AM",
        amount: 100000,
        isCredit: false,
        status: TransactionStatus.successful,
        category: TransactionCategory.sprayCash,
        recipient: "@tiwasavage",
      ),
      const TransactionHistoryModel(
        title: "Salary / Dividend Inflow",
        date: "Yesterday, 04:30 PM",
        amount: 850000,
        isCredit: true,
        status: TransactionStatus.successful,
        category: TransactionCategory.walletTopup,
        recipient: "Acme Holdings PLC",
        bank: "Zengly Vault",
      ),
      const TransactionHistoryModel(
        title: "MTN 10GB Monthly Data",
        date: "Yesterday, 01:15 PM",
        amount: 3500,
        isCredit: false,
        status: TransactionStatus.successful,
        category: TransactionCategory.data,
        recipient: "08031234567",
      ),
      const TransactionHistoryModel(
        title: "IKEDC Prepaid Token Recharge",
        date: "12 Oct 2026, 06:20 PM",
        amount: 25000,
        isCredit: false,
        status: TransactionStatus.successful,
        category: TransactionCategory.electricityPayment,
        recipient: "Meter 04182910291",
      ),
      const TransactionHistoryModel(
        title: "Transfer from Chidi Okafor",
        date: "11 Oct 2026, 08:45 PM",
        amount: 75000,
        isCredit: true,
        status: TransactionStatus.successful,
        category: TransactionCategory.transfer,
        recipient: "Chidi Okafor",
        bank: "Access Bank",
      ),
      const TransactionHistoryModel(
        title: "Airtel Quick Recharge",
        date: "10 Oct 2026, 11:02 AM",
        amount: 2000,
        isCredit: false,
        status: TransactionStatus.successful,
        category: TransactionCategory.airtime,
        recipient: "08029876543",
      ),
      const TransactionHistoryModel(
        title: "Interbank Transfer Reversal",
        date: "09 Oct 2026, 02:18 PM",
        amount: 15000,
        isCredit: true,
        status: TransactionStatus.reversed,
        category: TransactionCategory.walletReversal,
        recipient: "Auto Reversal Engine",
      ),
      const TransactionHistoryModel(
        title: "Transfer to Adebayo Adeleke",
        date: "08 Oct 2026, 05:40 PM",
        amount: 120000,
        isCredit: false,
        status: TransactionStatus.pending,
        category: TransactionCategory.transfer,
        recipient: "Adebayo Adeleke",
        bank: "GTBank",
      ),
      const TransactionHistoryModel(
        title: "DStv Premium Bouquet Renewal",
        date: "05 Oct 2026, 10:30 AM",
        amount: 37000,
        isCredit: false,
        status: TransactionStatus.successful,
        category: TransactionCategory.tvSubscription,
        recipient: "Smartcard 1029384756",
      ),
    ];
  }
}
