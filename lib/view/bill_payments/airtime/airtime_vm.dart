import 'package:flutter/material.dart';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class AirtimeNotifier extends ChangeNotifier {
  final networks = NetworkModel.networkModels;
  NetworkModel? _selectedNetwork;
  NetworkModel? get selectedNetwork => _selectedNetwork;

  Function? _updatePhone;

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  void initalizeNetwork() {
    _selectedNetwork = networks[0];
  }

  void initalizeFunction({required Function updatePhone}) {
    _updatePhone = updatePhone;
  }

  void openBottomSheet({required BuildContext context}) {
    AppOverlays.networkSheet(context: context);
  }

  void updateNetworkModel({required int index}) {
    _selectedNetwork = networks[index];
    notifyListeners();
  }

  void selectNetworkByName(String name) {
    final idx = networks.indexWhere(
      (n) => n.name.toUpperCase() == name.toUpperCase(),
    );
    if (idx != -1) {
      _selectedNetwork = networks[idx];
      notifyListeners();
    }
  }

  Future<void> getContacts() async {
    try {
      if (await FlutterContacts.requestPermission(readonly: true)) {
        _contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  String? _normalizeNigerianPhoneNumber(String input) {
    // Remove any spaces, dashes, or parentheses
    String number = input.replaceAll(RegExp(r'[^\d+]'), '');

    // Remove +234 and replace with 0
    if (number.startsWith('+234')) {
      number = number.replaceFirst('+234', '0');
    } else if (number.startsWith('234')) {
      number = number.replaceFirst('234', '0');
    }

    // Ensure it starts with 0 and has 11 digits
    if (number.startsWith('0') && number.length == 11) {
      return number;
    }

    return null; // Invalid format
  }

  void updatePhoneNumber({
    required String number,
    required BuildContext context,
  }) {
    // print(_phoneController.text);
    final actualNumber = _normalizeNigerianPhoneNumber(number);
    if (actualNumber == null) {
      AppOverlays.showToast(
        context: context,
        message: "Phone number is not a valid nigerian number",
        toastType: ToastificationType.error,
      );
      return;
    }
    // print(_phoneController.text);
    // _phoneController.text = actualNumber;
    if (_updatePhone != null) {
      _updatePhone!(actualNumber);
    }

    context.pop();
  }

  void startPurchase({
    required BuildContext context,
    required String type,
    required String amount,
    required String phoneNumber,
    String? planLabel,
    String? cashback,
  }) {
    if (phoneNumber.isEmpty) {
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
    context.push(AppRouter.enterTransactionPin).then((pin) {
      if (pin == null || !context.mounted) return;
      _processPurchase(
        context: context,
        type: type,
        amount: amount,
        phoneNumber: phoneNumber,
        planLabel: planLabel,
        cashback: cashback,
      );
    });
  }

  Future<void> _processPurchase({
    required BuildContext context,
    required String type,
    required String amount,
    required String phoneNumber,
    String? planLabel,
    String? cashback,
  }) async {
    AppOverlays.showLoadingDialog(context: context);
    await Future.delayed(const Duration(seconds: 2));
    if (!context.mounted) return;
    context.pop();

    final now = DateTime.now();
    final reference = "260225${now.millisecondsSinceEpoch}";
    context.goNamed(
      AppRouter.purchaseSuccess,
      extra: PurchaseReceiptData(
        type: type,
        amount: amount,
        phoneNumber: phoneNumber,
        transactionDate: DateFormat("EEEE, d MMMM y").format(now),
        transactionReference: reference,
        providerReference: "TRF|$reference",
        cashback: cashback,
        planLabel: planLabel,
      ),
    );
  }
}

final airtimeVm = ChangeNotifierProvider<AirtimeNotifier>((ref) {
  return AirtimeNotifier();
});
