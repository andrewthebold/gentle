import 'package:flutter/material.dart';
import 'package:gentle/providers/auth_provider.dart';

class GlobalProvider extends ChangeNotifier {
  bool _sentMail = false;
  bool get sentMail => _sentMail;

  void handleAuthUpdate({
    @required AuthProvider authProvider,
  }) {
    // Reset instance if the user becomes null
    if (authProvider.firebaseUser == null) {
      _sentMail = false;
      _currentTabIndex = 0;
      notifyListeners();
    }
  }

  void markSentMail() {
    if (_sentMail) {
      return;
    }
    _sentMail = true;
    notifyListeners();
  }

  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTab(int newIndex) {
    if (newIndex == _currentTabIndex) {
      return;
    }
    _currentTabIndex = newIndex;
    notifyListeners();
  }

  bool _hasInboxItems = false;
  bool get hasInboxItems => _hasInboxItems;

  void markInboxHasItems({bool hasItems}) {
    if (_hasInboxItems == hasItems) {
      return;
    }
    _hasInboxItems = hasItems;
    notifyListeners();
  }
}
