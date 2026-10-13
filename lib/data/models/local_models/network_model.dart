import '../../data.dart';

class NetworkModel {
  final String name, image;
  NetworkModel({required this.name, required this.image});

  static final List<NetworkModel> _networkModels = [
    NetworkModel(name: "MTN", image: AppImages.mtn),
    NetworkModel(name: "GLO", image: AppImages.glo),
    NetworkModel(name: "AIRTEL", image: AppImages.airtel),
    NetworkModel(name: "9MOBILE", image: AppImages.nineMobile),
  ];

  static List<NetworkModel> get networkModels => _networkModels;
}
