import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionPinBottomSheet extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? amountSummary;
  final ValueChanged<String>? onPinSubmitted;
  final Future<bool> Function(String pin)? onValidate;

  const TransactionPinBottomSheet({
    super.key,
    this.title = "Enter Transaction PIN",
    this.subtitle = "Enter your 4-digit security PIN to authorize this transaction",
    this.amountSummary,
    this.onPinSubmitted,
    this.onValidate,
  });

  static Future<String?> show(
    BuildContext context, {
    String title = "Enter Transaction PIN",
    String subtitle = "Enter your 4-digit security PIN to authorize this transaction",
    String? amountSummary,
    Future<bool> Function(String pin)? onValidate,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (ctx) => TransactionPinBottomSheet(
        title: title,
        subtitle: subtitle,
        amountSummary: amountSummary,
        onValidate: onValidate,
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
      duration: const Duration(milliseconds: 400),
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

      if (_pin.length == 4) {
        _submitPin();
      }
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

  void _onClear() {
    if (_isLoading) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _errorMessage = null;
      _pin = "";
    });
  }

  void _onBiometrics() {
    if (_isLoading) return;
    HapticFeedback.mediumImpact();
    // Biometric simulated authorization with default PIN
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
    } else {
      Navigator.of(context).pop(_pin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFFB57510);
    final sheetBg = isDark ? const Color(0xFF1B1712) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E1A14);
    final keyBg = isDark ? const Color(0xFF262017) : const Color(0xFFF4F0E8);
    final keyTextColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 14,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header Row with Title and Close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 32),
              Expanded(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close_rounded,
                  size: 22,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: isDark ? Colors.white60 : const Color(0xFF6B5E4A),
              height: 1.35,
            ),
          ),

          if (widget.amountSummary != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                widget.amountSummary!,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Animated PIN Indicator Dots with Error Shake
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
                final isError = _errorMessage != null;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isError
                        ? const Color(0xFFEF4444)
                        : (isFilled
                            ? primaryColor
                            : (isDark ? const Color(0xFF2E271E) : const Color(0xFFE5DDD0))),
                    border: Border.all(
                      color: isError
                          ? const Color(0xFFEF4444)
                          : (isFilled
                              ? primaryColor
                              : (isDark ? Colors.white12 : const Color(0xFFD2C7B4))),
                      width: 1.5,
                    ),
                    boxShadow: isFilled && !isError
                        ? [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
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

          const SizedBox(height: 24),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(
                color: Color(0xFFB57510),
                strokeWidth: 2.8,
              ),
            )
          else ...[
            // 3x4 Number Keypad
            _buildKeypadRow(["1", "2", "3"], keyBg, keyTextColor),
            const SizedBox(height: 12),
            _buildKeypadRow(["4", "5", "6"], keyBg, keyTextColor),
            const SizedBox(height: 12),
            _buildKeypadRow(["7", "8", "9"], keyBg, keyTextColor),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _onBiometrics,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF262017)
                            : const Color(0xFFF4F0E8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.fingerprint_rounded,
                        size: 26,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKeypadButton("0", keyBg, keyTextColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _onDelete,
                    onLongPress: _onClear,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF262017)
                            : const Color(0xFFF4F0E8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.backspace_outlined,
                        size: 20,
                        color: keyTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> digits, Color bg, Color textColor) {
    return Row(
      children: digits.asMap().entries.map((entry) {
        final isLast = entry.key == digits.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 12),
            child: _buildKeypadButton(entry.value, bg, textColor),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeypadButton(String digit, Color bg, Color textColor) {
    return InkWell(
      onTap: () => _onDigit(digit),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          digit,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
