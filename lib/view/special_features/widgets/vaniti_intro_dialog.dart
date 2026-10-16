import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/storage/storage.dart';
import '../../../data/data.dart';

/// Full-bleed announcement modal shown the first time a user opens Vaniti.
/// The "Hide this" toggle persists so it stops appearing once dismissed.
class VanitiIntroDialog extends StatefulWidget {
  /// Fired when "Try Vaniti Now" is tapped, after the dialog closes.
  final VoidCallback onTryNow;

  const VanitiIntroDialog({super.key, required this.onTryNow});

  static const _gold = Color(0xFFA87718);
  static const _body = Color(0xFF3A2E1C);


  @override
  State<VanitiIntroDialog> createState() => _VanitiIntroDialogState();
}

class _VanitiIntroDialogState extends State<VanitiIntroDialog> {
  bool _hide = false;

  Future<void> _persistPreference() async {
    if (_hide) {
      await LocalStorage().writeData(LocalStorage.hideVanitiIntro, true);
    }
  }

  Future<void> _close() async {
    await _persistPreference();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _tryNow() async {
    await _persistPreference();
    if (!mounted) return;
    Navigator.of(context).pop();
    widget.onTryNow();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 60),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF9C878), Color(0xFFF6BD66)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Introducing",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                                color: VanitiIntroDialog._gold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Vaniti",
                              style: GoogleFonts.inter(
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                height: 1.1,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Celebrations just got a glow-up. With the all-new "
                              "Vaniti Spray, every tap becomes an unforgettable "
                              "moment.",
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                height: 1.45,
                                letterSpacing: 0,
                                color: VanitiIntroDialog._body,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Simply tap, hold, and spray to bring your screen "
                              "to life with premium effects, vibrant visuals, "
                              "and your own personal flair.",
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                height: 1.45,
                                letterSpacing: 0,
                                color: VanitiIntroDialog._body,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Make every moment feel special.",
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0,
                                color: VanitiIntroDialog._gold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: _tryNow,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  "Try Vaniti Now",
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Artwork fills edge-to-edge with compact height
                      SizedBox(
                        width: double.infinity,
                        height: 195,
                        child: Image.asset(
                          AppImages.vanitiSprayHands,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  SizedBox(
                    height: 28,
                    child: Switch(
                      value: _hide,
                      onChanged: (v) => setState(() => _hide = v),
                      activeThumbColor: Colors.white,
                      activeTrackColor: Colors.black,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFFBDBDBD),
                      trackOutlineColor: WidgetStateProperty.all(
                        Colors.transparent,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Hide this, Seen this already",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        letterSpacing: 0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _close,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
