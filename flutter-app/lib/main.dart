import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gentle/app.dart';
import 'package:gentle/services/error_reporter.dart';
import 'package:gentle/services/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocater();
  final errorReporter = sl<ErrorReporter>();

  FlutterError.onError = (FlutterErrorDetails details) async {
    if (errorReporter.isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<void>>(() async {
    runApp(App());
  }, onError: (dynamic error, dynamic stackTrace) async {
    await errorReporter.reportError(error, stackTrace);
  });
}
