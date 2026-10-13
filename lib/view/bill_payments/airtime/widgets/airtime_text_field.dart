import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/utils.dart';

class AirtimeTextField extends StatefulWidget {
  final TextEditingController controller;
  const AirtimeTextField({super.key, required this.controller});

  @override
  State<AirtimeTextField> createState() => _AirtimeTextFieldState();
}

class _AirtimeTextFieldState extends State<AirtimeTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.outlineVariant,
        border: Border.all(
          color:
              _isFocused ? primary : Theme.of(context).colorScheme.outline,
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow:
            _isFocused
                ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.45),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
                : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Enter Amount",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              Spacer(),
              // Text(
              //   "Balance",
              //   style: GoogleFonts.inter(
              //     fontWeight: FontWeight.w600,
              //     fontSize: 12,
              //     color: Theme.of(context).colorScheme.scrim,
              //     letterSpacing: 0,
              //   ),
              // ),
              // SizedBox(width: 4),
              // Text(
              //   "₦1,207,882.00",
              //   style: GoogleFonts.inter(
              //     fontWeight: FontWeight.w600,
              //     fontSize: 12,
              //     letterSpacing: 0,
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 12),
          // The ₦ lives outside the field so it stays visible while the hint
          // ("0.00") shows — a prefixText would only appear once focused.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "₦",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // No symbol — the ₦ is rendered beside the field.
                    const ThousandsFormatter(symbol: ''),
                  ],
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: "0.00",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
