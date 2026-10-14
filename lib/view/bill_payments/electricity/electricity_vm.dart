import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/data.dart';

class ElectricityNotifier extends ChangeNotifier {
  ElectricityType _selectedElectricityType = ElectricityType.prepaid;
  ElectricityType get selectedElectricityType => _selectedElectricityType;

  String _selectedDisco = "Ikeja Electric (IKEDC)";
  String get selectedDisco => _selectedDisco;

  String _meterNumber = "04289104821";
  String get meterNumber => _meterNumber;

  String _customerName = "Kelvin Ekuhoho";
  String get customerName => _customerName;

  String _meterAddress = "14 Admiralty Way, Lekki Phase 1, Lagos";
  String get meterAddress => _meterAddress;

  String _amount = "10,000";
  String get amount => _amount;

  double get fee => 100.0;

  String _generatedToken = "4821 - 9032 - 1475 - 8291 - 0463";
  String get generatedToken => _generatedToken;

  String get estimatedUnits {
    final cleanAmt = double.tryParse(_amount.replaceAll(',', '')) ?? 0;
    if (cleanAmt <= 0) return "0.0 kWh";
    return "${(cleanAmt / 68.0).toStringAsFixed(1)} kWh";
  }

  void selectElectricityType(ElectricityType type) {
    _selectedElectricityType = type;
    notifyListeners();
  }

  void setDisco(String disco) {
    _selectedDisco = disco;
    notifyListeners();
  }

  void setTransactionDetails({
    required String disco,
    required String meterNumber,
    required String amount,
    String? customerName,
    String? address,
    ElectricityType? type,
  }) {
    _selectedDisco = disco;
    _meterNumber = meterNumber;
    _amount = amount;
    if (customerName != null) _customerName = customerName;
    if (address != null) _meterAddress = address;
    if (type != null) _selectedElectricityType = type;

    // Generate random realistic 20-digit STS token
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final p1 = (1000 + (now.hashCode % 8999)).abs().toString().padLeft(4, '0');
    final p2 = ((now.hashCode * 3) % 8999 + 1000).abs().toString().padLeft(4, '0');
    final p3 = ((now.hashCode * 7) % 8999 + 1000).abs().toString().padLeft(4, '0');
    final p4 = ((now.hashCode * 13) % 8999 + 1000).abs().toString().padLeft(4, '0');
    final p5 = ((now.hashCode * 17) % 8999 + 1000).abs().toString().padLeft(4, '0');
    _generatedToken = "$p1 - $p2 - $p3 - $p4 - $p5";

    notifyListeners();
  }

  ElectricityReceiptData getReceiptData() {
    final now = DateTime.now();
    return ElectricityReceiptData(
      distributionCompany: _selectedDisco,
      meterNumber: _meterNumber,
      customerName: _customerName,
      serviceAddress: _meterAddress,
      purchaseType: _selectedElectricityType == ElectricityType.prepaid
          ? "Prepaid Token"
          : "Postpaid Settlement",
      unitsPurchased: estimatedUnits,
      token: _generatedToken,
      amount: "₦$_amount",
      date: DateFormat("dd MMM yyyy, hh:mm a").format(now),
      transactionId: "ELC-${now.millisecondsSinceEpoch}",
    );
  }
}

final electricityVm = ChangeNotifierProvider<ElectricityNotifier>((ref) {
  return ElectricityNotifier();
});
