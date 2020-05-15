import 'dart:async';

import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/inbox_item_model.dart';
import 'package:gentle/providers/sliver_inbox_section_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum InboxSlotStatus {
  hidden,
  animatingIn,
  visible,
  animatingOut,
}

class InboxSlotProvider extends ChangeNotifier {
  bool _interactable = false;
  InboxItemModel _currentItem;
  SliverInboxSectionProvider _inboxProvider;
  InboxSlotStatus _status = InboxSlotStatus.hidden;
  bool _markingRead = false;

  bool get interactable => _interactable;
  InboxItemModel get currentItem => _currentItem;
  InboxSlotStatus get status => _status;
  bool get envelopeVisible =>
      _currentItem != null &&
      (_status == InboxSlotStatus.animatingIn ||
          _status == InboxSlotStatus.visible);
  bool get isEmpty => _currentItem == null;
  bool get markingRead => _markingRead;

  InboxSlotProvider({
    @required SliverInboxSectionProvider inboxProvider,
  }) {
    _inboxProvider = inboxProvider;
  }

  Timer _removalDelayTimer;
  Timer _removalTimer;

  @override
  void dispose() {
    if (_removalDelayTimer != null) {
      _removalDelayTimer.cancel();
      _removalDelayTimer = null;
    }
    if (_removalTimer != null) {
      _removalTimer.cancel();
      _removalTimer = null;
    }
    super.dispose();
  }

  Future<void> markRead({
    @required BuildContext context,
  }) async {
    if (_markingRead ||
        _inboxProvider.user == null ||
        _currentItem == null ||
        _inboxProvider.deletedIDs.contains(_currentItem.id)) {
      return;
    }

    _markingRead = true;

    try {
      final linkedLocalReaction =
          _inboxProvider.localReactionProvider.localReactions.firstWhere(
        (reaction) => reaction.linkedLetterID == _currentItem.linkedContentID,
        orElse: () => null,
      );

      await InboxItemModel.dangerousCommitRead(
        user: _inboxProvider.user,
        item: _currentItem,
        reactionType: linkedLocalReaction?.reactionType,
      );
    } on Exception catch (exception, stackTrace) {
      await ErrorBottomSheet.reportAndShow(context,
          InboxReadException(capturedException: exception), stackTrace);
      _markingRead = false;
      return;
    }

    updateItem(doc: null);

    _inboxProvider.markIDDeleted(_currentItem.id);
    _markingRead = false;
  }

  void updateItem({@required DocumentSnapshot doc}) {
    if (_currentItem != null && doc == null) {
      _initiateItemRemoval();
      return;
    }

    // Set the new item and make visible!
    _initNewItem(doc);
  }

  void _initNewItem(DocumentSnapshot doc) {
    _currentItem = InboxItemModel.fromFirestore(doc);
    _interactable = true;
    _status = InboxSlotStatus.visible;
    notifyListeners();
  }

  /// Deletion Step #1: Disables interactions with the inbox item
  void _initiateItemRemoval() {
    _interactable = false;
    notifyListeners();
    _removalDelayTimer = Timer(
      Constants.routeChangeDuration,
      _handleRemovalDelayTimerEnd,
    );
  }

  /// Deletion Step #2: Hide the inbox item
  void _handleRemovalDelayTimerEnd() {
    _removalDelayTimer.cancel();
    _removalDelayTimer = null;

    _status = InboxSlotStatus.hidden;
    _removalTimer = Timer(
      Constants.envelopeAppearDuration + Constants.envelopeSwapDelayDuration,
      _handleRemovalTimerEnd,
    );
    notifyListeners();
  }

  /// Deletion Step #3: Swap current item with a queued item if available,
  ///   otherwise destroy the removed item.
  void _handleRemovalTimerEnd() {
    _removalTimer.cancel();
    _removalTimer = null;
    _currentItem = null;

    _inboxProvider.processQueue();
  }
}
