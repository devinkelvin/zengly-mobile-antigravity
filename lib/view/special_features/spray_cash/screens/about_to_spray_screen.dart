import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/data.dart';
import 'spray_success_screen.dart';

class AboutToSprayScreen extends StatefulWidget {
  final SprayItem? item;
  final String? recipient;

  const AboutToSprayScreen({super.key, this.item, this.recipient});

  @override
  State<AboutToSprayScreen> createState() => _AboutToSprayScreenState();
}

class _AboutToSprayScreenState extends State<AboutToSprayScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutQuad,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        HapticFeedback.mediumImpact();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SpraySuccessScreen(
                item: widget.item,
                recipient: widget.recipient,
              ),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemAsset = widget.item?.image ?? AppImages.bundle50k;
    final itemName = widget.item?.name ?? "Cash Bundle";
    final targetRecipient = widget.recipient ?? "@tiwasavage";

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF14120E) : const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),

              // Big 3D Asset without dark background
              Center(
                child: SizedBox(
                  height: 290,
                  child: Image.asset(
                    itemAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.wallet, size: 100, color: Color(0xFFB57510)),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Large clean thumbnail + Status text
              Row(
                children: [
                  Image.asset(
                    itemAsset,
                    width: 58,
                    height: 58,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.wallet, size: 32, color: Color(0xFFB57510)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Spraying $itemName...",
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Transferring gift to $targetRecipient",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Animated Linear Progress Bar
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: _animation.value,
                      minHeight: 8,
                      backgroundColor: isDark
                          ? const Color(0xFF262017)
                          : const Color(0xFFEDE5D5),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFB57510),
                      ),
                    ),
                  );
                },
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
