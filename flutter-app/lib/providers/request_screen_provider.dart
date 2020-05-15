import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gentle/components/BottomSheet/error_bottomsheet.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/request_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum RequestScreenErrorStatus {
  none,
  deleted,
  offline,
}

class RequestScreenProvider extends ChangeNotifier {
  final Firestore _db = Firestore.instance;

  RequestItemModel _request;
  RequestItemModel get request => _request;

  bool _shouldShowLoadingIndicator = false;
  bool get shouldShowLoadingIndicator => _shouldShowLoadingIndicator;

  Timer _loadingTimer;

  RequestScreenErrorStatus _errorStatus = RequestScreenErrorStatus.none;
  RequestScreenErrorStatus get errorStatus => _errorStatus;

  RequestScreenProvider(String requestID, BuildContext context) {
    _startFetch(context: context, requestID: requestID);
  }

  @override
  void dispose() {
    _clearLoadingTimer();
    super.dispose();
  }

  void _startFetch(
      {@required BuildContext context, @required String requestID}) {
    // Give a short timeout before showing the loading screen
    _loadingTimer = Timer(Constants.loadShimmerDelayDuration, () {
      _shouldShowLoadingIndicator = true;
      _loadingTimer.cancel();
      _loadingTimer = null;
      notifyListeners();
    });

    _fetchRequest(requestID, context);
  }

  Future<void> _fetchRequest(String requestID, BuildContext context) async {
    try {
      final doc = await _db.collection('requests').document(requestID).get();

      if (!doc.exists) {
        _errorStatus = RequestScreenErrorStatus.deleted;
        _clearLoadingTimer();
        notifyListeners();
        return;
      }

      _request = RequestItemModel.fromFirestore(doc);

      _clearLoadingTimer();
      notifyListeners();
    } on Exception catch (exception, stackTrace) {
      _clearLoadingTimer();

      // Handle known exceptions
      if (exception is PlatformException) {
        // Hacky check for offline status as proper codes aren't exposed
        if (exception.code == 'Error 14' ||
            exception.message.contains('offline')) {
          _errorStatus = RequestScreenErrorStatus.offline;
          notifyListeners();
          return;
        }
      }

      await ErrorBottomSheet.reportAndShow(context,
          RequestFetchException(capturedException: exception), stackTrace);
    }
  }

  Future<void> refetch({
    @required BuildContext context,
    @required String requestID,
  }) async {
    _errorStatus = RequestScreenErrorStatus.none;
    _shouldShowLoadingIndicator = false;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _startFetch(context: context, requestID: requestID);
  }

  void _clearLoadingTimer() {
    if (_loadingTimer != null) {
      _loadingTimer.cancel();
      _loadingTimer = null;
    }
  }
}
