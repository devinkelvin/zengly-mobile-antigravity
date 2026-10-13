import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../widgets/widgets.dart';

enum VoiceState { ready, listening, processing, recognized, success, error }

class VoiceBankingScreen extends StatefulWidget {
  const VoiceBankingScreen({super.key});

  @override
  State<VoiceBankingScreen> createState() => _VoiceBankingScreenState();
}

class _VoiceBankingScreenState extends State<VoiceBankingScreen>
    with SingleTickerProviderStateMixin {
  VoiceState _state = VoiceState.ready;
  String _recognizedText = "";
  Map<String, dynamic> _parsedAction = {};
  late AnimationController _waveController;

  final List<String> _suggestedPrompts = [
    "Send ₦5,000 to Tunde",
    "Buy ₦1,000 MTN airtime",
    "What is my wallet balance?",
    "Pay electricity bill for Ikeja Electric",
    "Spray ₦10,000 in Vaniti",
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _startListening([String? customPrompt]) {
    setState(() {
      _state = VoiceState.listening;
      _recognizedText = customPrompt ?? "Listening to your voice...";
    });

    // Simulate speech capture -> processing
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _state = VoiceState.processing);

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        final prompt = customPrompt ?? "Send ₦5,000 to Tunde Adebayo";
        setState(() {
          _state = VoiceState.recognized;
          _recognizedText = prompt;
          _parsedAction = {
            "action": "Bank Transfer",
            "recipient": "Tunde Adebayo",
            "tag": "@tunde",
            "amount": 5000.0,
            "source": "Zengly Main Balance",
            "fee": 0.0,
          };
        });
      });
    });
  }

  void _authorizeAction() {
    // Financial security step: Confirm transaction
    setState(() => _state = VoiceState.processing);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() => _state = VoiceState.success);
      AppOverlays.showToast(
        context: context,
        title: "Voice Instruction Executed",
        message: "₦5,000 transferred to Tunde Adebayo successfully.",
        toastType: ToastificationType.success,
      );
    });
  }

  void _reset() {
    setState(() {
      _state = VoiceState.ready;
      _recognizedText = "";
      _parsedAction = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF757575);
    final borderColor = isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Voice Banking",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18, color: textPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textPrimary, size: 20),
            onPressed: _reset,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Hands-Free Financial Actions",
                style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                "Speak naturally in English or Pidgin to transfer funds, pay bills, or query balances.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12, color: textSecondary, height: 1.35),
              ),
              const Spacer(),

              // Animated Waveform or Interactive Mic Area
              if (_state == VoiceState.listening) ...[
                Text(
                  "Listening...",
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),
                ),
                const SizedBox(height: 16),
                // Audio wave visualization
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(12, (index) {
                        final wave = sin((index / 12 * pi * 2) + (_waveController.value * pi * 2)).abs();
                        final height = 15.0 + (wave * 45.0);
                        return Container(
                          width: 4,
                          height: height,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ] else if (_state == VoiceState.processing) ...[
                const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFFB57510)),
                ),
                const SizedBox(height: 16),
                Text(
                  "Processing voice command...",
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                ),
                const SizedBox(height: 24),
              ] else if (_state == VoiceState.recognized) ...[
                // Intent confirmation card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: primaryColor.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                            child: Text("Command Recognized", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: primaryColor)),
                          ),
                          const Icon(Icons.check_circle_outline_rounded, size: 18, color: Color(0xFF34C759)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text("“$_recognizedText”", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary)),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Action", style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                          Text("${_parsedAction['action']}", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Recipient", style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                          Text("${_parsedAction['recipient']} (${_parsedAction['tag']})", style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textPrimary)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount", style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                          Text("₦5,000.00", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: primaryColor)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        actionText: "Authorize Transfer with PIN",
                        borderRadius: 100,
                        onPressed: _authorizeAction,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ] else if (_state == VoiceState.success) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF34C759).withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF34C759), size: 48),
                      const SizedBox(height: 10),
                      Text("Transaction Completed", style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text("₦5,000.00 successfully transferred to Tunde Adebayo.", style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _reset,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textPrimary,
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        ),
                        child: const Text("Perform Another Action"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ] else ...[
                // Ready Mic Button
                GestureDetector(
                  onTap: () => _startListening(),
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primaryColor, const Color(0xFF8A5506)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.mic_rounded, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Tap microphone to speak",
                  style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: textSecondary),
                ),
                const SizedBox(height: 24),
              ],

              const Spacer(),

              // Suggested Prompt Chips
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Or try one of these voice commands:",
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _suggestedPrompts.map((prompt) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(prompt),
                        onPressed: () => _startListening(prompt),
                        backgroundColor: isDark ? const Color(0xFF1E1A14) : Colors.white,
                        side: BorderSide(color: borderColor),
                        labelStyle: GoogleFonts.inter(fontSize: 11.5, color: textPrimary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
