import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
}
