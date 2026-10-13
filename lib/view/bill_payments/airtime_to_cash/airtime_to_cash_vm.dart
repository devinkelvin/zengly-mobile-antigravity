import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class AirtimeToCashNotifier extends ChangeNotifier {
  final networks = NetworkModel.networkModels;
  NetworkModel _selectedNetwork = NetworkModel.networkModels.first;
  NetworkModel get selectedNetwork => _selectedNetwork;

  static const double conversionRate = 0.8;

  void selectNetwork(NetworkModel network) {
    _selectedNetwork = network;
    notifyListeners();
  }

  double receivableAmount(String amount) {
    final value = double.tryParse(amount.replaceAll(',', '')) ?? 0;
    return value * conversionRate;
  }

  void startConversion({
    required BuildContext context,
    required String phone,
    required String amount,
    required String sharePin,
  }) {
    if (phone.isEmpty) {
      AppOverlays.showToast(
        context: context,
        message: "Enter a valid phone number",
        toastType: ToastificationType.error,
      );
      return;
    }
    if (amount.isEmpty) {
      AppOverlays.showToast(
        context: context,
        message: "Enter an amount",
        toastType: ToastificationType.error,
      );
      return;
    }
    if (sharePin.isEmpty) {
      AppOverlays.showToast(
        context: context,
        message: "Enter your ${_selectedNetwork.name} Share PIN",
        toastType: ToastificationType.error,
      );
      return;
    }

    final otpController = TextEditingController();
    AppOverlays.otpBottomSheet(
      context: context,
      controller: otpController,
      length: 6,
      seconds: 32,
      channel: OtpChannel.phone,
      maskedTarget: phone,
      onVerify: () {
        if (otpController.text.length != 6) {
          AppOverlays.showToast(
            context: context,
            message: "Enter the 6-digit OTP to proceed",
            toastType: ToastificationType.error,
          );
          return;
        }
        context.pop();
        AppOverlays.bottomSheet(
          context: context,
          isSuccess: true,
          action: () => context.goNamed(AppRouter.dashboard),
          title: "Conversion successful!",
          content:
              "Your airtime has been converted to cash and credited to your wallet.",
        );
      },
    );
  }
}

final airtimeToCashVm = ChangeNotifierProvider<AirtimeToCashNotifier>((ref) {
  return AirtimeToCashNotifier();
});
