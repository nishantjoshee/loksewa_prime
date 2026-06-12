import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class ErrorReporter {
  ErrorReporter._();

  static void init() {
    FlutterError.onError = (details) {
      _log('FlutterError', details.exception, details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      _log('PlatformDispatcher', error, stack);
      return true;
    };
  }

  static void report(Object error, {StackTrace? stack}) {
    _log('AppError', error, stack);
  }

  static void _log(String source, Object error, StackTrace? stack) {
    developer.log(
      '[$source] $error',
      name: 'LoksewaPrime',
      error: error,
      stackTrace: stack,
    );
  }
}
