import 'dart:developer';

import 'package:flutter/foundation.dart';

class AppLogger {
  static void logData(String data) {
    if (kDebugMode) {
      log("--------------This is a log----------------");
      log(data);
      log("-------------End of the log----------------");
    }
  }

  static void logError(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    log(
      '\x1B[31m❌ ERROR:\x1B[0m $message',
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }
}
