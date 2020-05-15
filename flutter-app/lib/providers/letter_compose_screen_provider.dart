import 'dart:async';

import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/effects.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/letter_model.dart';
import 'package:gentle/models/request_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/screens/letter_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:characters/characters.dart';

enum LetterComposeStatus {
  animatingIn,
  writing,
  delayBeforeSend,
  sending,
  sendSuccess,
  animatingOut,
}

class LetterComposeScreenProvider extends ChangeNotifier {
  final RequestItemModel requestItem;

  UserProvider _userProvider;

  LetterComposeStatus _status = LetterComposeStatus.animatingIn;
  LetterComposeStatus get status => _status;

  TextEditingController _textEditingController;
  TextEditingController get textEditingController => _textEditingController;

  FocusNode _focusNode;
  FocusNode get focusNode => _focusNode;

  int _characterCount = 0;
  int get characterCount => _characterCount;

  bool _sendingEnabled = false;
  bool get sendingEnabled => _sendingEnabled;

  int _sendTimeRemaining;
  int get sendTimeReminaing => _sendTimeRemaining;

  Timer _sendingTimer;

  LetterComposeScreenProvider({
    @required this.requestItem,
  }) {
    _initTextEditingController();
  }

  @override
  void dispose() {
    if (_sendingTimer != null) {
      _sendingTimer.cancel();
      _sendingTimer = null;
    }
    super.dispose();
  }

  void handleUpdateUserModel({@required UserProvider userProvider}) {
    if (_userProvider?.user == userProvider?.user) {
      return;
    }

    _userProvider = userProvider;
  }

  void markHeroAnimCompleted() {
    _status = LetterComposeStatus.writing;
    notifyListeners();
  }

  void markSending() {
    _status = LetterComposeStatus.delayBeforeSend;
    notifyListeners();
  }

  void markAnimatingOut() {
    _status = LetterComposeStatus.animatingOut;
    notifyListeners();
  }

  Future<void> _initTextEditingController() async {
    final prefs = await SharedPreferences.getInstance();
    final draftRequestID =
        prefs.getString(SharedPreferenceKeys.replyDraftRequest);
    final draft = prefs.getString(SharedPreferenceKeys.replyDraft);

    final willLoadDraft = draftRequestID != null &&
        draftRequestID == requestItem.id &&
        draft != null;

    _textEditingController = TextEditingController(
      text: willLoadDraft ? draft : '',
    )..addListener(_onTextChange);

    _focusNode = FocusNode();

    if (willLoadDraft) {
      _characterCount = draft.characters.length;
      _sendingEnabled = _characterCount > 0;
    }
  }

  void _onTextChange() {
    if (_textEditingController == null || _focusNode == null) {
      return;
    }

    final newCharacterCount =
        _textEditingController.value.text.characters.length;
    if (newCharacterCount != _characterCount) {
      _characterCount = newCharacterCount;
      _sendingEnabled = _characterCount > 0;
      notifyListeners();
    }
  }

  Future<bool> saveDraft() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await prefs.setString(
          SharedPreferenceKeys.replyDraftRequest, requestItem.id);
      await prefs.setString(
          SharedPreferenceKeys.replyDraft, _textEditingController.text);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> sendLetter(
      BuildContext context, ScrollController scrollController) async {
    _sendTimeRemaining = Constants.sendDelayDuration;
    _sendingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      // Kill the timer after it's complete
      _sendingTimer.cancel();
      _sendingTimer = null;

      // User can no longer cancel sending
      _status = LetterComposeStatus.sending;
      notifyListeners();

      await _onSendingTimerEnd(context, scrollController);
    });
  }

  Future<void> _onSendingTimerEnd(
      BuildContext context, ScrollController scrollController) async {
    try {
      await LetterModel.dangerousCommitNewLetter(
        requestID: requestItem.id,
        requestMessage: requestItem.requestMessage,
        user: _userProvider.user,
        senderAvatarName: _userProvider.userAvatar,
        recipientID: requestItem.requesterID,
        recipientAvatar: requestItem.requesterAvatar,
        letterMessage: _textEditingController.text,
      );
    } on Exception catch (exception, stackTrace) {
      if (exception is GentleException) {
        await ErrorBottomSheet.reportAndShow(context, exception, stackTrace);
      } else {
        await ErrorBottomSheet.reportAndShow(context,
            LetterCreateException(capturedException: exception), stackTrace);
      }

      _status = LetterComposeStatus.writing;
      notifyListeners();
      scrollController.animateTo(
          Constants.requestCardHeight + LetterScreen.requestCardTopPadding,
          duration: Constants.mediumAnimDuration,
          curve: Curves.fastLinearToSlowEaseIn);
      return;
    }

    await Effects.playHapticSuccess();

    _status = LetterComposeStatus.sendSuccess;
    notifyListeners();

    // Provide some delay for the sending animation to play out
    Timer(const Duration(milliseconds: 750), () {
      Navigator.of(context).pop();
    });
  }

  void cancelSend() {
    if (_status != LetterComposeStatus.delayBeforeSend) {
      return;
    }

    if (_sendingTimer != null) {
      _sendingTimer.cancel();
      _sendingTimer = null;
    }

    _status = LetterComposeStatus.writing;
    notifyListeners();
  }
}
