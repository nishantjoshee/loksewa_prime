import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/error_reporter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorReporter.init();
  runApp(const ProviderScope(child: App()));
}
