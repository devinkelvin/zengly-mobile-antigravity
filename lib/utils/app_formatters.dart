import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsFormatter extends TextInputFormatter {
  /// Currency symbol prepended to the formatted value. Pass an empty string
  /// when the field renders its own symbol alongside the input.
  final String symbol;

  const ThousandsFormatter({this.symbol = '₦'});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final String newText = _formatNumber(newValue.text);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _formatNumber(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    final NumberFormat formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 0,
    );
    return formatter.format(int.parse(value));
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final newText = format(digits);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  static String format(String digits) {
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 4 || i == 7) {
        buffer.write('-');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

class CurrencyFormatter {
  static String format(num amount) {
    try {
      // Convert to double if it's a string or int
      double value = double.tryParse(amount.toString()) ?? 0.0;

      final formatCurrency = NumberFormat.currency(
        locale: 'en_NG', // For Nigerian Naira
        symbol: '₦',
        decimalDigits: value % 1 == 0 ? 0 : 2, // Remove .00 if whole number
      );

      return formatCurrency.format(value);
    } catch (e) {
      return amount.toString(); // fallback if error occurs
    }
  }
}
