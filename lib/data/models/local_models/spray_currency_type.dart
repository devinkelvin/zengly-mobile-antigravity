import '../../data.dart';

class SprayCurrencyType {
  final String id, image, name, symbol;
  SprayCurrencyType({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
  });

  static final List<SprayCurrencyType> _sprayCurrencyTypes = [
    SprayCurrencyType(
      id: "ngn",
      name: "Nigerian Naira",
      symbol: "NGN",
      image: AppImages.nigerianFlag,
    ),
    SprayCurrencyType(
      id: "usd",
      name: " US Dollar",
      symbol: "USD",
      image: AppImages.usaFlag,
    ),
    SprayCurrencyType(
      id: "zengly_coins",
      name: "Zengly Coins",
      symbol: "",
      image: AppImages.checkMark,
    ),
    SprayCurrencyType(
      id: "gbp",
      name: "British Pound",
      symbol: "GBP",
      image: AppImages.ukFlag,
    ),
  ];
  static List<SprayCurrencyType> get sprayCurrencyTypes => _sprayCurrencyTypes;
}
