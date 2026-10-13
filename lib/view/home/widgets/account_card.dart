import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class AccountCard extends ConsumerStatefulWidget {
  const AccountCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountCardState();
}

class _AccountCardState extends ConsumerState<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: Container(
          width: Responsive.width(context) < 320 ? double.infinity : 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [0.99, 0.991],
              colors: [Color(0xFF181818), Color(0xFF1E1E1E)],
            ),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Spacer(),
                  SvgPicture.asset(
                    AppImages.africa,
                    // height: 180,
                    width: 200,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Image.asset(AppImages.nigerianFlag),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            "ACC",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Color(0XFF5C616F),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "1029394838",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: Color(0XFFC4C4C4),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "NGN",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Color(0XFF5C616F),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "252,865,342.00",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: Color(0XFFC4C4C4),
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.visibility),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),

                  //  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountCard2 extends ConsumerStatefulWidget {
  const AccountCard2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountCard2State();
}

class _AccountCard2State extends ConsumerState<AccountCard2> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.scrim;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Available Balance label | Sterling account + copy
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Available Balance",
                style: GoogleFonts.inter(fontSize: 12, color: muted),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    const ClipboardData(text: "75847589495"),
                  ).then((_) {
                    if (!context.mounted) return;
                    AppOverlays.showToast(
                      context: context,
                      message: "Copied to clipboard",
                      toastType: ToastificationType.success,
                    );
                  });
                },
                child: Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Sterling • ",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              letterSpacing: 0,
                              color: muted,
                            ),
                          ),
                          TextSpan(
                            text: "75847589495",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              letterSpacing: 0,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    SvgPicture.asset(
                      AppImages.newCopy,
                      width: 14,
                      height: 14,
                      colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Balance + eye toggle
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _isVisible ? "₦2,000,000.00" : "₦*****",
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _isVisible = !_isVisible),
                child: Icon(
                  _isVisible
                      ? Icons.visibility_off_outlined
                      : Icons.remove_red_eye_outlined,
                  size: 18,
                  color: muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Cashback line
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "₦12,450.50 ",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextSpan(
                  text: "Cashback",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF00C27C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
