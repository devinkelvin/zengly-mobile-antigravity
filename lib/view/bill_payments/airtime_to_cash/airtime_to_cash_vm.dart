import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';
import '../../view.dart';

class AirtimeToCashNotifier extends ChangeNotifier {
  final networks = NetworkModel.networkModels;
  NetworkModel _selectedNetwork = NetworkModel.networkModels.first;
  NetworkModel get selectedNetwork => _selectedNetwork;

  static const Map<String, double> _carrierRates = {
    "MTN": 0.85,
    "AIRTEL": 0.82,
    "GLO": 0.78,
    "9MOBILE": 0.75,
  };

  double get currentRate =>
      _carrierRates[_selectedNetwork.name.toUpperCase()] ?? 0.80;

  double getRateFor(String networkName) =>
      _carrierRates[networkName.toUpperCase()] ?? 0.80;

  void selectNetwork(NetworkModel network) {
    _selectedNetwork = network;
    notifyListeners();
  }

  double receivableAmount(String amount) {
    final value = double.tryParse(amount.replaceAll(',', '')) ?? 0;
    return value * currentRate;
  }

  double feeAmount(String amount) {
    final value = double.tryParse(amount.replaceAll(',', '')) ?? 0;
    return value * (1.0 - currentRate);
  }

  void startConversion({
    required BuildContext context,
    required String phone,
    required String amount,
    required String sharePin,
  }) async {
    if (phone.isEmpty) {
      AppOverlays.showToast(
        context: context,
        message: "Enter a valid phone number",
        toastType: ToastificationType.error,
      );
      return;
    }
    final rawAmt = double.tryParse(amount.replaceAll(',', '')) ?? 0;
    if (rawAmt < 500) {
      AppOverlays.showToast(
        context: context,
        message: "Minimum airtime conversion is ₦500.00",
        toastType: ToastificationType.error,
      );
      return;
    }
    if (sharePin.length < 4) {
      AppOverlays.showToast(
        context: context,
        message: "Enter your 4-digit ${_selectedNetwork.name} Share PIN",
        toastType: ToastificationType.error,
      );
      return;
    }

    // Step 1: Transaction PIN verification
    final pin = await context.push(AppRouter.enterTransactionPin);
    if (pin == null || !context.mounted) return;

    // Step 2: OTP Bottom Sheet
    final otpController = TextEditingController();
    AppOverlays.otpBottomSheet(
      context: context,
      controller: otpController,
      length: 6,
      seconds: 30,
      channel: OtpChannel.phone,
      maskedTarget: phone,
      onVerify: () async {
        if (otpController.text.length != 6) {
          AppOverlays.showToast(
            context: context,
            message: "Enter the 6-digit OTP sent to your phone",
            toastType: ToastificationType.error,
          );
          return;
        }
        context.pop(); // close OTP modal

        AppOverlays.showLoadingDialog(context: context);
        await Future.delayed(const Duration(seconds: 2));
        if (!context.mounted) return;
        context.pop(); // close loader

        final credited = receivableAmount(amount);
        final now = DateTime.now();
        final refId = "A2C-${now.millisecondsSinceEpoch}";

        // Show Success bottom sheet with action to view dashboard or receipt
        AppOverlays.bottomSheet(
          context: context,
          isSuccess: true,
          action: () => context.goNamed(AppRouter.dashboard),
          title: "Airtime Converted Successfully!",
          content:
              "₦${NumberFormat("#,##0.00").format(credited)} has been credited instantly to your Zengly wallet balance. Ref: $refId",
        );
      },
    );
  }
}

final airtimeToCashVm = ChangeNotifierProvider<AirtimeToCashNotifier>((ref) {
  return AirtimeToCashNotifier();
});
