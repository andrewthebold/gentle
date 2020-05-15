import 'dart:async';

import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/effects.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/request_item_model.dart';
import 'package:flutter/material.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:characters/characters.dart';

enum RequestComposeStatus {
  animatingIn,
  writing,
  delayBeforeSend,
  sending,
  sendSuccess,
  animatingOut,
}

class RequestComposeScreenProvider extends ChangeNotifier {
  RequestComposeScreenProvider() {
    _initTextEditingController();
  }

  void handleUpdateUserModel(UserProvider userProvider) {
    if (_userProvider == userProvider) {
      return;
    }

    _userProvider = userProvider;
  }

  @override
  void dispose() {
    if (_textEditingController != null) {
      _textEditingController.dispose();
    }

    if (_focusNode != null) {
      _focusNode.dispose();
    }

    super.dispose();
  }

  UserProvider _userProvider;

  RequestComposeStatus _status = RequestComposeStatus.animatingIn;
  RequestComposeStatus get status => _status;

  void markHeroAnimCompleted() {
    _status = RequestComposeStatus.writing;
    notifyListeners();
  }

  void markSending() {
    _status = RequestComposeStatus.delayBeforeSend;
    notifyListeners();
  }

  void markAnimatingOut() {
    _status = RequestComposeStatus.animatingOut;
    notifyListeners();
  }

  TextEditingController _textEditingController;
  TextEditingController get textEditingController => _textEditingController;

  FocusNode _focusNode;
  FocusNode get focusNode => _focusNode;

  int _characterCount = 0;
  int get characterCount => _characterCount;

  bool _sendingEnabled = false;
  bool get sendingEnabled => _sendingEnabled;

  Future<void> _initTextEditingController() async {
    final prefs = await SharedPreferences.getInstance();
    final draft = prefs.getString(SharedPreferenceKeys.requestDraft);

    _textEditingController = TextEditingController(
      text: draft ?? '',
    )..addListener(_onTextChange);

    _focusNode = FocusNode();

    if (draft != null) {
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
    return prefs.setString(
      SharedPreferenceKeys.requestDraft,
      _textEditingController.text,
    );
  }

  Future<void> sendRequest(BuildContext context) async {
    // Start a timer to let users cancel
    _sendTimeRemaining = Constants.sendDelayDuration;
    _sendingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_sendTimeRemaining > 0) {
        _sendTimeRemaining -= 1;
        notifyListeners();
        return;
      }

      // Kill the timer after it's complete
      _sendingTimer.cancel();
      _sendingTimer = null;

      await _onSendingTimerEnd(context);
    });
  }

  Future<void> _onSendingTimerEnd(BuildContext context) async {
    // User can no longer cancel sending
    _status = RequestComposeStatus.sending;
    notifyListeners();

    try {
      await RequestItemModel.dangerousCommitNewRequest(
        user: _userProvider.user,
        requesterAvatar: _userProvider.userAvatar,
        requestMessage: _textEditingController.text,
      );
    } on Exception catch (exception, stackTrace) {
      if (exception is GentleException) {
        await ErrorBottomSheet.reportAndShow(context, exception, stackTrace);
      } else {
        await ErrorBottomSheet.reportAndShow(context,
            RequestSendException(capturedException: exception), stackTrace);
      }

      _status = RequestComposeStatus.writing;
      notifyListeners();
      return;
    }

    // On success, clear our saved draft
    bool clearedDraft = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      clearedDraft = await prefs.remove(SharedPreferenceKeys.requestDraft);
    } on Exception catch (exception, stackTrace) {
      await ErrorBottomSheet.reportAndShow(
          context, RequestDraftClearException(), stackTrace);
    }

    if (!clearedDraft) {
      await ErrorBottomSheet.reportAndShow(
          context, RequestDraftClearException(), null);
    }

    await Effects.playHapticSuccess();

    _status = RequestComposeStatus.sendSuccess;
    notifyListeners();

    Timer(const Duration(milliseconds: 750), () {
      Navigator.of(context).pop();
    });
  }

  Future<void> cancelSend() async {
    if (_status != RequestComposeStatus.delayBeforeSend) {
      return;
    }

    if (_sendingTimer != null) {
      _sendingTimer.cancel();
      _sendingTimer = null;
    }

    _status = RequestComposeStatus.writing;
    notifyListeners();
  }

  int _sendTimeRemaining;
  int get sendTimeReminaing => _sendTimeRemaining;

  Timer _sendingTimer;
}
