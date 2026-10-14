import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../widgets/widgets.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  String _newPin = "";
  String _confirmPin = "";
  bool _isEnteringConfirm = false;
  bool _isLoading = false;

  void _onDigit(String digit) {
    if (_isLoading) return;
    HapticFeedback.lightImpact();

    setState(() {
      if (!_isEnteringConfirm) {
        if (_newPin.length < 4) {
          _newPin += digit;
          if (_newPin.length == 4) {
            _isEnteringConfirm = true;
          }
        }
      } else {
        if (_confirmPin.length < 4) {
          _confirmPin += digit;
        }
      }
    });
  }

  void _onDelete() {
    if (_isLoading) return;
    HapticFeedback.lightImpact();

    setState(() {
      if (_isEnteringConfirm) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isEnteringConfirm = false;
        }
      } else {
        if (_newPin.isNotEmpty) {
          _newPin = _newPin.substring(0, _newPin.length - 1);
        }
      }
    });
  }

  void _saveChanges() async {
    if (_newPin.length != 4 || _confirmPin.length != 4) {
      AppOverlays.showToast(
        context: context,
        title: "PIN Required",
        message: "Please enter and confirm your 4-digit PIN",
        toastType: ToastificationType.warning,
      );
      return;
    }

    if (_newPin != _confirmPin) {
      AppOverlays.showToast(
        context: context,
        title: "PIN Mismatch",
        message: "The confirmation PIN does not match. Please try again.",
        toastType: ToastificationType.error,
      );
      setState(() {
        _confirmPin = "";
        _isEnteringConfirm = true;
      });
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    AppOverlays.showToast(
      context: context,
      title: "Success",
      message: "Transaction PIN changed successfully!",
      toastType: ToastificationType.success,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF14120E);
    const cardColor = Color(0xFF1E1C18);
    const boxBg = Color(0xFF262420);
    const primaryAmber = Color(0xFFC58314);
    const keyBg = Color(0xFF5E5E5E);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF25231F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          "Change Transaction PIN",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Card: "OTP Verified"
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "OTP Verified",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Second Card: Form matching Screenshot 5
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nice! Next create a new PIN",
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Choose a strong PIN to secure your account.",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white60,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // "New PIN"
                          Text(
                            "New PIN",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildPinRow(
                            pin: _newPin,
                            isActiveRow: !_isEnteringConfirm,
                            boxBg: boxBg,
                            activeBorderColor: primaryAmber,
                            onTapRow: () {
                              setState(() => _isEnteringConfirm = false);
                            },
                          ),

                          const SizedBox(height: 20),

                          // "Confirm PIN"
                          Text(
                            "Confirm PIN",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildPinRow(
                            pin: _confirmPin,
                            isActiveRow: _isEnteringConfirm,
                            boxBg: boxBg,
                            activeBorderColor: const Color(0xFFEF4444),
                            onTapRow: () {
                              setState(() => _isEnteringConfirm = true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Save Changes Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _newPin.length == 4 &&
                          _confirmPin.length == 4 &&
                          !_isLoading
                      ? _saveChanges
                      : null,
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
                          "Save Changes",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),

            // Custom Keypad matching Screenshot 5
            Container(
              color: const Color(0xFF121212),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  _buildPhoneKeypadRow([
                    {"num": "1", "sub": ""},
                    {"num": "2", "sub": "ABC"},
                    {"num": "3", "sub": "DEF"},
                  ], keyBg),
                  const SizedBox(height: 8),
                  _buildPhoneKeypadRow([
                    {"num": "4", "sub": "GHI"},
                    {"num": "5", "sub": "JKL"},
                    {"num": "6", "sub": "MNO"},
                  ], keyBg),
                  const SizedBox(height: 8),
                  _buildPhoneKeypadRow([
                    {"num": "7", "sub": "PQRS"},
                    {"num": "8", "sub": "TUV"},
                    {"num": "9", "sub": "WXYZ"},
                  ], keyBg),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: keyBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "+ * #",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () => _onDigit("0"),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: keyBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "0",
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: _onDelete,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: keyBg,
                              borderRadius: BorderRadius.circular(8),
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
          ],
        ),
      ),
    );
  }

  Widget _buildPinRow({
    required String pin,
    required bool isActiveRow,
    required Color boxBg,
    required Color activeBorderColor,
    required VoidCallback onTapRow,
  }) {
    return GestureDetector(
      onTap: onTapRow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          final isFilled = index < pin.length;
          final isActive = isActiveRow && index == pin.length;

          return Container(
            width: 68,
            height: 52,
            decoration: BoxDecoration(
              color: boxBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive ? activeBorderColor : Colors.transparent,
                width: 1.8,
              ),
            ),
            alignment: Alignment.center,
            child: isFilled
                ? Text(
                    "*",
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )
                : null,
          );
        }),
      ),
    );
  }

  Widget _buildPhoneKeypadRow(
    List<Map<String, String>> keys,
    Color bg,
  ) {
    return Row(
      children: keys.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => _onDigit(item["num"]!),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item["num"]!,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    if (item["sub"]!.isNotEmpty)
                      Text(
                        item["sub"]!,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                          letterSpacing: 1.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
