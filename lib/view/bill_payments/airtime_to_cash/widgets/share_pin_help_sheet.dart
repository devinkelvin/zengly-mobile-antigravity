import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/widgets.dart';

class _HelpStep {
  final String text;
  final List<String> bullets;

  const _HelpStep({required this.text, this.bullets = const []});
}

const Map<String, List<_HelpStep>> _stepsByNetwork = {
  "MTN": [
    _HelpStep(
      text:
          "Ensure you are on any of the below MTN Tariff plan or any tariff plan that supports Airtime share",
      bullets: ["Mtn Pulse", "Mtn xtraSpecial"],
    ),
    _HelpStep(text: "You can migrate to MTN pulse using *123*2*2#."),
    _HelpStep(
      text:
          "You can create an MTN share PIN using *321*1*4# if you don't have any yet.",
    ),
  ],
  "AIRTEL": [
    _HelpStep(
      text: "To set up your Airtel transfer PIN, dial *432*1*New Pin#.",
    ),
    _HelpStep(
      text:
          "If you want to change an existing PIN, dial *432*Old PIN*New PIN#.",
    ),
  ],
  "GLO": [
    _HelpStep(text: "To create your Glo Share PIN, dial *127*8*1#."),
    _HelpStep(
      text: "Follow the prompt to set a new 4-digit PIN for sharing airtime.",
    ),
  ],
  "9MOBILE": [
    _HelpStep(
      text:
          "To change your 9mobile transfer code pin, dial *321*Default Pin*New Pin#. Where default Pin is 0000.",
    ),
    _HelpStep(
      text:
          "If you want to change an existing or old pin, dial *321*Old PIN*New PIN#.",
    ),
  ],
};

class SharePinHelpSheet extends StatelessWidget {
  final String networkName;

  const SharePinHelpSheet({super.key, required this.networkName});

  @override
  Widget build(BuildContext context) {
    final steps = _stepsByNetwork[networkName] ?? _stepsByNetwork["MTN"]!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "How to get your $networkName Share PIN",
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        for (var i = 0; i < steps.length; i++) ...[
          _StepRow(index: i + 1, step: steps[i]),
          const SizedBox(height: 20),
        ],
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () => context.pop(),
            actionText: "Proceed",
          ),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  final int index;
  final _HelpStep step;

  const _StepRow({required this.index, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 28,
          width: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            "$index",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                _formatStepText(context, step.text),
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
              if (step.bullets.isNotEmpty) ...[
                const SizedBox(height: 8),
                for (final bullet in step.bullets)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      "•  $bullet",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.scrim,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  TextSpan _formatStepText(BuildContext context, String text) {
    final boldColor = Theme.of(context).colorScheme.onSurface;
    final regex = RegExp(r'(\*[\d*#A-Za-z ]+#|\b0000\b)');
    final matches = regex.allMatches(text);
    final spans = <TextSpan>[];
    var lastEnd = 0;
    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(fontWeight: FontWeight.w700, color: boldColor),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }
    return TextSpan(children: spans);
  }
}
