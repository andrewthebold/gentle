import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:sentry/sentry.dart';

class ErrorReporter {
  static const dsn = '<REDACTED>';

  SentryClient _sentryClient;

  bool get isInDebugMode {
    var inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  ErrorReporter() {
    PackageInfo.fromPlatform().then((packageInfo) {
      _sentryClient = SentryClient(
        dsn: ErrorReporter.dsn,
        environmentAttributes: Event(
          release: '${packageInfo.version}+${packageInfo.buildNumber}',
        ),
      );
    });
  }

  Future<void> reportError(dynamic error, dynamic stackTrace) async {
    if (isInDebugMode) {
      debugPrint('[ER] Building error report: $error');
      debugPrint('[ER] Stacktrace: $stackTrace');
      debugPrint('[ER] Ignoring error as we\'re in debug mode.');
      return;
    }

    final response = await _sentryClient.captureException(
      exception: error,
      stackTrace: stackTrace,
    );

    if (response.isSuccessful) {
      debugPrint('[ER] Report success! Event ID: ${response.eventId}');
    } else {
      debugPrint('[ER] Failed to report to Sentry.io: ${response.error}');
    }
  }
}
