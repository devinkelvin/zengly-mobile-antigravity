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
        onTap: () => context.goNamed(AppRouter.airtimeData),
      ),
      _ActionItem(
        label: "Airtime",
        icon: AppImages.airtimeNew,
        isNew: false,
        onTap: () => context.goNamed(AppRouter.airtimeData),
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
        onTap: () => context.goNamed(AppRouter.preBill),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 85 / 106,
        children: actions.map((item) => _ActionCell(item: item)).toList(),
      ),
    );
  }
}

class _ActionCell extends StatelessWidget {
  final _ActionItem item;
  const _ActionCell({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                padding: const EdgeInsets.all(14),
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
                  top: -6,
                  right: -14,
                  child: Container(
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF24A4A),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "NEW",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item.label,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
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
