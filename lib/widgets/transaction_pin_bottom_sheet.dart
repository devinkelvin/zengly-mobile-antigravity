import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionPinBottomSheet extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String actionText;
  final String? amountSummary;
  final ValueChanged<String>? onPinSubmitted;
  final Future<bool> Function(String pin)? onValidate;
  final VoidCallback? onForgotPin;

  const TransactionPinBottomSheet({
    super.key,
    this.title = "Enter Transaction PIN",
    this.subtitle,
    this.actionText = "Send Transfer",
    this.amountSummary,
    this.onPinSubmitted,
    this.onValidate,
    this.onForgotPin,
  });

  static Future<String?> show(
    BuildContext context, {
    String title = "Enter Transaction PIN",
    String? subtitle,
    String actionText = "Send Transfer",
    String? amountSummary,
    Future<bool> Function(String pin)? onValidate,
    VoidCallback? onForgotPin,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (ctx) => TransactionPinBottomSheet(
        title: title,
        subtitle: subtitle,
        actionText: actionText,
        amountSummary: amountSummary,
        onValidate: onValidate,
        onForgotPin: onForgotPin,
      ),
    );
  }

  @override
  State<TransactionPinBottomSheet> createState() =>
      _TransactionPinBottomSheetState();
}

class _TransactionPinBottomSheetState extends State<TransactionPinBottomSheet>
    with SingleTickerProviderStateMixin {
  String _pin = "";
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward(from: 0.0);
  }

  void _onDigit(String digit) {
    if (_isLoading) return;
    if (_pin.length < 4) {
      HapticFeedback.lightImpact();
      setState(() {
        _errorMessage = null;
        _pin += digit;
      });
    }
  }

  void _onDelete() {
    if (_isLoading) return;
    if (_pin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() {
        _errorMessage = null;
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _onBiometrics() {
    if (_isLoading) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _pin = "1234";
    });
    _submitPin();
  }

  Future<void> _submitPin() async {
    if (_pin.length != 4 || _isLoading) return;
    HapticFeedback.mediumImpact();

    if (widget.onValidate != null) {
      setState(() => _isLoading = true);
      try {
        final isValid = await widget.onValidate!(_pin);
        if (!mounted) return;
        if (isValid) {
          Navigator.of(context).pop(_pin);
        } else {
          setState(() {
            _isLoading = false;
            _pin = "";
            _errorMessage = "Incorrect transaction PIN. Please try again.";
          });
          _triggerShake();
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage = "Validation error. Please retry.";
        });
        _triggerShake();
      }
    } else if (widget.onPinSubmitted != null) {
      widget.onPinSubmitted!(_pin);
      Navigator.of(context).pop(_pin);
    } else {
      Navigator.of(context).pop(_pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryAmber = Color(0xFFC58314);
    const sheetBg = Color(0xFF1E1E1E);
    const boxBg = Color(0xFF282828);
    const keyBg = Color(0xFF2E2E2E);

    return Container(
      decoration: const BoxDecoration(
        color: sheetBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header Row matching Screenshot 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Circular Dark Close Button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2B2B2B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),

              // Title
              Expanded(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              // Amber Circular Biometric Icon Button
              GestureDetector(
                onTap: _onBiometrics,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: primaryAmber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fingerprint_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 4 PIN Boxes matching Screenshot 1
          AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              final offset = sin(_shakeController.value * pi * 4) * 8;
              return Transform.translate(
                offset: Offset(offset, 0),
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isFilled = index < _pin.length;
                final isActive = index == _pin.length;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _errorMessage != null
                          ? const Color(0xFFEF4444)
                          : (isActive ? primaryAmber : Colors.transparent),
                      width: 1.8,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isFilled
                      ? Text(
                          "*",
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        )
                      : null,
                );
              }),
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEF4444),
              ),
            ),
          ],

          const SizedBox(height: 18),

          // "Forgot Transaction Pin?" Link
          GestureDetector(
            onTap: widget.onForgotPin ??
                () {
                  Navigator.of(context).pop();
                },
            child: Text(
              "Forgot Transaction Pin?",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Custom Dark Numeric Keypad matching Screenshot 1
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                _buildKeypadRow(["1", "2", "3"], keyBg),
                const SizedBox(height: 10),
                _buildKeypadRow(["4", "5", "6"], keyBg),
                const SizedBox(height: 10),
                _buildKeypadRow(["7", "8", "9"], keyBg),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(child: SizedBox(height: 48)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildKeypadButton("0", keyBg)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: _onDelete,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: keyBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.backspace_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bottom Primary Button "Send Transfer" matching Screenshot 1
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _pin.length == 4 && !_isLoading ? _submitPin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryAmber,
                disabledBackgroundColor: primaryAmber.withValues(alpha: 0.4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : Text(
                      widget.actionText,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> digits, Color bg) {
    return Row(
      children: digits.map((d) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildKeypadButton(d, bg),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeypadButton(String digit, Color bg) {
    return InkWell(
      onTap: () => _onDigit(digit),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          digit,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
