import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';

class TransactionPinSheet extends StatelessWidget {
  final void Function(String pin) onConfirm;

  const TransactionPinSheet({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return TransactionPinBottomSheet(
      onPinSubmitted: onConfirm,
    );
  }
}
