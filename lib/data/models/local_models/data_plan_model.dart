enum DataPlanCategory { hotDeals, daily, weekly, monthly }

class DataPlanModel {
  final String duration;
  final String price;
  final String data;
  final String cashback;
  final DataPlanCategory category;

  const DataPlanModel({
    required this.duration,
    required this.price,
    required this.data,
    required this.cashback,
    required this.category,
  });

  static List<DataPlanModel> plansForNetwork(String networkName) {
    return [
      DataPlanModel(
        duration: "1GB - 1 Day",
        price: "₦200",
        data: "2GB",
        cashback: "₦17.5 Cashback",
        category: DataPlanCategory.hotDeals,
      ),
      DataPlanModel(
        duration: "2.5GB - 7 Days",
        price: "₦900",
        data: "3GB",
        cashback: "₦17.5 Cashback",
        category: DataPlanCategory.hotDeals,
      ),
      DataPlanModel(
        duration: "3.5GB - 7 Days",
        price: "₦1,500",
        data: "2GB",
        cashback: "₦17.5 Cashback",
        category: DataPlanCategory.hotDeals,
      ),
      DataPlanModel(
        duration: "8GB - 30 Days",
        price: "₦2,000",
        data: "10GB",
        cashback: "₦17.5 Cashback",
        category: DataPlanCategory.hotDeals,
      ),
      DataPlanModel(
        duration: "10GB - 1 Day",
        price: "₦2,500",
        data: "12GB",
        cashback: "₦17.5 Cashback",
        category: DataPlanCategory.hotDeals,
      ),
      DataPlanModel(
        duration: "1GB - 1 Day",
        price: "₦3,000",
        data: "20GB",
        cashback: "₦17.5 Cashback",
        category: DataPlanCategory.hotDeals,
      ),
    ];
  }

  static List<DataPlanModel> fullListForNetwork(String networkName) {
    return [
      DataPlanModel(
        duration: "$networkName ₦25 20MB - (24 Hours)",
        price: "₦25",
        data: "20MB",
        cashback: "",
        category: DataPlanCategory.daily,
      ),
      DataPlanModel(
        duration: "$networkName ₦250 300MB - (7 Days)",
        price: "₦250",
        data: "300MB",
        cashback: "",
        category: DataPlanCategory.weekly,
      ),
      DataPlanModel(
        duration: "$networkName ₦25 20MB - (24 Hours)",
        price: "₦25",
        data: "20MB",
        cashback: "",
        category: DataPlanCategory.daily,
      ),
      DataPlanModel(
        duration: "$networkName ₦250 300MB - (7 Days)",
        price: "₦250",
        data: "300MB",
        cashback: "",
        category: DataPlanCategory.weekly,
      ),
      DataPlanModel(
        duration: "$networkName ₦25 20MB - (24 Hours)",
        price: "₦25",
        data: "20MB",
        cashback: "",
        category: DataPlanCategory.daily,
      ),
      DataPlanModel(
        duration: "$networkName ₦25 20MB - (24 Hours)",
        price: "₦25",
        data: "20MB",
        cashback: "",
        category: DataPlanCategory.daily,
      ),
    ];
  }
}

extension DataPlanCategoryLabel on DataPlanCategory {
  String get label {
    switch (this) {
      case DataPlanCategory.hotDeals:
        return "Hot Deals";
      case DataPlanCategory.daily:
        return "Daily";
      case DataPlanCategory.weekly:
        return "Weekly";
      case DataPlanCategory.monthly:
        return "Monthly";
    }
  }
}
