import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SinglePayerSplitStatus extends ConsumerStatefulWidget {
  final bool isYou;
  final bool isPaid;
  const SinglePayerSplitStatus({
    super.key,
    required this.isYou,
    required this.isPaid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SinglePayerSplitStatusState();
}

class _SinglePayerSplitStatusState
    extends ConsumerState<SinglePayerSplitStatus> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          widget.isYou
              ? EdgeInsetsGeometry.only(top: 16, bottom: 4)
              : const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  "M",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isYou ? "You" : "Amara Williams",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "10%",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color:
                              widget.isPaid
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : Color(0XFFFF3B30),
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.isPaid ? "Paid" : "Unpaid",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                          color: Theme.of(context).colorScheme.shadow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Text(
                "₦ 71,428.57",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,

                  color:
                      widget.isPaid
                          ? Theme.of(context).colorScheme.onSecondary
                          : Color(0XFFFF3B30),
                ),
              ),
            ],
          ),
          widget.isYou
              ? Container(
                height: 0.1,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.shadow,
                ),
              )
              : SizedBox(),
        ],
      ),
    );
  }
}
