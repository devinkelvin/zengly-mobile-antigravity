import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view.dart';

class DashboardNotifier extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<Widget> _pages = [
    const HomeScreen(),
    const PreTransferScreen(),
    const PreSpecialFeaturesScreen(),
    InsightScreen(),
    AccountScreen(),
  ];
  List<Widget> get pages => _pages;

  void switchPage(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}

final dashboardVm = ChangeNotifierProvider<DashboardNotifier>((ref) {
  return DashboardNotifier();
});
