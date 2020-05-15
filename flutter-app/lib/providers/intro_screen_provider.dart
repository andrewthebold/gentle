import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/effects.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/providers/auth_provider.dart';
import 'package:gentle/providers/user_provider.dart';

enum IntroScreenStatus {
  checking,
  loading,
}

class IntroScreenProvider extends ChangeNotifier {
  IntroScreenStatus _status = IntroScreenStatus.checking;
  IntroScreenStatus get status => _status;

  final List<bool> _checked = [false, false, false];
  List<bool> get checked => _checked;

  bool get showContinue =>
      !_checked.any((box) => !box) && _status == IntroScreenStatus.checking;
  bool get showLoading => _status == IntroScreenStatus.loading;

  AuthProvider _authProvider;
  UserProvider _userProvider;

  BuildContext _context;

  void handleAuthProviderUpdate({
    @required AuthProvider authProvider,
    @required UserProvider userProvider,
    @required BuildContext context,
  }) {
    bool needsRebuild = false;
    if (_authProvider != authProvider) {
      _authProvider = authProvider;
      needsRebuild = true;
    }

    if (_userProvider != userProvider) {
      _userProvider = userProvider;
      needsRebuild = true;
    }

    if (_context != context) {
      _context = context;
      needsRebuild = true;
    }

    if (needsRebuild) {
      notifyListeners();
    }
  }

  void toggleCheckbox({
    @required int index,
    @required bool newValue,
  }) {
    if (_checked[index] != newValue) {
      _checked[index] = newValue;
      notifyListeners();
    }
  }

  Future<void> createAccount() async {
    if (_authProvider == null) {
      return;
    }

    _status = IntroScreenStatus.loading;
    notifyListeners();

    // If the user already exists (for some reason), we should just skip ahead to success
    if (_userProvider != null && _userProvider.user != null) {
      _handleNewUser();
    }

    try {
      await _authProvider.dangerousSignIn();

      // Setup a listener to wait for the new user model to be created
      // -> a bit convoluted; the logic could be simplified?
      _userProvider.addListener(_handleNewUser);
    } on Exception catch (exception, stackTrace) {
      await ErrorBottomSheet.reportAndShow(_context,
          AuthSignInException(capturedException: exception), stackTrace);

      // Reset flow
      _status = IntroScreenStatus.checking;
      notifyListeners();
      return;
    }
  }

  Future<void> _handleNewUser() async {
    if (_userProvider.user != null) {
      Navigator.popUntil(_context, (route) => route.isFirst);
      await Effects.playHapticSuccess();
    }
    _userProvider.removeListener(_handleNewUser);
  }
}
