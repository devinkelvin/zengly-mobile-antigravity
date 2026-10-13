import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const isFirstTimeUser = "isFirstTimeUser";
  static const isFirstOpen = "isFirstOpen";
  static const token = 'token';
  static const refreshToken = "refreshToken";
  static const user = 'user';
  static const loginPin = 'loginPin';
  static const locale = 'locale';
  static const themeMode = 'themeMode';
  static const hideVanitiIntro = 'hideVanitiIntro';

  static AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);
  final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: _getAndroidOptions(),
  );

  Future<void> writeData(String key, dynamic value) async {
    await _storage.write(key: key, value: value.toString());
  }

  Future<String?> readData(String key) async {
    final data = await _storage.read(key: key);
    return data;
  }

  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAllData() async {
    await _storage.deleteAll();
  }
}
