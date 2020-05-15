import 'dart:async';

import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/components/activity_log_list_item.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/activity_log_item_model.dart';
import 'package:gentle/models/local_reaction_model.dart';
import 'package:gentle/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

enum ActivityLogStatus {
  uninitialized,
  paginating,
  ready,
  endOfList,
}

class ActivityLogProvider extends ChangeNotifier {
  ActivityLogStatus _status = ActivityLogStatus.uninitialized;
  ActivityLogStatus get status => _status;

  final Firestore _db = Firestore.instance;
  StreamSubscription<QuerySnapshot> _firstItemStream;

  final List<ActivityLogItemModel> _items = [null];
  List<ActivityLogItemModel> get items => _items;

  DocumentSnapshot _lastDoc;
  UserModel _user;

  final GlobalKey<SliverAnimatedListState> listKey;
  final List<ActivityLogItemType> itemTypes;

  BuildContext _buildContext;

  ActivityLogProvider({
    @required this.listKey,
    @required this.itemTypes,
  })  : assert(listKey != null),
        assert(itemTypes != null && itemTypes.isNotEmpty);

  Future<void> handleProviderUpdates({
    @required UserModel user,
    @required List<LocalReactionModel> newLocalReactions,
    @required BuildContext context,
  }) async {
    _buildContext = context;

    if (newLocalReactions != null && newLocalReactions.isNotEmpty) {
      _handleNewReactions(newLocalReactions);
    }

    if (user == _user) {
      return;
    }

    final oldUser = _user;
    _user = user;

    // On user model changes, check to see if we should hide newly hidden content
    if (_items.isNotEmpty &&
        _user != null &&
        oldUser != null &&
        (_user.hiddenLetters != oldUser.hiddenLetters ||
            _user.hiddenRequests != oldUser.hiddenRequests ||
            _user.blockedUsers != oldUser.blockedUsers)) {
      _handleHideHiddenItems();
    }

    if (_status == ActivityLogStatus.uninitialized && _user != null) {
      await _fetchInitialData();
    }
  }

  Future<void> _fetchInitialData() async {
    try {
      await dangerousPaginateData();

      // Start listening to the first item of the list
      _firstItemStream ??= _db
          .collection('users')
          .document(_user.id)
          .collection('activityLog')
          .where('type',
              whereIn:
                  itemTypes.map((type) => EnumToString.parse(type)).toList())
          .orderBy('creationDate', descending: true)
          .limit(1)
          .snapshots()
          .listen(_handleFirstItem);
    } on Exception catch (exception, stackTrace) {
      await ErrorBottomSheet.reportAndShow(
        _buildContext,
        ActivityLogInitException(capturedException: exception),
        stackTrace,
      );
    }
  }

  @override
  void dispose() {
    if (_firstItemStream != null) {
      _firstItemStream.cancel();
      _firstItemStream = null;
    }

    super.dispose();
  }

  Future<void> dangerousPaginateData() async {
    if (_status != ActivityLogStatus.uninitialized &&
        _status != ActivityLogStatus.ready) {
      return;
    }

    if (_user == null) {
      return;
    }

    _status = ActivityLogStatus.paginating;
    notifyListeners();

    final docsWithoutLastItem = _items.sublist(0);
    if (_items.isNotEmpty) {
      docsWithoutLastItem.removeLast();
    }

    final paginationQuery = _db
        .collection('users')
        .document(_user.id)
        .collection('activityLog')
        .where('type',
            whereIn: itemTypes.map((type) => EnumToString.parse(type)).toList())
        .orderBy('creationDate', descending: true)
        .limit(Constants.activityLogRequestSize);

    QuerySnapshot newDocs;
    if (docsWithoutLastItem.isEmpty) {
      newDocs = await paginationQuery.getDocuments();
    } else {
      newDocs =
          await paginationQuery.startAfterDocument(_lastDoc).getDocuments();
    }

    if (newDocs.documents.isEmpty) {
      _status = ActivityLogStatus.endOfList;
      notifyListeners();
      return;
    }

    _lastDoc = newDocs.documents.last;

    final newItems = newDocs.documents
        .map((doc) => ActivityLogItemModel.fromFirestore(doc))
        // Filter out hidden content
        .where((item) => !_user.hiddenLetters.contains(item.linkedContentID))
        .where((item) => !_user.hiddenRequests.contains(item.linkedContentID))
        .where(
            (item) => !_user.blockedUsers.contains(item.linkedContentCreatorID))
        .toList();

    for (final item in newItems) {
      final newIndex = newItems.indexOf(item) + docsWithoutLastItem.length;
      listKey.currentState.insertItem(newIndex);
    }

    newItems.add(null);
    _items.replaceRange(_items.length - 1, _items.length, newItems);

    _status = ActivityLogStatus.ready;
    notifyListeners();
    return;
  }

