import '../../data.dart';

class GiftCardChoiceModel {
  final String? name;
  final String? image;
  final String? amount;
  final String id;

  GiftCardChoiceModel({this.name, required this.id, this.image, this.amount});

  static final List<GiftCardChoiceModel> _countryOptions = [
    GiftCardChoiceModel(name: "Canada", id: "1", image: AppImages.canadaFlag),
    GiftCardChoiceModel(name: "France", id: "2", image: AppImages.franceFlag),
    GiftCardChoiceModel(name: "Germany", id: "3", image: AppImages.germanyFlag),
    GiftCardChoiceModel(name: "Ireland", id: "4", image: AppImages.irelandFlag),
    GiftCardChoiceModel(name: "Italy", id: "5", image: AppImages.italyFlag),
    GiftCardChoiceModel(
      name: "United Kingdom",
      id: "6",
      image: AppImages.ukFlag,
    ),
    GiftCardChoiceModel(
      name: "United States of America",
      id: "7",
      image: AppImages.usaFlag,
    ),
  ];
  static List<GiftCardChoiceModel> get countryOptions => _countryOptions;

  static final List<GiftCardChoiceModel> _giftcardOptions = [
    GiftCardChoiceModel(name: "Amazon", id: "1", image: AppImages.canadaFlag),
    GiftCardChoiceModel(name: "Apple", id: "2", image: AppImages.franceFlag),
    GiftCardChoiceModel(name: "Itunes", id: "3", image: AppImages.germanyFlag),
    GiftCardChoiceModel(name: "Ardene", id: "4", image: AppImages.irelandFlag),
    GiftCardChoiceModel(name: "Addidas", id: "5", image: AppImages.italyFlag),
    GiftCardChoiceModel(name: "Argos", id: "6", image: AppImages.ukFlag),
    GiftCardChoiceModel(name: "Crypto", id: "7", image: AppImages.usaFlag),
  ];
  static List<GiftCardChoiceModel> get giftcardOptions => _giftcardOptions;

  static final List<GiftCardChoiceModel> _giftcardAmountOptions = [
    GiftCardChoiceModel(id: "1", amount: "\$5.00 (₦9,415.00)"),
    GiftCardChoiceModel(id: "2", amount: "\$10.00 (₦9,415.00)"),
    GiftCardChoiceModel(id: "3", amount: "\$15.00 (₦9,415.00)"),
    GiftCardChoiceModel(id: "4", amount: "\$20.00 (₦9,415.00)"),
    GiftCardChoiceModel(id: "5", amount: "\$25.00 (₦9,415.00)"),
    GiftCardChoiceModel(id: "6", amount: "\$30.00 (₦9,415.00)"),
    GiftCardChoiceModel(id: "7", amount: "\$35.00 (₦9,415.00)"),
    GiftCardChoiceModel(id: "8", amount: "\$40.00 (₦9,415.00)"),
  ];
  static List<GiftCardChoiceModel> get giftcardAmountOptions =>
      _giftcardAmountOptions;
}
