import '../../../data/app_images.dart';

enum TransactionStatus { successful, pending, failed, reversed }

enum TransactionCategory {
  walletTopup,
  serviceRequest,
  electricityPayment,
  transfer,
  walletReversal,
}

extension TransactionCategoryLabel on TransactionCategory {
  String get label {
    switch (this) {
      case TransactionCategory.walletTopup:
        return "Wallet Topup";
      case TransactionCategory.serviceRequest:
        return "Service Request";
      case TransactionCategory.electricityPayment:
        return "Electricity Payment";
      case TransactionCategory.transfer:
        return "Transfer";
      case TransactionCategory.walletReversal:
        return "Wallet Reversal";
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

  const TransactionHistoryModel({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.status,
    required this.category,
  });

  String get displayImage => category.imagePath;

  static List<TransactionHistoryModel> mockList() {
    return [
      TransactionHistoryModel(
        title: "Airtime Recharge",
        date: "25 Nov 2024, 10:45:23 pm",
        amount: 45200,
        isCredit: false,
        status: TransactionStatus.successful,
        category: TransactionCategory.serviceRequest,
      ),
      TransactionHistoryModel(
        title: "Wallet Top-up",
        date: "25 Nov 2024, 10:45:23 pm",
        amount: 56500,
        isCredit: true,
        status: TransactionStatus.successful,
        category: TransactionCategory.walletTopup,
      ),
      TransactionHistoryModel(
        title: "Electricity Payment",
        date: "25 Nov 2024, 10:45:23 pm",
        amount: 33000,
        isCredit: false,
        status: TransactionStatus.successful,
        category: TransactionCategory.electricityPayment,
      ),
      TransactionHistoryModel(
        title: "Salary Credit",
        date: "25 Nov 2024, 10:45:23 pm",
        amount: 33000,
        isCredit: true,
        status: TransactionStatus.successful,
        category: TransactionCategory.serviceRequest,
      ),
      TransactionHistoryModel(
        title: "Transfer to Chidi",
        date: "25 Nov 2024, 10:45:23 pm",
        amount: 50000,
        isCredit: false,
        status: TransactionStatus.pending,
        category: TransactionCategory.transfer,
      ),
      TransactionHistoryModel(
        title: "Service Request",
        date: "25 Nov 2024, 10:45:23 pm",
        amount: 50000,
        isCredit: false,
        status: TransactionStatus.successful,
        category: TransactionCategory.serviceRequest,
      ),
      TransactionHistoryModel(
        title: "Wallet Reversal",
        date: "25 Nov 2024, 10:45:23 pm",
        amount: 56500,
        isCredit: true,
        status: TransactionStatus.successful,
        category: TransactionCategory.walletReversal,
      ),
      TransactionHistoryModel(
        title: "Electricity Payment",
        date: "25 Nov 2024, 10:45:23 pm",
        amount: 56500,
        isCredit: false,
        status: TransactionStatus.failed,
        category: TransactionCategory.electricityPayment,
      ),
    ];
  }
}
