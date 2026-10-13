import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/storage/storage.dart';
import '../../data/data.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../utils/utils.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeSplashScreen();
  }

  Future<void> _handleFreshInstall() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('is_first_run') ?? true;

    if (isFirstRun) {
      try {
        await LocalStorage().deleteAllData();
      } catch (e, stackTrace) {
        AppLogger.logError(
          "Failed to wipe secure storage on fresh install",
          error: e,
          stackTrace: stackTrace,
        );
      }
      await prefs.setBool('is_first_run', false);
    }
  }

  Future<void> _initializeSplashScreen() async {
    await _handleFreshInstall();
    final authNotifier = ref.read(authNotifierProvider.notifier);
    Timer(const Duration(seconds: 4, milliseconds: 500), () async {
      if (!mounted) return;

      final isFirstTimeUser = await authNotifier.isFirstTimeUser();
      if (isFirstTimeUser) {
        if (!mounted) return;
        context.goNamed(AppRouter.chooseSignUp);
        return;
      }

      final userExists = await authNotifier.doesUserExist();
      if (!mounted) return;
      if (userExists) {
        context.goNamed(AppRouter.loginKnown);
      } else {
        context.goNamed(AppRouter.loginUnknown);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(AppImages.fullLogo)
            .animate()
            .slideX(duration: Duration(seconds: 1, milliseconds: 500))
            .fadeIn(
              duration: Duration(seconds: 4),
              delay: Duration(milliseconds: 500),
            ),
      ),
    );
  }
}
