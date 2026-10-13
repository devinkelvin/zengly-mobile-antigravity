import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Backs each route with an opaque copy of the app's gradient background
/// before applying the platform's normal transition. Without this, the
/// Scaffold's transparent background lets the outgoing page show through
/// the incoming one while they're both in the Overlay during a transition.
class _GradientPageTransitionsBuilder extends PageTransitionsBuilder {
  const _GradientPageTransitionsBuilder(this.gradient, this.delegate);

  final Gradient gradient;
  final PageTransitionsBuilder delegate;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return delegate.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      DecoratedBox(decoration: BoxDecoration(gradient: gradient), child: child),
    );
  }
}

class AppTheme {
  static Color primaryColor = Color(0XFFB57510);

  // static const LinearGradient backgroundGradient = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: [Color(0xFFB57510), Color(0xFF2C2C2C), Color(0xFF2C2C2C)],
  //   stops: [0.0, 0.55, 1.0],
  // );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0XFF332408), Color(0XFF211B12), Color(0XFF161616)],
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF3DC), Color(0xFFFAF0E4), Color(0xFFF5EDE0)],
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      primaryContainer: Color(0XFFDB7600),
      onPrimary: Colors.white,
      secondary: Colors.pink,
      onSecondary: Color(0XFF34C759),
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Color(0XFF1A1A1A),
      outline: Color(0XFFE0D8D0),
      outlineVariant: Color(0XFFF0EAE2),
      surfaceTint: Color(0XFFCBD5E1),
      scrim: Color(0XFF8A8A8A),
      shadow: Color(0XFFADADAD),
      surfaceDim: Color(0XFFC8C8C8),
      inverseSurface: Color(0XFFF5EDE0),
      onPrimaryContainer: Color(0XFF5C5C5C),
      onPrimaryFixedVariant: Color(0XFF4A4A4A),
      secondaryContainer: Color(0XFFF0EAE2),
      onInverseSurface: Color(0XFFFAF5F0),
      onTertiaryContainer: Color(0XFFE8E0D8),
      onTertiaryFixedVariant: Color(0XFFE0D8CE),
      onSecondaryFixed: Color(0XFFE8E0D8),
      onTertiary: Color(0XFFFFFFFF),
      secondaryFixedDim: Color(0XFFB0A898),
      tertiary: Colors.green,
      tertiaryContainer: Color(0XFFE8E2DA),
      surfaceContainer: Color(0XFF9A9488),
      onSurfaceVariant: Color(0XFF3A3A3A),
    ),
    scaffoldBackgroundColor: Colors.transparent,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalElevation: 0,
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _GradientPageTransitionsBuilder(
          lightBackgroundGradient,
          const ZoomPageTransitionsBuilder(),
        ),
        TargetPlatform.iOS: _GradientPageTransitionsBuilder(
          lightBackgroundGradient,
          const CupertinoPageTransitionsBuilder(),
        ),
      },
    ),
    brightness: Brightness.light,
    primaryColor: primaryColor,
  );

  static ThemeData darkkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      primaryContainer: Color(0XFFDB7600),
      onPrimary: Colors.white,
      secondary: Colors.pink,
      onSecondary: Color(0XFF34C759),
      error: Colors.red,
      onError: Colors.white,
      surface: Color(0XFF202020),
      onSurface: Colors.white,
      outline: Color(0XFF2E3336),
      outlineVariant: Color(0XFF282828),
      surfaceTint: Color(0XFFCBD5E1),
      scrim: Color(0XFF858585),
      shadow: Color(0XFFADADAD),
      surfaceDim: Color(0XFF979797),
      inverseSurface: Color(0XFF333333),
      onPrimaryContainer: Color(0XFFB3B3B3),
      onPrimaryFixedVariant: Color(0XFFD1D1D6),
      secondaryContainer: Color(0XFF3E3E3E),
      onInverseSurface: Color(0XFF232323),
      onTertiaryContainer: Color(0XFF141414),
      onTertiaryFixedVariant: Color(0XFF0E0F0C),
      onSecondaryFixed: Color(0XFF1A1919),
      onTertiary: Color(0XFF000000),
      secondaryFixedDim: Color(0XFF81838F),
      tertiary: Colors.green,
      tertiaryContainer: Color(0XFF404040),
      surfaceContainer: Color(0XFF6A6C6A),
      onSurfaceVariant: Color(0XFFD9D9D9),
    ),
    scaffoldBackgroundColor: Colors.transparent,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalElevation: 0,
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _GradientPageTransitionsBuilder(
          backgroundGradient,
          const ZoomPageTransitionsBuilder(),
        ),
        TargetPlatform.iOS: _GradientPageTransitionsBuilder(
          backgroundGradient,
          const CupertinoPageTransitionsBuilder(),
        ),
      },
    ),

    brightness: Brightness.dark,
    primaryColor: primaryColor,
  );
}
