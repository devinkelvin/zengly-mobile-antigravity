import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../widgets/widgets.dart';

class TransactionPinSheet extends StatefulWidget {
  final void Function(String pin) onConfirm;

  const TransactionPinSheet({super.key, required this.onConfirm});

  @override
  State<TransactionPinSheet> createState() => _TransactionPinSheetState();
}

class _TransactionPinSheetState extends State<TransactionPinSheet> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotTheme = PinTheme(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surfaceDim,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Enter Transaction PIN",
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Enter your 4 digit PIN to make this secure transaction",
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 12,
              color: Theme.of(context).colorScheme.scrim,
            ),
          ),
          SizedBox(height: 32),
          Pinput(
            autofocus: true,
            length: 4,
            controller: _pinController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            hapticFeedbackType: HapticFeedbackType.heavyImpact,
            obscureText: true,
            obscuringWidget: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            defaultPinTheme: dotTheme,
            focusedPinTheme: dotTheme,
            submittedPinTheme: dotTheme,
            separatorBuilder: (index) => SizedBox(width: 16),
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () => context.pop(),
                  actionText: "Close",
                  backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  onPressed: () {
                    if (_pinController.text.length == 4) {
                      widget.onConfirm(_pinController.text);
                    }
                  },
                  actionText: "Confirm",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
