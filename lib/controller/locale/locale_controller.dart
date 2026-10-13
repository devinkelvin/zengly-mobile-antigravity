import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _restoreLocale();
  }

  static const supportedLocales = {'English': 'en', 'French': 'fr'};

  Future<void> _restoreLocale() async {
    final savedCode = await LocalStorage().readData(LocalStorage.locale);
    if (savedCode != null) {
      state = Locale(savedCode);
    }
  }

  Future<void> setLanguage(String languageName) async {
    final code = supportedLocales[languageName] ?? 'en';
    state = Locale(code);
    await LocalStorage().writeData(LocalStorage.locale, code);
  }

  String get currentLanguageName =>
      supportedLocales.entries
          .firstWhere(
            (entry) => entry.value == state.languageCode,
            orElse: () => const MapEntry('English', 'en'),
          )
          .key;
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
