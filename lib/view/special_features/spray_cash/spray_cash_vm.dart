import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/data.dart';

class SprayCashNotifier extends ChangeNotifier {
  int _currentStep = 0;
  int get currentStep => _currentStep;

  String get currentTitle => _titles[_currentStep];
  double get progress => (_currentStep + 1) / _titles.length;

  final List<SprayRecipientType> _sprayRecipientTypes =
      SprayRecipientType.sprayRecipientTypes;
  List<SprayRecipientType> get sprayRecipientTypes => _sprayRecipientTypes;

  SprayRecipientType? _selectedRecipientType;
  SprayRecipientType? get selectedRecipientType => _selectedRecipientType;

  final List<SprayCurrencyType> _sprayCurrencyTypes =
      SprayCurrencyType.sprayCurrencyTypes;
  List<SprayCurrencyType> get sprayCurrencyTypes => _sprayCurrencyTypes;

  SprayCurrencyType? _selectedCurrencyType;
  SprayCurrencyType? get selectedCurrencyType => _selectedCurrencyType;

  final List<int> _sprayDenomications = [100, 200, 500, 1000];
  List<int> get sprayDenomications => _sprayDenomications;

  int? _selectedDenomination;
  int? get selectedDenomination => _selectedDenomination;

  final List<String> _sprayAnimations = [
    "Flying Cash Effect",
    "Money Gun Effect",
    "Confetti Effect",
    "Golden Glow Effect",
    "Fireworks Effect",
  ];
  List<String> get sprayAnimations => _sprayAnimations;

  String? _selectedAnimation;
  String? get selectedAnimation => _selectedAnimation;

  final List<String> _titles = [
    'Spray',
    'Select Currency',
    'Select Denomination',
    'Select Animation',
    'Choose Recipient',
    'Choose Recipient',
    'Choose Recipient',
  ];

  bool _isAutoSprayMode = false;
  bool get isAutoSprayMode => _isAutoSprayMode;

  String _amount = "";
  String get amount => _amount;

  void updateAmount(String newAmount) {
    _amount = newAmount;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < _titles.length - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _clearDataForStep(_currentStep);
      notifyListeners();
    }
  }

  void _clearDataForStep(int step) {
    switch (step) {
      case 0:
        _selectedRecipientType = null;
        break;
      case 1:
        _selectedCurrencyType = null;
        break;
      case 2:
        _selectedDenomination = null;
        break;
      case 3:
        _selectedAnimation = null;
        break;
      case 4:
      case 5:
      case 6:
        break;
    }
  }

  void selectSprayRecipientType({required String id}) {
    try {
      _selectedRecipientType = _sprayRecipientTypes.firstWhere(
        (sprayType) => sprayType.id == id,
      );
      if (_selectedRecipientType != null) {
        _currentStep = 1;
        notifyListeners();
      }
    } catch (_) {
      _selectedRecipientType = null;
    }
  }

  void selectSprayCurrencyType({required String id}) {
    try {
      _selectedCurrencyType = _sprayCurrencyTypes.firstWhere(
        (sprayCurrency) => sprayCurrency.id == id,
      );
      if (_selectedCurrencyType != null) {
        _currentStep = 2;
        notifyListeners();
      }
    } catch (_) {
      _selectedCurrencyType = null;
    }
  }

  void selectDenomination({required int newDenomination}) {
    _selectedDenomination = newDenomination;
    _currentStep = 3;
    notifyListeners();
  }

  void selectAnimation({required String newAnimation}) {
    _selectedAnimation = newAnimation;
    _currentStep = 4;
    notifyListeners();
  }

  void updateAutoSprayMode({required bool newMode}) {
    _isAutoSprayMode = newMode;
    notifyListeners();
  }

  void goToSelectRecipient() {
    _currentStep = 5;
    notifyListeners();
  }

  void init() {
    _currentStep = 0;
    _selectedRecipientType = null;
    _selectedCurrencyType = null;
    _selectedDenomination = null;
    _selectedAnimation = null;
    _isAutoSprayMode = false;
    _amount = "";
  }
}

final sprayCashVm = ChangeNotifierProvider<SprayCashNotifier>((ref) {
  return SprayCashNotifier();
});
