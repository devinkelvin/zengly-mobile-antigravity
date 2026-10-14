import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/data.dart';

class AccountListTile extends StatelessWidget {
  final String title, subTitle;
  final String? icon;
  final IconData? iconData;
  final VoidCallback onPressed;
  final bool isBiometrics, isLogOut;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  const AccountListTile({
    super.key,
    required this.title,
    required this.subTitle,
    this.icon,
    this.iconData,
    required this.onPressed,
    this.isBiometrics = false,
    this.isLogOut = false,
    this.switchValue,
    this.onSwitchChanged,
  }) : assert(icon != null || iconData != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side:
              isLogOut
                  ? BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                  : BorderSide.none,
        ),
        color: Theme.of(context).colorScheme.outlineVariant,
        child: ListTile(
          onTap: onPressed,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading:
              iconData != null
                  ? Icon(
                    iconData,
                    size: 24,
                    color: isLogOut
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  )
                  : SvgPicture.asset(
                    icon!,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      isLogOut
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
          title: Padding(
            padding:
                isLogOut
                    ? const EdgeInsets.symmetric(vertical: 14.0)
                    : EdgeInsets.all(0),
            child: Text(
              title,
              style:
                  isLogOut
                      ? GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0,
                      )
                      : GoogleFonts.raleway(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
            ),
          ),
          subtitle:
              isLogOut
                  ? null
                  : Text(
                    subTitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      letterSpacing: 0,
                      height: 1.35,
                      color: Theme.of(context).colorScheme.scrim,
                    ),
                  ),
          trailing:
              isBiometrics
                  ? Switch(
                    value: switchValue ?? true,
                    onChanged: onSwitchChanged ?? (val) {},
                    activeThumbColor: Theme.of(context).colorScheme.onPrimary,
                    activeTrackColor: const Color(0xFFB57510),
                    inactiveThumbColor: Theme.of(context).colorScheme.onPrimary,
                    inactiveTrackColor:
                        Theme.of(context).colorScheme.outlineVariant,
                  )
                  : isLogOut
                  ? SizedBox()
                  : SvgPicture.asset(
                    AppImages.rightArrow,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.scrim,
                      BlendMode.srcIn,
                    ),
                  ),
        ),
      ),
    );
  }
}
