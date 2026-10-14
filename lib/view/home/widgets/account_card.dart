import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountCard2();
  }
}

class AccountCard2 extends ConsumerStatefulWidget {
  const AccountCard2({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountCard2State();
}

class _AccountCard2State extends ConsumerState<AccountCard2> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF261F16),
                  Color(0xFF181410),
                  Color(0xFF0F0E0C),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFFDF9),
                  Color(0xFFF7F1E6),
                ],
              ),
        border: Border.all(
          color: isDark
              ? const Color(0xFFB57510).withValues(alpha: 0.35)
              : const Color(0xFFE2D6C3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : const Color(0xFFB57510).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Available Balance label | Sterling virtual account copy pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "AVAILABLE BALANCE",
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.white60 : const Color(0xFF7A7062),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Clipboard.setData(
                    const ClipboardData(text: "75847589495"),
                  ).then((_) {
                    if (!context.mounted) return;
                    AppOverlays.showToast(
                      context: context,
                      message: "Sterling account copied!",
                      toastType: ToastificationType.success,
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : const Color(0xFFEDE5D5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? Colors.white12 : const Color(0xFFDCCFBC),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sterling • 75847589495",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                        AppImages.newCopy,
                        width: 12,
                        height: 12,
                        colorFilter: ColorFilter.mode(
                          isDark ? Colors.white70 : Colors.black54,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Balance amount + eye toggle
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _isVisible ? "₦2,000,000.00" : "₦••••••••",
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : const Color(0xFF1F1A12),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isVisible = !_isVisible);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                  child: Icon(
                    _isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.remove_red_eye_outlined,
                    size: 16,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bottom Row: Cashback indicator pill + Currency tag
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C27C).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF00C27C).withValues(alpha: 0.3),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.redeem_rounded,
                      size: 13,
                      color: Color(0xFF00C27C),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "+₦12,450.50 Cashback Available",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00C27C),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                "NGN WALLET",
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
