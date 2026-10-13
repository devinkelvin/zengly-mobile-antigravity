import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_response.dart';
import '../../features/kyc/data/models/kyc_status_model.dart';
import '../../features/kyc/data/services/kyc_service.dart';

class HomeNotifier extends ChangeNotifier {
  final KycService _kycService = KycService();
  KycStatusModel? _userKycStatus;
  KycStatusModel? get userKycStatus => _userKycStatus;
  bool _showKycButton = false;
  bool get showKycButton => _showKycButton;
  bool _hasError = false;
  bool get hasError => _hasError;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getUserKycStatus() async {
    _hasError = false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _kycService.getKycStatus();
    switch (response) {
      case ApiSuccess(data: final data):
        _userKycStatus = data;
        if (data.overallStatus != "VERIFIED") {
          _showKycButton = true;
        }
      case ApiError(message: final message):
        _hasError = true;
        _errorMessage = message;
    }
    _isLoading = false;
    notifyListeners();
  }
}

final homeVm = ChangeNotifierProvider<HomeNotifier>((ref) {
  return HomeNotifier();
});
