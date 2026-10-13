import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';
import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class ActionPanel extends StatelessWidget {
  const ActionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final actions = [
      _ActionItem(
        label: "Transfer",
        icon: AppImages.sendNew,
        isNew: false,
        onTap: () => AppOverlays.transferOptionsSheet(context: context),
      ),
      _ActionItem(
        label: "Vaniti",
        icon: AppImages.vanitiNew,
        isNew: true,
        onTap: () => AppOverlays.vanitiIntroDialog(
          context: context,
          onProceed: () => context.goNamed(AppRouter.preSpecialFeatures),
        ),
      ),
      _ActionItem(
        label: "Split Bill",
        icon: AppImages.splitNew,
        isNew: true,
        onTap: () => context.goNamed(AppRouter.splitBill),
      ),
      _ActionItem(
        label: "Data",
        icon: AppImages.dataNew,
        isNew: false,
        onTap: () => context.pushNamed(
          AppRouter.airtimeData,
          extra: 1, // Opens Data tab directly
        ),
      ),
      _ActionItem(
        label: "Airtime",
        icon: AppImages.airtimeNew,
        isNew: false,
        onTap: () => context.pushNamed(
          AppRouter.airtimeData,
          extra: 0, // Opens Airtime tab directly
        ),
      ),
      _ActionItem(
        label: "Electricity",
        icon: AppImages.electricityNew,
        isNew: false,
        onTap: () => context.goNamed(AppRouter.electricity),
      ),
      _ActionItem(
        label: "Airtime2Cash",
        icon: AppImages.airtime2CashNew,
        isNew: true,
        onTap: () => context.goNamed(AppRouter.airtimeToCash),
      ),
      _ActionItem(
        label: "More",
        icon: AppImages.moreNew,
        isNew: false,
        onTap: () => context.pushNamed(AppRouter.preBill),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1A14) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2C241B) : const Color(0xFFEFE8DE),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions.sublist(0, 4).map((item) {
              return Expanded(child: _ActionCell(item: item));
            }).toList(),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions.sublist(4, 8).map((item) {
              return Expanded(child: _ActionCell(item: item));
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ActionCell extends StatelessWidget {
  final _ActionItem item;
  const _ActionCell({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? const Color(0xFF2B241A)
                        : const Color(0xFFF9F5EE),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF382E20)
                          : const Color(0xFFECE4D7),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(13),
                  child: SvgPicture.asset(
                    item.icon,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFB57510),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if (item.isNew)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? const Color(0xFF1E1A14) : Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        "NEW",
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  final String label;
  final String icon;
  final bool isNew;
  final VoidCallback onTap;

  const _ActionItem({
    required this.label,
    required this.icon,
    required this.isNew,
    required this.onTap,
  });
}
