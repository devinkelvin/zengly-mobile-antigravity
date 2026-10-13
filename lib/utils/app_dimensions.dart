import 'package:flutter/material.dart';

class AppDimensions {
  static const pagePadding = 16.0;
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 16);
  static const viewPadding = EdgeInsets.symmetric(
    horizontal: AppDimensions.pagePadding,
    vertical: 8,
  );
  static const newViewPadding = EdgeInsets.symmetric(
    horizontal: 16,
   // vertical: 4,
  );
  static const viewPadding2 = EdgeInsets.symmetric(
    horizontal: AppDimensions.pagePadding,
    vertical: 0,
  );
  static const viewPadding3 = EdgeInsets.symmetric(
    horizontal: AppDimensions.pagePadding / 2,
    vertical: 0,
  );
}
