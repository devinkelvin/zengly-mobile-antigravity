import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/data.dart';
import '../../utils/utils.dart';
import '../../view/dashboard/dashboard_vm.dart';
import '../../view/dashboard/widgets/dashboard_bottom_bar.dart';
import '../../widgets/widgets.dart';

class PreBillScreen extends ConsumerStatefulWidget {
  const PreBillScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreBillScreenState();
}

class _PreBillScreenState extends ConsumerState<PreBillScreen> {
  bool _essentialsExpanded = true;
  bool _billsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItem(
        label: "Transfer",
        icon: AppImages.sendNew,
        onTap: () => AppOverlays.transferOptionsSheet(context: context),
      ),
      _MenuItem(
        label: "Vaniti",
        icon: AppImages.vanitiNew,
        onTap: () => AppOverlays.vanitiIntroDialog(
          context: context,
          onProceed: () => context.goNamed(AppRouter.preSpecialFeatures),
        ),
      ),
      _MenuItem(
        label: "Split Bill",
        icon: AppImages.splitNew,
        onTap: () => context.goNamed(AppRouter.splitBill),
      ),
      _MenuItem(
        label: "Finance AI",
        image: AppImages.insightsIcon,
        isV2: true,
        onTap: () {
          ref.read(dashboardVm).switchPage(2);
          context.pop();
        },
      ),
      _MenuItem(
        label: "Ajo 2.0",
        iconData: Icons.groups_outlined,
        isV2: true,
        onTap: () => AppOverlays.showToast(
          context: context,
          message: "Ajo 2.0 is coming soon! Stay tuned.",
        ),
      ),
      _MenuItem(
        label: "P2P Lending",
        iconData: Icons.handshake_outlined,
        isV2: true,
        onTap: () => AppOverlays.showToast(
          context: context,
          message: "P2P Lending is coming soon! Stay tuned.",
        ),
      ),
      _MenuItem(
        label: "Voice Banking",
        iconData: Icons.mic_none_outlined,
        isV2: true,
        onTap: () => AppOverlays.showToast(
          context: context,
          message: "Voice Banking is coming soon! Stay tuned.",
        ),
      ),
    ];

    final billItems = [
      _MenuItem(
        label: "Data",
        icon: AppImages.dataNew,
        onTap: () => context.goNamed(AppRouter.airtimeData),
      ),
      _MenuItem(
        label: "Airtime",
        icon: AppImages.airtimeNew,
        onTap: () => context.goNamed(AppRouter.airtimeData),
      ),
      _MenuItem(
        label: "Electricity",
        icon: AppImages.electricityNew,
        onTap: () => context.goNamed(AppRouter.electricity),
      ),
      _MenuItem(
        label: "Airtime2Cash",
        icon: AppImages.airtime2CashNew,
        onTap: () => context.goNamed(AppRouter.airtimeToCash),
      ),
      // _MenuItem(
      //   label: "TV",
      //   icon: AppImages.television,
      //   onTap: () => context.goNamed(AppRouter.tvSubscription),
      // ),
      // _MenuItem(
      //   label: "Gift Cards",
      //   icon: AppImages.newCopy,
      //   onTap: () => context.goNamed(AppRouter.giftCard),
      // ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          "Menu",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 22),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              AppImages.search,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => context.goNamed(AppRouter.notification),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    padding: const EdgeInsets.all(9),
                    child: SvgPicture.asset(
                      AppImages.bellIcon,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF24A4A),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          "2",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppDimensions.viewPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap:
                  () => setState(
                    () => _essentialsExpanded = !_essentialsExpanded,
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.grid_view_rounded,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Essentials",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _essentialsExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            if (_essentialsExpanded)
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1,
                children: items.map((item) => _MenuCell(item: item)).toList(),
              ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () => setState(() => _billsExpanded = !_billsExpanded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Bills Payment",
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _billsExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            if (_billsExpanded)
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1,
                children:
                    billItems.map((item) => _MenuCell(item: item)).toList(),
              ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MenuCell extends StatelessWidget {
  final _MenuItem item;

  const _MenuCell({required this.item});

  Widget _buildIcon(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Center(
        child: item.icon != null
            ? SvgPicture.asset(
                item.icon!,
                width: 26,
                height: 26,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFB57510),
                  BlendMode.srcIn,
                ),
              )
            : item.image != null
                ? Image.asset(item.image!, width: 26, height: 26, fit: BoxFit.contain)
                : Icon(item.iconData, size: 26, color: const Color(0xFFB57510)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(context),
                const SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.label,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (item.isV2)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF24A4A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "V2.0",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String label;
  final String? icon;
  final String? image;
  final IconData? iconData;
  final bool isV2;
  final VoidCallback onTap;

  const _MenuItem({
    required this.label,
    this.icon,
    this.image,
    this.iconData,
    this.isV2 = false,
    required this.onTap,
  });
}
