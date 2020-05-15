import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/request_item_model.dart';
import 'package:gentle/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RequestStackStatus {
  uninitialized,

  /// We are loading new requests.
  loading,

  /// User is actively going through requests.
  active,

  /// User finished the currently active stack of requests.
  finished,

  /// There are no more requests on the server to fetch.
  empty
}

class RequestStackProvider extends ChangeNotifier {
  final ScrollController _scrollController;
  RequestStackStatus _status = RequestStackStatus.uninitialized;
  RequestStackStatus get status => _status;
  UserModel _user;
  DocumentSnapshot _lastDoc;
  List<RequestItemModel> _requests = [];
  List<RequestItemModel> get requests => _requests;
  List<RequestItemModel> _queuedRequests = [];
  final List<RequestItemModel> _requestsToRemoveOnFinish = [];
  int get queuedRequestCount => _queuedRequests.length;
  RequestItemModel get currentRequest =>
      _requests.length > _cursor ? _requests.elementAt(_cursor) : null;
  int _cursor = 0;
  int get cursor => _cursor;
  int get remainingCardsInStack => _requests.length - _cursor;

  bool _attemptingSecondPaginationTry = false;

  RequestStackProvider({
    @required ScrollController scrollController,
  }) : _scrollController = scrollController;

  Future<void> handleUserProviderUpdate(
      {@required UserModel user, @required BuildContext context}) async {
    if (user == null) {
      return;
    }

    if (user == _user) {
      return;
    }

    _user = user;

    // If we haven't yet, fetch the first set of requests
    if (_status == RequestStackStatus.uninitialized) {
      _status = RequestStackStatus.loading;
      try {
        await _dangerousFetchRequests();
      } on Exception catch (exception, stackTrace) {
        await ErrorBottomSheet.reportAndShow(context,
            RequestFetchException(capturedException: exception), stackTrace);
      }
      return;
    }

    // Check if we should pop any newly blocked/hidden requests
    _handleNewlyHiddenRequests();
  }

  Future<void> _dangerousFetchRequests() async {
    if (_requests.isNotEmpty) {
      throw RequestDuplicateFetchException(
          message:
              'Attempted to fetch new requests while ${_requests.length} requests still exist.');
    }

    _status = RequestStackStatus.loading;

    notifyListeners();

    final db = Firestore.instance;
    var query = db
        .collection('requests')
        .where('published', isEqualTo: true)
        .orderBy('responseCount')
        .orderBy('creationDate')
        .limit(Constants.requestStackSize);

    // Paginate from the last request if it's not the first fetch
    if (_lastDoc != null && _status != RequestStackStatus.empty) {
      query = query.startAfterDocument(_lastDoc);
    }

    final snapshot = await query.getDocuments();

    if (snapshot.documents.isEmpty) {
      _status = RequestStackStatus.empty;
      _lastDoc = null;
      notifyListeners();
      return;
    }

    final filteredRequests = <RequestItemModel>[];
    DocumentSnapshot lastDoc;

    for (final doc in snapshot.documents) {
      final request = RequestItemModel.fromFirestore(doc);

      // Skip requests that were created by the user
      if (request.requesterID == _user.id) {
        continue;
      }

      // Skip requests you've already replied to
      if (_user.completedRequests.contains(request.id)) {
        continue;
      }

      // Skip requests that were hidden by the user
      if (_user.hiddenRequests.contains(request.id)) {
        continue;
      }

      // Skip requests created by somebody this user has blocked
      if (_user.blockedUsers.contains(request.requesterID)) {
        continue;
      }

      filteredRequests.add(request);
      lastDoc = doc;
    }

    // We make two attempts to look for requests (in the case all the requests
    // in a given stack are filtered out).
    if (filteredRequests.isEmpty) {
      if (_attemptingSecondPaginationTry) {
        _status = RequestStackStatus.empty;
        _lastDoc = null;
        notifyListeners();
        return;
      }

      _attemptingSecondPaginationTry = true;
      await _dangerousFetchRequests();
      return;
    }

    _attemptingSecondPaginationTry = false;
    _requests = filteredRequests;
    _lastDoc = lastDoc;

    await Future<void>.delayed(const Duration(seconds: 1));

    _status = RequestStackStatus.active;
    notifyListeners();
  }

  void popRequest({int times = 1}) {
    if (_status != RequestStackStatus.active) {
      return;
    }

    _cursor += times;
    _cursor = min(_cursor, _requests.length);

    if (_cursor >= _requests.length) {
      _status = RequestStackStatus.finished;

      _queuedRequests = _requests
          .where((request) => !_requestsToRemoveOnFinish.contains(request))
          .toList();
    }

    notifyListeners();
  }

  void loadQueuedRequests() {
    if (_queuedRequests.isEmpty) {
      return;
    }

    _requests = [..._queuedRequests];
    _queuedRequests = [];
    _cursor = 0;

    _status = RequestStackStatus.active;
    notifyListeners();
  }

  Future<void> loadNewRequests({@required BuildContext context}) async {
    if (_status != RequestStackStatus.finished &&
        _status != RequestStackStatus.empty) {
      return;
    }

    _requests = [];
    _queuedRequests = [];
    _cursor = 0;

    try {
      await _dangerousFetchRequests();
    } on Exception catch (exception, stackTrace) {
      // TODO (Med): Handle offline-exceptions
      await ErrorBottomSheet.reportAndShow(context,
          RequestFetchException(capturedException: exception), stackTrace);
    }
  }

  /// Marks requests to be removed from the request list once you finish going
  /// through a request stack.
  void _handleNewlyHiddenRequests() {
    if (_requests.isEmpty) {
      return;
    }

    final allHiddenRequestIDs = <String>[];

    for (final request in _user.completedRequests) {
      if (!allHiddenRequestIDs.contains(request)) {
        allHiddenRequestIDs.add(request);
      }
    }

    for (final request in _user.hiddenRequests) {
      if (!allHiddenRequestIDs.contains(request)) {
        allHiddenRequestIDs.add(request);
      }
    }

    final newRequestsToRemoveOnFinish = <RequestItemModel>[];

    for (final request in _requests) {
      if (allHiddenRequestIDs.contains(request.id) ||
          _user.blockedUsers.contains(request.requesterID)) {
        newRequestsToRemoveOnFinish.add(request);
      }
    }

    _requestsToRemoveOnFinish.addAll(newRequestsToRemoveOnFinish);
    popRequest(times: newRequestsToRemoveOnFinish.length);

    _revealReplyHistory();
  }

  Future<void> _revealReplyHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenReplyHistory =
        prefs.getBool(SharedPreferenceKeys.hasSeenReplyHistory) ?? false;

    if (hasSeenReplyHistory) {
      return;
    }

    // Animate to reveal the history section if this is the first time you've
    // opened mail — teaching moment. May be too "clever" so it'll need testing.
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    await _scrollController.animateTo(
      200, // Magic number — feels good enough
      duration: Constants.heaviestAnimDuration,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    await _scrollController.animateTo(
      0,
      duration: Constants.heaviestAnimDuration,
      curve: Curves.fastLinearToSlowEaseIn,
    );

    prefs.setBool(SharedPreferenceKeys.hasSeenReplyHistory, true);
  }
}
