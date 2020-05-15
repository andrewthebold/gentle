import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/effects.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/providers/auth_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/screens/login_screen.dart';

enum DeleteBottomsheetStatus {
  ready,
  loading,
}

class DeleteBottomsheetProvider extends ChangeNotifier {
  DeleteBottomsheetStatus _status = DeleteBottomsheetStatus.ready;
  DeleteBottomsheetStatus get status => _status;
  AuthProvider _authProvider;
  UserProvider _userProvider;

  void handleAuthProviderUpdate({
    @required AuthProvider authProvider,
    @required UserProvider userProvider,
  }) {
    if (_authProvider != authProvider) {
      _authProvider = authProvider;
    }

    if (_userProvider != userProvider) {
      _userProvider = userProvider;
    }

    notifyListeners();
  }

  Future<void> handleDelete({
    @required BuildContext context,
  }) async {
    if (_authProvider == null || _userProvider == null) {
      return;
    }

    _status = DeleteBottomsheetStatus.loading;
    notifyListeners();

    try {
      await _authProvider.dangerousDeleteUser();
      _userProvider.markUserAsDeleted();
    } on Exception catch (exception, stackTrace) {
      await ErrorBottomSheet.reportAndShow(context,
          AuthDeleteUserException(capturedException: exception), stackTrace);

      _status = DeleteBottomsheetStatus.ready;
      notifyListeners();
      return;
    }

    await Effects.playHapticSuccess();
    Navigator.pushNamedAndRemoveUntil(
        context, IntroScreen.routeName, (route) => route.isFirst);
  }
}
