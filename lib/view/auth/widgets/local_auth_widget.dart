import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/data.dart';

class LocalAuthWidget extends StatelessWidget {
  final VoidCallback onTap;
  const LocalAuthWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(AppImages.fingerPrint),
    );
  }
}
