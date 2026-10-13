import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Animated 3D Lottie success checkmark badge used across the entire app.
/// Asset: https://lottie.host/8475853b-ec66-4e6a-a347-33ba2c406b71/LOj7hcpJU5.lottie
class RotatingCoinIcon extends StatelessWidget {
  final double size;
  final bool repeat;

  const RotatingCoinIcon({
    super.key,
    this.size = 64,
    this.repeat = true,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/checkmark.json',
      width: size,
      height: size,
      repeat: repeat,
      fit: BoxFit.contain,
    );
  }
}

/// Alias for RotatingCoinIcon for intuitive success icon usage across all screens.
class AppSuccessIcon extends StatelessWidget {
  final double size;
  final bool repeat;

  const AppSuccessIcon({
    super.key,
    this.size = 64,
    this.repeat = true,
  });

  @override
  Widget build(BuildContext context) {
    return RotatingCoinIcon(
      size: size,
      repeat: repeat,
    );
  }
}
