import 'package:flutter/material.dart';

class GentleException implements Exception {
  final Exception capturedException;
  final String message;

  const GentleException({
    this.capturedException,
    this.message,
  });

  @override
  String toString() {
    if (capturedException != null) {
      String output = '$capturedException';

      if (message != null) {
        output = '$output: $message';
      }

      return output;
    }

    if (message != null) {
      return '$message';
    }

    return "Unknown exception";
  }

  String toVisibleString() {
    if (capturedException != null) {
      return '$capturedException';
    }

    if (message != null) {
      return '$message';
    }

    return "Unknown exception";
  }
}

class FixMePlaceholderGentleException extends GentleException {
  FixMePlaceholderGentleException()
      : super(message: 'FIXME: This is a placeholder error message.');
}

class ErrorReportEmailLaunchException extends GentleException {
  ErrorReportEmailLaunchException()
      : super(message: 'Failed to launch new email URL.');
}

// =============================================================================
// Report Exceptions
// =============================================================================

class ReportCreateException extends GentleException {
  const ReportCreateException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class ReportInvalidDataException extends GentleException {
  const ReportInvalidDataException({
    @required String message,
  }) : super(message: message);
}

// =============================================================================
// Auth Exceptions
// =============================================================================

class AuthSignInException extends GentleException {
  const AuthSignInException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class AuthInvalidSignInException extends GentleException {
  const AuthInvalidSignInException({
    @required String message,
  }) : super(message: message);
}

class AuthDeleteUserException extends GentleException {
  const AuthDeleteUserException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class AuthInvalidDeleteUserException extends GentleException {
  const AuthInvalidDeleteUserException({
    @required String message,
  }) : super(message: message);
}

// =============================================================================
// User Exceptions
// =============================================================================

class UserFetchException extends GentleException {
  const UserFetchException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class UserBlockInvalidDataException extends GentleException {
  const UserBlockInvalidDataException({
    @required String message,
  }) : super(message: message);
}

class UserHideContentInvalidDataException extends GentleException {
  const UserHideContentInvalidDataException({
    @required String message,
  }) : super(message: message);
}

class UserCompleteRequestInvalidDataException extends GentleException {
  const UserCompleteRequestInvalidDataException({
    @required String message,
  }) : super(message: message);
}

// =============================================================================
// Letter Exceptions
// =============================================================================

class LetterCreateException extends GentleException {
  const LetterCreateException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class LetterCommitException extends GentleException {
  const LetterCommitException({
    @required Exception capturedException,
    String message = '',
  }) : super(capturedException: capturedException, message: message);
}

class LetterCreateInvalidDataException extends GentleException {
  const LetterCreateInvalidDataException({
    @required String message,
  }) : super(message: message);
}

class LetterFetchException extends GentleException {
  const LetterFetchException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class LetterReactException extends GentleException {
  const LetterReactException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class LetterReactInvalidDataException extends GentleException {
  const LetterReactInvalidDataException({
    @required String message,
  }) : super(message: message);
}

// =============================================================================
// Request Exceptions
// =============================================================================

class RequestDuplicateFetchException extends GentleException {
  const RequestDuplicateFetchException({
    @required String message,
  }) : super(message: message);
}

class RequestFetchException extends GentleException {
  const RequestFetchException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class RequestDraftClearException extends GentleException {
  RequestDraftClearException()
      : super(message: 'Failed to clear new request draft.');
}

class RequestSendException extends GentleException {
  const RequestSendException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class RequestCommitException extends GentleException {
  const RequestCommitException({
    @required Exception capturedException,
    String message = '',
  }) : super(capturedException: capturedException, message: message);
}

// =============================================================================
// Inbox Exceptions
// =============================================================================

class InboxLayoutException extends GentleException {
  const InboxLayoutException({
    @required String message,
  }) : super(message: message);
}

class InboxInitException extends GentleException {
  const InboxInitException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class InboxItemDeletionException extends GentleException {
  const InboxItemDeletionException({
    @required String message,
  }) : super(message: message);
}

class InboxReadException extends GentleException {
  const InboxReadException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class InboxReadInvalidDataException extends GentleException {
  const InboxReadInvalidDataException({
    @required String message,
  }) : super(message: message);
}

// =============================================================================
// Reaction Inbox Exceptions
// =============================================================================
class ReactionInboxDeleteInvalidDataException extends GentleException {
  const ReactionInboxDeleteInvalidDataException({
    @required String message,
  }) : super(message: message);
}

class ReactionInboxDeleteException extends GentleException {
  const ReactionInboxDeleteException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

// =============================================================================
// Activity Log Exceptions
// =============================================================================

class ActivityLogInitException extends GentleException {
  const ActivityLogInitException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class ActivityLogPaginationException extends GentleException {
  const ActivityLogPaginationException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class ActivityLogFirstItemListenerException extends GentleException {
  const ActivityLogFirstItemListenerException({
    @required Exception capturedException,
  }) : super(capturedException: capturedException);
}

class ActivityLogCreateInvalidDataException extends GentleException {
  const ActivityLogCreateInvalidDataException({
    @required String message,
  }) : super(message: message);
}
