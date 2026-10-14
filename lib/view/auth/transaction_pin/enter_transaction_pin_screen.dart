import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/widgets.dart';

class EnterTransactionPinScreen extends StatelessWidget {
  const EnterTransactionPinScreen({super.key});

  static Future<String?> show(BuildContext context, {String? amountSummary}) {
    return TransactionPinBottomSheet.show(
      context,
      amountSummary: amountSummary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.65),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.pop(),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Prevent taps on sheet from closing
            child: const TransactionPinBottomSheet(),
          ),
        ),
      ),
    );
  }
}

class EnterTransactionPinSheet extends StatelessWidget {
  final ValueChanged<String>? onPinSubmitted;

  const EnterTransactionPinSheet({super.key, this.onPinSubmitted});

  @override
  Widget build(BuildContext context) {
    return TransactionPinBottomSheet(
      onPinSubmitted: onPinSubmitted,
    );
  }
}
