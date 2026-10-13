import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/data.dart';

class ElectricityNotifier extends ChangeNotifier {
  ElectricityType? _selectedElectricityType;
  ElectricityType? get selectedElectricityType => _selectedElectricityType;

  void selectElectricityType(ElectricityType type) {
    _selectedElectricityType = type;
    notifyListeners();
  }
}

final electricityVm = ChangeNotifierProvider<ElectricityNotifier>((ref) {
  return ElectricityNotifier();
});
