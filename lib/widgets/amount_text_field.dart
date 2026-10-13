import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/utils.dart';

class AmountTextField extends ConsumerStatefulWidget {
  final bool hasFee;
  final double fee;
  final ValueChanged<String>? onAmountChanged;
  final ValueChanged<String>? onNoteChanged;

  const AmountTextField({
    super.key,
    this.hasFee = true,
    this.fee = 100,
    this.onAmountChanged,
    this.onNoteChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AmountTextFieldState();
}

class _AmountTextFieldState extends ConsumerState<AmountTextField> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 12, right: 12, top: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Enter Amount",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Balance",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.scrim,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "₦1,207,882.00",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                onChanged: widget.onAmountChanged,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsFormatter(),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "Add note. Eg School fees",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.scrim,
                  letterSpacing: 0,
                ),
              ),

              TextFormField(
                controller: _noteController,
                onChanged: widget.onNoteChanged,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ),
        if (widget.hasFee)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.label_outline_sharp, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Fee: ₦ ${widget.fee.toStringAsFixed(0)}",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
