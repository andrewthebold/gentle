import 'package:flutter/material.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/services/error_reporter.dart';
import 'package:gentle/services/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorBottomSheetProvider extends ChangeNotifier {
  GentleException _exception;
  GentleException get exception => _exception;

  dynamic _stackTrace;

  ErrorBottomSheetProvider({GentleException exception, dynamic stackTrace}) {
    _exception = exception;
    _stackTrace = stackTrace;
    _sendBugReport();
  }

  Future<void> _sendBugReport() async {
    await sl<ErrorReporter>().reportError(_exception, _stackTrace);
  }

  Future<void> launchEmail() async {
    // TODO (Low): Move emailing to consolidated service/util fn
    const subject = 'I found a bug!';
    final body = 'The error message was: ${exception.message}';

    var gmailURL =
        'googlegmail:///co?to=<REDACTED>&subject=$subject&body=$body';
    gmailURL = Uri.encodeFull(gmailURL);

    if (await canLaunch(gmailURL)) {
      await launch(gmailURL);
      return;
    }

    var mailURL = 'mailto:<REDACTED>?subject=$subject&body=$body';
    mailURL = Uri.encodeFull(mailURL);

    if (await canLaunch(mailURL)) {
      await launch(mailURL);
    } else {
      throw ErrorReportEmailLaunchException();
    }
  }
}
