import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';

class OnboardingNotifier extends ChangeNotifier {
  final List<OnboardingModel> onboardingModelList = onboardingList;

  int _currentPage = 0;

  int get currentPage => _currentPage;

  void updateCurrentPage(int pageNumber) {
    _currentPage = pageNumber;
    notifyListeners();
  }
}

final onboardingVm = ChangeNotifierProvider<OnboardingNotifier>((ref) {
  return OnboardingNotifier();
});
