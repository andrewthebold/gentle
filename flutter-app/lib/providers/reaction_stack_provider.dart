import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/local_reaction_model.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/models/user_model.dart';
import 'package:gentle/providers/local_reaction_provider.dart';
import 'package:gentle/route_generator.dart';
import 'package:gentle/screens/letter_screen.dart';

enum ReactionStackStatus {
  uninitialized,
  loading,
  ready,
}

class ReactionStackProvider extends ChangeNotifier {
  final Firestore _db = Firestore.instance;
  ReactionStackStatus _status = ReactionStackStatus.uninitialized;

  final List<ReactionInboxItemModel> _reactions = [];
  List<ReactionInboxItemModel> get reactions => _reactions;

  final List<String> _trackedItemIDs = [];

  StreamSubscription<QuerySnapshot> _newItemStream;

  UserModel _user;
  LocalReactionProvider _localReactionProvider;

  @override
  void dispose() {
    if (_newItemStream != null) {
      _newItemStream.cancel();
      _newItemStream = null;
    }
    super.dispose();
  }

  void updateDependentData({
    @required UserModel user,
    @required LocalReactionProvider localReactionProvider,
  }) {
    if (_user != user) {
      _user = user;

      if (_status == ReactionStackStatus.uninitialized) {
        _initItemStream();
      }
    }

    if (_localReactionProvider != localReactionProvider) {
      _localReactionProvider = localReactionProvider;
    }
  }

  Future<void> _initItemStream() async {
    if (_status != ReactionStackStatus.uninitialized) {
      return;
    }

    if (_user == null) {
      return;
    }

    _status = ReactionStackStatus.loading;
    notifyListeners();

    _newItemStream = _db
        .collection("users")
        .document(_user.id)
        .collection('reactionInbox')
        .orderBy('creationDate')
        .snapshots()
        .listen(_handleNewItemStream);

    _status = ReactionStackStatus.ready;
    notifyListeners();
  }

  /// Processes new reaction items from the reactionInbox listener.
  ///
  /// We intentionally only care about *new* items to avoid the complexity
  /// of Firestore's document change api. Instead, we manually track deleted
  /// items throughout the duration of a session and rely on new data replacing
  /// the old on reload.
  void _handleNewItemStream(QuerySnapshot snapshot) {
    // Do nothing if there are no items
    if (snapshot.documents.isEmpty) {
      return;
    }

    bool didAddNewItem = false;

    for (final doc in snapshot.documents) {
      // Ignore already tracked items
      if (_trackedItemIDs.contains(doc.documentID)) {
        continue;
      }

      try {
        final newItem = ReactionInboxItemModel.fromFirestore(doc);
        _reactions.add(newItem);
        _trackedItemIDs.add(doc.documentID);
        didAddNewItem = true;

        // Also add to local reaction store to update dependent UI
        _localReactionProvider.addLocalReaction(LocalReactionModel(
          reactionType: newItem.type,
          reactionTime: newItem.creationDate,
          linkedLetterID: newItem.linkedContentID,
        ));
      } on Exception catch (exception) {
        debugPrint(
            'Exception when trying to parse and add reaction item: $exception');
        continue;
      }
    }

    if (didAddNewItem) {
      notifyListeners();
    }
  }

  Future<void> openStack(BuildContext context) async {
    if (_reactions.isEmpty) {
      return;
    }

    final openedReactions = _reactions.sublist(0);
    final letterIDs =
        openedReactions.map((reaction) => reaction.linkedContentID).toList();
    final letterReactions =
        openedReactions.map((reaction) => reaction.type).toList();

    await Navigator.of(context).pushNamed(
      LetterScreen.routeName,
      arguments: LetterScreenArguments(
        letterIDs: letterIDs,
        letterReactions: letterReactions,
        shouldShowRequest: true,
      ),
    );

    final allReactionsBeforeDelete = _reactions.sublist(0);
    for (final reaction in openedReactions) {
      _reactions.remove(reaction);
    }
    notifyListeners();

    // After looking at the reactions, delete them
    try {
      await ReactionInboxItemModel.dangerousDeleteReactions(
        user: _user,
        reactions: openedReactions,
      );
    } on Exception catch (exception, stackTrace) {
      await ErrorBottomSheet.reportAndShow(
        context,
        ReactionInboxDeleteException(capturedException: exception),
        stackTrace,
      );

      // If the delete fails, revert the removal of the openedreactions
      _reactions.clear();
      _reactions.addAll(allReactionsBeforeDelete);
      notifyListeners();
    }
  }
}
