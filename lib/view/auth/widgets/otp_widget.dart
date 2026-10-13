import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../widgets/widgets.dart';

enum OtpChannel { email, phone }

class OtpBottomSheetBody extends StatefulWidget {
  final TextEditingController controller;
  final int length;
  final int initialSeconds;
  final OtpChannel channel;
  final String maskedTarget;
  final VoidCallback onVerify;

  const OtpBottomSheetBody({
    super.key,
    required this.controller,
    required this.length,
    required this.initialSeconds,
    required this.channel,
    required this.maskedTarget,
    required this.onVerify,
  });

  @override
  State<OtpBottomSheetBody> createState() => _OtpBottomSheetBodyState();
}

class _OtpBottomSheetBodyState extends State<OtpBottomSheetBody> {
  late int seconds;
  late Timer timer;
  bool isTimerActive = true;

  @override
  void initState() {
    super.initState();
    seconds = widget.initialSeconds;
    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          isTimerActive = false;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isTimerActive,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter OTP",
              style: GoogleFonts.raleway(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.channel == OtpChannel.email
                  ? "We just sent you a one-time password to your email:"
                  : "We just sent you a one-time password to your phone no:",
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 12,
                letterSpacing: 0,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.maskedTarget,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 40),
            Pinput(
              autofocus: true,
              controller: widget.controller,
              length: widget.length,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              hapticFeedbackType: HapticFeedbackType.heavyImpact,
              focusedPinTheme: PinTheme(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              defaultPinTheme: PinTheme(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            if (widget.channel == OtpChannel.email) ...[
              SizedBox(height: 16),
              Text(
                "Can't find your OTP? check email spam folder",
                style: GoogleFonts.raleway(
                  fontSize: 12,
                  letterSpacing: 0,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
            ],
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: widget.onVerify,
                actionText: "Verify",
              ),
            ),
            SizedBox(height: 16),
            Text(
              seconds > 0 ? "Resend OTP in ${seconds}s" : "Resend OTP now",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
