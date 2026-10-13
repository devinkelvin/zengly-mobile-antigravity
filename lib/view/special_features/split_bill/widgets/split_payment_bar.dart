import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SplitPaymentBar extends ConsumerStatefulWidget {
  const SplitPaymentBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SplitPaymentBarState();
}

class _SplitPaymentBarState extends ConsumerState<SplitPaymentBar> {
  double progressValue = 0.1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Status",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            letterSpacing: 0,
            color: Theme.of(context).colorScheme.scrim,
          ),
        ),
        SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progressValue),
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                final barWidth = constraints.maxWidth * value;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0XFF56585C),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          minHeight: 18,
                          value: value,
                          valueColor: AlwaysStoppedAnimation(Color(0XFF9DFF94)),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),

                    Positioned(
                      left: barWidth - 30,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          "${(value * 100).toStringAsFixed(0)}%",
                          style: GoogleFonts.inter(
                            color: Color(0XFF4F4F4F),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              "Unpaid Balance",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                letterSpacing: 0,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
            Spacer(),
            Text(
              "₦ 125,000",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                letterSpacing: 0,
                color: Theme.of(context).colorScheme.scrim,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
