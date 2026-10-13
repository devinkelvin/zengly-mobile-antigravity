import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterTransactionPinScreen extends StatefulWidget {
  const EnterTransactionPinScreen({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const EnterTransactionPinSheet(),
    );
  }

  @override
  State<EnterTransactionPinScreen> createState() =>
      _EnterTransactionPinScreenState();
}

class _EnterTransactionPinScreenState extends State<EnterTransactionPinScreen> {
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
            child: const EnterTransactionPinSheet(),
          ),
        ),
      ),
    );
  }
}

class EnterTransactionPinSheet extends StatefulWidget {
  final ValueChanged<String>? onPinSubmitted;

  const EnterTransactionPinSheet({super.key, this.onPinSubmitted});

  @override
  State<EnterTransactionPinSheet> createState() =>
      _EnterTransactionPinSheetState();
}

class _EnterTransactionPinSheetState extends State<EnterTransactionPinSheet> {
  String _pin = "";

  void _onDigit(String digit) {
    if (_pin.length < 4) {
      HapticFeedback.lightImpact();
      setState(() => _pin += digit);
      if (_pin.length == 4) {
        // Auto trigger or allow button tap
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      HapticFeedback.lightImpact();
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  void _onBiometrics() {
    HapticFeedback.mediumImpact();
    // Simulate biometric quick fill
    setState(() => _pin = "1234");
    _submitPin();
  }

  void _submitPin() {
    if (_pin.length == 4) {
      HapticFeedback.heavyImpact();
      if (widget.onPinSubmitted != null) {
        widget.onPinSubmitted!(_pin);
      } else {
        context.pop(_pin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1B1814) : Colors.white;
    final pinBoxBg = isDark ? const Color(0xFF26211B) : const Color(0xFFF1F3F5);
    final keyBg = isDark ? const Color(0xFF26221D) : const Color(0xFFE9ECEF);
    final keyTextColor = isDark ? Colors.white : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header: Close (X) - Title - Biometrics (Gold fingerprint)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF26211B)
                        : const Color(0xFFE5E7EB),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              Text(
                "Enter Transaction PIN",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: _onBiometrics,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC87D0E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fingerprint,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // 4 PIN Boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              final isFilled = index < _pin.length;
              final isCurrent = index == _pin.length;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: pinBoxBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCurrent
                        ? const Color(0xFFC87D0E)
                        : (isFilled ? Colors.transparent : Colors.transparent),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  isFilled ? "*" : "",
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),

          // Forgot PIN link
          GestureDetector(
            onTap: () {},
            child: Text(
              "Forgot Transaction PIN?",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 3x4 Keypad
          _buildKeypad(keyBg, keyTextColor),
          const SizedBox(height: 20),

          // "Send Transfer" button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _pin.length == 4 ? _submitPin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB57510),
                disabledBackgroundColor:
                    const Color(0xFFB57510).withValues(alpha: 0.5),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Send Transfer",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad(Color keyBg, Color textColor) {
    final rows = [
      ["1", "2", "3"],
      ["4", "5", "6"],
      ["7", "8", "9"],
      ["", "0", "delete"],
    ];

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: row.map((key) {
              if (key.isEmpty) {
                return const Expanded(child: SizedBox(height: 52));
              }

              final isDelete = key == "delete";

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () {
                      if (isDelete) {
                        _onDelete();
                      } else {
                        _onDigit(key);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: keyBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: isDelete
                          ? Icon(
                              Icons.backspace_outlined,
                              size: 20,
                              color: textColor,
                            )
                          : Text(
                              key,
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
