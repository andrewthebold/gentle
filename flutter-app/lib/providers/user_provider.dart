import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gentle/components/avatar.dart';
import 'package:gentle/models/user_model.dart';
import 'package:gentle/providers/auth_provider.dart';

class UserProvider extends ChangeNotifier {
  StreamSubscription<DocumentSnapshot> _userStream;
  UserModel _user;
  UserModel get user => _user;

  AvatarName _userAvatar = AvatarName.unknown;
  AvatarName get userAvatar => _userAvatar;

  @override
  void dispose() {
    if (_userStream != null) {
      _userStream.cancel();
      _userStream = null;
    }
    super.dispose();
  }

  /// Updater that listens to the auth state of the application changes.
  /// Updates the current user doc from Firestore if deemed relevant.
  void handleAuthUpdate(
      {@required AuthProvider authProvider, @required BuildContext context}) {
    final uid = authProvider?.firebaseUser?.uid;

    // If the authenticated user no longer exists
    if (uid == null) {
      // If we've stored a [UserModel], destroy it
      if (_user != null) {
        _user = null;
        notifyListeners();
      }
      return;
    }

    // If we have stored [UserModel] that's of the same uid, do nothing
    if (_user != null && _user.id == uid) {
      return;
    }

    // We have nowhere to visually show a failure as we're
    // above the first [Scaffold] in the stack. So, we let
    // this error bubble up as it's actually fatal.
    _dangerousStartUserListener(uid: uid, context: context);
  }

  void markUserAsDeleted() {
    _user = null;
    notifyListeners();
  }

  Future<void> _dangerousStartUserListener(
      {@required String uid, @required BuildContext context}) async {
    final db = Firestore.instance;

    _userStream = db
        .collection('users')
        .document(uid)
        .snapshots()
        .listen(_dangerousHandleUserStream);
  }

  void _dangerousHandleUserStream(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return;
    }

    final newUser = UserModel.fromFirestore(snapshot);

    if (_user == newUser) {
      return;
    }

    _user = newUser;
    _userAvatar = Avatar.getAvatarNameFromUID(_user.id);
    notifyListeners();
  }
}
