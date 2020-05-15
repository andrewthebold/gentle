import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  StreamSubscription<FirebaseUser> _stream;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;
  FirebaseUser _firebaseUser;

  bool _initialized = false;
  bool get initialized => _initialized;
  FirebaseUser get firebaseUser => _firebaseUser;

  AuthProvider() {
    _getCurrentUser();
    _stream = _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  Future<void> _getCurrentUser() async {
    _firebaseUser = await _auth.currentUser();
    _initialized = true;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(FirebaseUser user) async {
    if (_firebaseUser != user) {
      _firebaseUser = user;
      notifyListeners();
    }
  }

  // Creates account for client (or fetches existing account)
  Future<void> dangerousSignIn() async {
    final currentUser = await _auth.currentUser();
    if (_firebaseUser != null &&
        currentUser != null &&
        _firebaseUser == currentUser) {
      notifyListeners();
      return;
    }

    // Create an anonymous user if we can't find an existing one
    final result = await _auth.signInAnonymously();
    _firebaseUser = result.user;
  }

  Future<void> dangerousDeleteUser() async {
    final currentUser = await _auth.currentUser();
    if (_firebaseUser == null && currentUser == null) {
      notifyListeners();
      return;
    }

    await _firebaseUser.delete();
    _firebaseUser = null;

    // Clear all shared prefs on delete
    // https://stackoverflow.com/questions/54327164/flutter-remove-all-saved-shared-preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
