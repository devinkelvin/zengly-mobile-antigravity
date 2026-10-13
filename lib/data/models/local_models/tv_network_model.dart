import '../../data.dart';

class TvProviderModel {
  final String name, image;
  final List<TvPlanModel> plans;
  TvProviderModel({
    required this.name,
    required this.image,
    required this.plans,
  });

  static final List<TvProviderModel> _tvProviderModels = [
    TvProviderModel(
      name: "DSTV",
      image: AppImages.dstv,
      plans: [
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
        TvPlanModel(name: "Padi", duration: "1 month", price: 4400),
      ],
    ),
    TvProviderModel(
      name: "GOTV",
      image: AppImages.gotv,
      plans: [
        TvPlanModel(name: "Jinja", duration: "1 month", price: 4400),
        TvPlanModel(name: "Jinja", duration: "1 month", price: 4400),
        TvPlanModel(name: "Jinja", duration: "1 month", price: 4400),
        TvPlanModel(name: "Jinja", duration: "1 month", price: 4400),
        TvPlanModel(name: "Jinja", duration: "1 month", price: 4400),
        TvPlanModel(name: "Jinja", duration: "1 month", price: 4400),
      ],
    ),
    TvProviderModel(
      name: "STARTIMES",
      image: AppImages.starTimes,
      plans: [
        TvPlanModel(name: "Classic", duration: "1 month", price: 4400),
        TvPlanModel(name: "Classic", duration: "1 month", price: 4400),
        TvPlanModel(name: "Classic", duration: "1 month", price: 4400),
        TvPlanModel(name: "Classic", duration: "1 month", price: 4400),
        TvPlanModel(name: "Classic", duration: "1 month", price: 4400),
        TvPlanModel(name: "Classic", duration: "1 month", price: 4400),
      ],
    ),
    TvProviderModel(
      name: "SHOWMAX",
      image: AppImages.showMax,
      plans: [
        TvPlanModel(name: "Showtown", duration: "1 month", price: 4400),
        TvPlanModel(name: "Showtown", duration: "1 month", price: 4400),
        TvPlanModel(name: "Showtown", duration: "1 month", price: 4400),
        TvPlanModel(name: "Showtown", duration: "1 month", price: 4400),
        TvPlanModel(name: "Showtown", duration: "1 month", price: 4400),
        TvPlanModel(name: "Showtown", duration: "1 month", price: 4400),
      ],
    ),
  ];

  static List<TvProviderModel> get tvProviderModels => _tvProviderModels;
}

class TvPlanModel {
  final String name;
  final String duration;
  final double price;

  TvPlanModel({
    required this.name,
    required this.duration,
    required this.price,
  });
}
