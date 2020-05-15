import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/effects.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/letter_model.dart';
import 'package:gentle/models/local_reaction_model.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/providers/letter_screen_provider.dart';
import 'package:gentle/providers/local_reaction_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReactionBottomsheetProvider extends ChangeNotifier {
  UserProvider _userProvider;
  LetterScreenProvider _letterScreenProvider;
  LocalReactionProvider _localReactionProvider;

  LetterModel get letter => _letterScreenProvider?.letter;

  ReactionType _currentReaction;
  ReactionType get currentReaction => _currentReaction;

  DateTime _currentReactionTime;
  DateTime get currentReactionTime => _currentReactionTime;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ReactionType _currentlySettingReaction;
  ReactionType get currentlySettingReaction => _currentlySettingReaction;

  bool get reactionsEnabled =>
      !_isLoading && _reactionsLeftToday != null && _reactionsLeftToday > 0;

  bool get userCanSelectReactions =>
      reactionsEnabled &&
      _currentReaction == null &&
      _currentlySettingReaction == null;

  bool get loveActive =>
      _currentReaction == ReactionType.love ||
      _currentlySettingReaction == ReactionType.love ||
      letter?.reactionType == ReactionType.love;

  bool get inspireActive =>
      _currentReaction == ReactionType.inspire ||
      _currentlySettingReaction == ReactionType.inspire ||
      letter?.reactionType == ReactionType.inspire;

  bool get thanksActive =>
      _currentReaction == ReactionType.thanks ||
      _currentlySettingReaction == ReactionType.thanks ||
      letter?.reactionType == ReactionType.thanks;

  int _reactionsLeftToday;
  int get reactionsLeftToday => _reactionsLeftToday;

  ReactionBottomsheetProvider({
    @required UserProvider userProvider,
    @required LetterScreenProvider letterScreenProvider,
    @required LocalReactionProvider localReactionProvider,
  }) {
    _userProvider = userProvider;
    _letterScreenProvider = letterScreenProvider;
    _localReactionProvider = localReactionProvider;
    _currentReaction = _letterScreenProvider.letter.reactionType;
    _currentReactionTime = _letterScreenProvider.letter.reactionTime;
    _getReactionAvailable();
  }

  Future<void> _getReactionAvailable() async {
    final prefs = await SharedPreferences.getInstance();

    // // Uncomment for testing purposes to reset the count for today
    // await prefs.setStringList(SharedPreferenceKeys.recentLetterReactTimes, []);

    final recentReactionTimes =
        prefs.getStringList(SharedPreferenceKeys.recentLetterReactTimes) ?? [];

    final parsedRecentReactionTimes =
        recentReactionTimes.map((e) => DateTime.parse(e));
    final now = DateTime.now();
    final lastMidnight = DateTime(now.year, now.month, now.day);
    final reactionsSinceLastMidnight =
        parsedRecentReactionTimes.where((time) => time.isAfter(lastMidnight));

    final remainingReactionCount =
        max(Constants.reactionsPerDay - reactionsSinceLastMidnight.length, 0);

    if (_reactionsLeftToday != remainingReactionCount) {
      _reactionsLeftToday = remainingReactionCount;
      notifyListeners();
    }
  }

  Future<void> sendReaction({
    @required BuildContext context,
    @required ReactionType type,
  }) async {
    if (type == ReactionType.unknown) {
      debugPrint("Attempted to send an unknown reaction");
      return;
    }

    if (_currentReaction != null) {
      debugPrint("Attempted to send a reaction when there already is one");
      return;
    }

    if (_isLoading) {
      return;
    }

    _isLoading = true;
    _currentlySettingReaction = type;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Commit update to letter (which will kick-off denormalizing updates in cloud function)
    try {
      await LetterModel.dangerousUpdateLetterReaction(
        letter: _letterScreenProvider.letter,
        user: _userProvider.user,
        reactionType: type,
      );
    } on Exception catch (exception, stackTrace) {
      await ErrorBottomSheet.reportAndShow(
        context,
        LetterReactException(
          capturedException: exception,
        ),
        stackTrace,
      );
      _isLoading = false;
      _currentlySettingReaction = null;
      notifyListeners();
      return;
    }

    // Locally update various stores so we don't have to listen to server changes
    final letter = _letterScreenProvider.letter;
    final reactionTime = DateTime.now();

    _letterScreenProvider.manualUpdateLetter(letter.copyWith(
      reactionType: type,
      reactionTime: reactionTime,
    ));

    _localReactionProvider.addLocalReaction(LocalReactionModel(
      reactionType: type,
      reactionTime: reactionTime,
      linkedLetterID: letter.id,
    ));

    // Record the timestamp
    final prefs = await SharedPreferences.getInstance();
    final recentReactionTimes =
        prefs.getStringList(SharedPreferenceKeys.recentLetterReactTimes) ?? [];

    recentReactionTimes.add(DateTime.now().toIso8601String());
    recentReactionTimes.sort((a, b) => b.compareTo(a));

    final mostRecentReactionTimes =
        recentReactionTimes.sublist(0, min(recentReactionTimes.length, 10));

    await prefs.setStringList(
        SharedPreferenceKeys.recentLetterReactTimes, mostRecentReactionTimes);

    _isLoading = false;
    _currentlySettingReaction = null;
    notifyListeners();

    Effects.playHapticSuccess();
    Navigator.of(context).pop();
  }
}
