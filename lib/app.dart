import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller/locale/locale_controller.dart';
import 'controller/theme/theme_controller.dart';
import 'flavors.dart';
import 'l10n/app_localizations.dart';
import 'utils/utils.dart';

class ZenglyApp extends ConsumerWidget {
  const ZenglyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      title: F.title,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: F.appFlavor == Flavor.dev,
      routerConfig: AppRouter.appRouterConfig,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppTheme.backgroundGradient
                : AppTheme.lightBackgroundGradient,
          ),
          child: child,
        );
      },
    );
  }
}
