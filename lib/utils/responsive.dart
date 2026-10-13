import 'package:flutter/material.dart';

class Responsive {
  static bool isSmallMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 320;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 480;

  static bool isBigMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1024;

  static double height(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;
}
