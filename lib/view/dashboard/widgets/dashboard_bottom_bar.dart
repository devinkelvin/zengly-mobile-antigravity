import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/app_images.dart';
import '../../../l10n/app_localizations.dart';
import '../dashboard_vm.dart';

class DashboardBottomBar extends ConsumerWidget {
  const DashboardBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(dashboardVm);
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final muted = isDark ? const Color(0xFF8A857A) : const Color(0xFF8A8275);
    final activeColor = primary;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1814) : const Color(0xFFFAF5ED),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF29241D) : const Color(0xFFE8E0D2),
            width: 0.8,
          ),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: vm.currentIndex,
          onTap: vm.switchPage,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 10,
            color: activeColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: muted,
          ),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: activeColor,
          unselectedItemColor: muted,
          items: [
            BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  AppImages.homeActive,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    activeColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  AppImages.homeLight,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
                ),
              ),
              label: l10n.navHome,
            ),
            BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  AppImages.sendNew,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    activeColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  AppImages.sendNew,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
                ),
              ),
              label: "Transfer",
            ),
            BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  AppImages.vanitiNew,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    activeColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  AppImages.vanitiNew,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
                ),
              ),
              label: "Vaniti",
            ),
            BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  AppImages.insightFull,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    activeColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  AppImages.insightActive,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
                ),
              ),
              label: l10n.navInsights,
            ),
            BottomNavigationBarItem(
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  AppImages.profileActive,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    activeColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 3.0),
                child: SvgPicture.asset(
                  AppImages.profileActive,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(muted, BlendMode.srcIn),
                ),
              ),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
