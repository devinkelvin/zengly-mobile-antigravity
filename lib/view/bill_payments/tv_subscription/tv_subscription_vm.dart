import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/data.dart';

class TvSubscriptionNotifier extends ChangeNotifier {
  final tvProviders = TvProviderModel.tvProviderModels;
  TvProviderModel? _selectedProvider;
  TvProviderModel? get selectedProvider => _selectedProvider;

  void updateTvProvider({required int index}) {
    _selectedProvider = tvProviders[index];
    notifyListeners();
  }

  void initialize() {
    _selectedProvider = null;
  }
}

final tvSubscriptionVm = ChangeNotifierProvider<TvSubscriptionNotifier>((ref) {
  return TvSubscriptionNotifier();
});