  Future<void> _handleFirstItem(QuerySnapshot event) async {
    final changes = event.documentChanges;

    if (changes.isEmpty || _status == ActivityLogStatus.uninitialized) {
      return;
    }

    // NOTE: There should only be a single change max due to the query being limited to 1 item
    final firstChange = changes.first;

    final docsWithoutLastItem = _items.sublist(0);
    if (_items.isNotEmpty) {
      docsWithoutLastItem.removeLast();
    }

    if (docsWithoutLastItem.isNotEmpty &&
        docsWithoutLastItem.first.id == firstChange.document.documentID) {
      return;
    }

    try {
      final newItem = ActivityLogItemModel.fromFirestore(firstChange.document);

      // Ignore hidden content
      if (_user.hiddenLetters.contains(newItem.linkedContentID) ||
          _user.hiddenRequests.contains(newItem.linkedContentID) ||
          _user.blockedUsers.contains(newItem.linkedContentCreatorID)) {
        return;
      }

      listKey.currentState.insertItem(0);
      _items.insert(0, newItem);
    } on Exception catch (exception, stackTrace) {
      await ErrorBottomSheet.reportAndShow(
        _buildContext,
        ActivityLogFirstItemListenerException(capturedException: exception),
        stackTrace,
      );
    }
  }

  /// Handles removing any newly hidden content (via reporting or blocking)
  /// from the activity log list.
  void _handleHideHiddenItems() {
    if (_user == null) {
      return;
    }

    final hiddenContentIDs = [
      ..._user.hiddenLetters,
      ..._user.hiddenRequests,
    ];

    final itemsToRemove = <ActivityLogItemModel>[];

    for (final contentID in hiddenContentIDs) {
      itemsToRemove.addAll(
        _items
            .where((item) => item != null && item.linkedContentID == contentID),
      );
    }

    final blockedUsers = _user.blockedUsers;
    for (final blockedUserID in blockedUsers) {
      itemsToRemove.addAll(
        _items.where((item) =>
            item != null && item.linkedContentCreatorID == blockedUserID),
      );
    }

    for (final item in itemsToRemove) {
      final index = _items.indexOf(item);

      if (index >= 0) {
        listKey.currentState.removeItem(
          index,
          (context, animation) => ActivityLogListItem(
            item: _items[index],
          ),
        );
        _items.removeAt(index);
      }
    }
  }

  void _handleNewReactions(List<LocalReactionModel> newReactions) {
    bool didModifyItems = false;
    for (final item in _items) {
      if (item == null) {
        continue;
      }

      for (final reaction in newReactions) {
        if (reaction.linkedLetterID == item.linkedContentID) {
          final index = _items.indexOf(item);
          if (index < 0) {
            continue;
          }
          _items[index] = item.copyWith(
            reactionType: reaction.reactionType,
          );
          didModifyItems = true;
        }
      }
    }

    if (didModifyItems) {
      notifyListeners();
    }
  }
}
