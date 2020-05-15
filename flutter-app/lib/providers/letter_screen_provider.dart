import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/components/avatar.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/letter_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/models/user_model.dart';

enum LetterScreenErrorStatus {
  none,
  deleted,
  offline,
}

class LetterScreenProvider extends ChangeNotifier {
  final Firestore _db = Firestore.instance;

  UserModel _user;

  List<String> _letterIDs;
  List<ReactionType> _letterReactions;

  int _letterCursor = 0;
  ReactionType get nextLetterReaction {
    if (_letterReactions == null || _letterReactions.isEmpty) {
      return null;
    }
    if (_letterCursor == _letterIDs.length - 1) {
      return null;
    }

    return _letterReactions.elementAt(_letterCursor + 1);
  }

  LetterModel _letter;
  LetterModel get letter => _letter;

  bool _shouldShowLetterLoading = false;
  bool get shouldShowLetterLoading => _shouldShowLetterLoading;

  bool _isReadyToShowLetter = false;
  bool get isReadyToShowLetter => _isReadyToShowLetter;

  LetterScreenErrorStatus _errorStatus = LetterScreenErrorStatus.none;
  LetterScreenErrorStatus get errorStatus => _errorStatus;

  Timer _loadingTimer;
  Timer _showTimer;

  bool get hasMoreLetters => _letterCursor < _letterIDs.length - 1;

  bool get canReportLetter =>
      _user != null &&
      _letter != null &&
      (_letter.letterSenderID != _user.id &&
          _letter.letterSenderAvatar != AvatarName.gentle);

  bool get letterAllowsReactions =>
      _user != null &&
      _letter != null &&
      _letter.letterSenderAvatar != AvatarName.gentle;

  bool get letterHasReaction =>
      _letter != null &&
      _letter.reactionType != null &&
      _letter.reactionTime != null;

  bool get userCanReactToLetter =>
      _letter != null && _user != null && _letter.letterSenderID != _user.id;

  LetterScreenProvider({
    @required BuildContext context,
    @required List<String> letterIDs,
    @required List<ReactionType> letterReactions,
  }) {
    if (_letterReactions != null) {
      assert(_letterIDs.length == _letterReactions.length,
          "Created letter screen provider with mismatching number of letterIDs and reactions");
    }
    _letterIDs = letterIDs;
    _letterReactions = letterReactions;
    _startFetch(context: context, letterID: letterIDs[0]);
  }

  @override
  void dispose() {
    _clearLoadingTimer();
    super.dispose();
  }

  void _startFetch(
      {@required BuildContext context, @required String letterID}) {
    // Give a short timeout before showing the loading screen
    _loadingTimer = Timer(Constants.loadShimmerDelayDuration, () {
      _shouldShowLetterLoading = true;
      if (_loadingTimer != null) {
        _loadingTimer.cancel();
        _loadingTimer = null;
      }
      notifyListeners();
    });

    _fetchLetter(
      context: context,
      letterID: letterID,
    );
  }

  Future<void> handleUserProviderUpdate({@required UserModel user}) async {
    if (user == null) {
      return;
    }

    if (user == _user) {
      return;
    }

    _user = user;
  }

  void markHeroAnimationCompleted() {
    _showTimer = Timer(const Duration(milliseconds: 400), () {
      _isReadyToShowLetter = true;
      _showTimer.cancel();
      _showTimer = null;
      notifyListeners();
    });
  }

  Future<void> _fetchLetter(
      {@required BuildContext context, @required String letterID}) async {
    try {
      final doc = await _db.collection('letters').document(letterID).get();

      if (!doc.exists) {
        _clearLoadingTimer();
        _errorStatus = LetterScreenErrorStatus.deleted;
        notifyListeners();
        return;
      }

      _letter = LetterModel.fromFirestore(doc);

      _clearLoadingTimer();
      notifyListeners();
    } on Exception catch (exception, stackTrace) {
      _clearLoadingTimer();

      // Handle known exceptions
      if (exception is PlatformException) {
        // Hacky check for offline status as proper codes aren't exposed
        if (exception.code == 'Error 14' ||
            exception.message.contains('offline')) {
          _errorStatus = LetterScreenErrorStatus.offline;
          notifyListeners();
          return;
        }
      }

      await ErrorBottomSheet.reportAndShow(context,
          LetterFetchException(capturedException: exception), stackTrace);
    }
  }

  void manualUpdateLetter(LetterModel newLetter) {
    _letter = newLetter;
    notifyListeners();
  }

  void _clearLoadingTimer() {
    if (_loadingTimer != null) {
      _loadingTimer.cancel();
      _loadingTimer = null;
    }
  }

  Future<void> refetch({
    @required BuildContext context,
    @required String letterID,
  }) async {
    _errorStatus = LetterScreenErrorStatus.none;
    _shouldShowLetterLoading = false;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _startFetch(context: context, letterID: letterID);
  }

  void handleReportingEnded({
    @required BuildContext context,
  }) {
    if (_user == null || _letter == null) {
      return;
    }

    // Automatically close the letter screen if the letter was marked hidden
    if (_user.hiddenLetters.contains(_letter.id) ||
        _user.blockedUsers.contains(_letter.letterSenderID)) {
      Navigator.of(context).pop();
    }
  }

  void onPressedNext(BuildContext context) {
    if (_letterCursor == _letterIDs.length - 1) {
      return;
    }

    _clearLoadingTimer();
    _letter = null;
    notifyListeners();

    _letterCursor += 1;
    _startFetch(context: context, letterID: _letterIDs[_letterCursor]);
  }
}
