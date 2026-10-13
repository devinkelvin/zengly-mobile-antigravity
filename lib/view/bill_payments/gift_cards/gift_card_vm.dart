import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../widgets/widgets.dart';

class GiftCardNotifier extends ChangeNotifier {
  int _quantitySelected = 1;
  int get quantitySelected => _quantitySelected;

  GiftCardChoiceModel? _selectedCountry;
  GiftCardChoiceModel? get selectedCountry => _selectedCountry;

  List<GiftCardChoiceModel> countryOptions = GiftCardChoiceModel.countryOptions;

  GiftCardChoiceModel? _selectedAmount;
  GiftCardChoiceModel? get selectedAmount => _selectedAmount;

  List<GiftCardChoiceModel> amountOptions =
      GiftCardChoiceModel.giftcardAmountOptions;

  GiftCardChoiceModel? _selectedGiftcard;
  GiftCardChoiceModel? get selectedGiftcard => _selectedGiftcard;

  List<GiftCardChoiceModel> giftcardOptions =
      GiftCardChoiceModel.giftcardOptions;

  void initialize() {
    _selectedAmount = null;
    _selectedCountry = null;
    _selectedGiftcard = null;
  }

  void increaseQuantity() {
    _quantitySelected++;
    notifyListeners();
  }

  void decreaseQuantity({required BuildContext context}) {
    if (_quantitySelected <= 1) {
      AppOverlays.showToast(
        context: context,
        message: "Quantiy can't be less than 1",
        toastType: ToastificationType.error,
      );
      return;
    }

    _quantitySelected--;
    notifyListeners();
  }

  void selectCountry(String id) {
    try {
      _selectedCountry = countryOptions.firstWhere(
        (countries) => id == countries.id,
      );
    } catch (e) {
      _selectedCountry = null;
    }
    notifyListeners();
  }

  void selectAmount(String id) {
    try {
      _selectedAmount = amountOptions.firstWhere((amount) => id == amount.id);
    } catch (e) {
      _selectedAmount = null;
    }
    notifyListeners();
  }

  void selectGiftCard(String id) {
    try {
      _selectedGiftcard = giftcardOptions.firstWhere(
        (giftcard) => id == giftcard.id,
      );
    } catch (e) {
      _selectedGiftcard = null;
    }
    notifyListeners();
  }
}

final giftCardVm = ChangeNotifierProvider<GiftCardNotifier>((ref) {
  return GiftCardNotifier();
});
