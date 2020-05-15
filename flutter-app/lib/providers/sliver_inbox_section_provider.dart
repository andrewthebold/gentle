import 'dart:async';

import 'package:gentle/exceptions.dart';
import 'package:gentle/models/user_model.dart';
import 'package:gentle/providers/global_provider.dart';
import 'package:gentle/providers/inbox_slot_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gentle/providers/local_reaction_provider.dart';

enum InboxStatus {
  uninitialized,

  /// We are loading the inbox
  loading,

  /// Inbox has completed its first fetch of data
  ready,
}

class SliverInboxSectionProvider extends ChangeNotifier {
  final Firestore _db = Firestore.instance;
  GlobalProvider _globalProvider;
  LocalReactionProvider _localReactionProvider;
  LocalReactionProvider get localReactionProvider => _localReactionProvider;
  UserModel _user;

  InboxStatus _status = InboxStatus.uninitialized;
  final List<InboxSlotProvider> _slotProviders = [];
  final List<String> _trackedItemIDs = [];
  final List<String> _deletedIDs = [];
  final List<DocumentSnapshot> _docQueue = [];
  int _slotCount;
  StreamSubscription<QuerySnapshot> _newItemStream;

  InboxStatus get status => _status;
  UserModel get user => _user;
  bool get isEmpty =>
      _slotProviders.where((slot) => slot.currentItem != null).isEmpty;
  List<String> get deletedIDs => _deletedIDs;

  SliverInboxSectionProvider({@required int slotCount}) {
    _slotCount = slotCount;

    for (var i = 0; i < slotCount; i++) {
      _slotProviders.add(InboxSlotProvider(inboxProvider: this));
    }
  }

  @override
  void dispose() {
    if (_newItemStream != null) {
      _newItemStream.cancel();
      _newItemStream = null;
    }

    if (_slotProviders.isNotEmpty) {
      for (final slot in _slotProviders) {
        slot.dispose();
      }
    }

    super.dispose();
  }

  InboxSlotProvider getSlotProvider(int slotIndex) =>
      slotIndex > _slotProviders.length
          ? null
          : _slotProviders.elementAt(slotIndex);

  void updateDependentProviders({
    @required UserModel user,
    @required GlobalProvider globalProvider,
    @required LocalReactionProvider localReactionProvider,
    @required BuildContext context,
  }) {
    if (_user != user) {
      final oldUser = _user;
      // Mark other slots as read if you block a user
      _user = user;

      if (_user != null &&
          oldUser != null &&
          _user.blockedUsers != oldUser.blockedUsers) {
        _handleUpdatedBlockedUsers(
            context: context, blockedUsers: _user.blockedUsers);
      }
    }

    _globalProvider = globalProvider;
    _localReactionProvider = localReactionProvider;

    if (_status == InboxStatus.uninitialized && _user != null) {
      _fetchInitialItems();
    }
  }

  Future<void> _fetchInitialItems() async {
    _status = InboxStatus.loading;
    notifyListeners();

    try {
      _newItemStream = _db
          .collection('users')
          .document(_user.id)
          .collection('inbox')
          .orderBy('creationDate', descending: true)
          .limit(_slotCount)
          .snapshots()
          .listen(_handleNewItemStream);
    } on Exception catch (error) {
      throw InboxInitException(capturedException: error);
    }
  }

  void _handleNewItemStream(QuerySnapshot snapshot) {
    // We only care about docs that are untracked and undeleted
    final newDocs = snapshot.documents.where((doc) =>
        !_trackedItemIDs.contains(doc.documentID) &&
        !_deletedIDs.contains(doc.documentID));

    for (final doc in newDocs) {
      _docQueue.add(doc);
      _trackedItemIDs.add(doc.documentID);
    }

    _status = InboxStatus.ready;
    notifyListeners();
    processQueue();
  }

  void markIDDeleted(String docID) {
    if (!_trackedItemIDs.contains(docID)) {
      throw InboxItemDeletionException(
        message: 'Attempted to delete item ($docID) that\'s not being tracked.',
      );
    }
    if (_deletedIDs.contains(docID)) {
      throw InboxItemDeletionException(
        message:
            'Attempted to delete item ($docID) that\'s already marked as deleted.',
      );
    }

    _deletedIDs.add(docID);
  }

  /// Attempts to place queued inbox item docs into any available slots.
  void processQueue() {
    final availableSlots =
        _slotProviders.where((provider) => provider.isEmpty).toList();

    if (availableSlots.isEmpty || _docQueue.isEmpty) {
      _globalProvider.markInboxHasItems(hasItems: !isEmpty);
      notifyListeners();
      return;
    }

    // Fill in any empty slots with any queued items
    for (final slot in availableSlots) {
      final doc = _docQueue.isNotEmpty ? _docQueue.removeAt(0) : null;
      if (doc != null) {
        slot.updateItem(doc: doc);
      }
    }

    _globalProvider.markInboxHasItems(hasItems: !isEmpty);
    notifyListeners();
  }

  void _handleUpdatedBlockedUsers({
    @required BuildContext context,
    @required List<String> blockedUsers,
  }) {
    final filledSlots = _slotProviders.where((provider) =>
        !provider.isEmpty &&
        blockedUsers.contains(provider.currentItem.linkedContentCreatorID));
    for (final slot in filledSlots) {
      if (!slot.markingRead) {
        slot.markRead(context: context);
      }
    }
  }
}
