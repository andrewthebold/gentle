import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/report_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel implements _$UserModel {
  factory UserModel({
    @required String id,
    @required DateTime joinDate,

    /// Requests the user has replied to. Should be hidden in the UI.
    @Default(<String>[]) List<String> completedRequests,

    /// Users blocked by this user. Any content created by this user should
    /// be hidden in the UI.
    @Default(<String>[]) List<String> blockedUsers,

    /// Requests this user hid (for example, in conjunction with a report).
    @Default(<String>[]) List<String> hiddenRequests,

    /// Letters this user hid (for example, in conjunction with a report).
    @Default(<String>[]) List<String> hiddenLetters,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data
      // https://stackoverflow.com/a/60818281
      ..['joinDate'] = (doc.data['joinDate'] as Timestamp).toDate().toString();
    return UserModel.fromJson(data);
  }

  /// Blocks a given uid (making their content filtered out).
  static Future<void> dangerousBlockUser({
    @required UserModel user,
    @required String userIDToBlock,
  }) async {
    if (user == null) {
      throw const UserBlockInvalidDataException(
          message: 'Null user provided when blocking');
    }
    if (userIDToBlock == null) {
      throw const UserBlockInvalidDataException(
          message: 'Null userIDToBlock provided when blocking');
    }
    if (user.blockedUsers.contains(userIDToBlock)) {
      throw UserBlockInvalidDataException(
          message:
              '${user.id} attempted to block already blocked user $userIDToBlock');
    }
    if (user.id == userIDToBlock) {
      throw UserBlockInvalidDataException(
          message: '${user.id} attempted to block themselves');
    }

    final newBlockedUsers = [...user.blockedUsers, userIDToBlock];

    final db = Firestore.instance;
    await db.collection('users').document(user.id).updateData(<String, dynamic>{
      'blockedUsers': newBlockedUsers,
    });
  }

  static Map<String, dynamic> dangerousCompleteRequestWriteToBatch({
    @required WriteBatch batch,
    @required UserModel user,
    @required String requestID,
  }) {
    if (batch == null) {
      throw const UserCompleteRequestInvalidDataException(
          message: 'Null batch provided when completing request');
    }
    if (user == null) {
      throw const UserCompleteRequestInvalidDataException(
          message: 'Null user provided when completing request');
    }
    if (requestID == null) {
      throw const UserCompleteRequestInvalidDataException(
          message: 'Null requestID provided when completing request');
    }
    if (user.completedRequests.contains(requestID)) {
      throw UserCompleteRequestInvalidDataException(
          message:
              'Attempted to complete already completed request $requestID when completing request');
    }

    final db = Firestore.instance;
    final userDoc = db.collection('users').document(user.id);
    final updateData = <String, dynamic>{
      'completedRequests': FieldValue.arrayUnion(<String>[requestID]),
    };
    batch.updateData(userDoc, updateData);
    return updateData;
  }

  /// Hides a piece of content so it is filtered from the UI. Only adds the write
  /// operation to an existing Firestore [WriteBatch].
  static void dangerousAddHideContentWriteToBatch({
    @required WriteBatch batch,
    @required UserModel user,
    @required String contentToHideCreatorID,
    @required String contentIDToHide,
    @required ContentType contentType,
  }) {
    if (batch == null) {
      throw const UserHideContentInvalidDataException(
          message: 'Null batch provided when hiding content');
    }
    if (user == null) {
      throw const UserHideContentInvalidDataException(
          message: 'Null user provided when hiding content');
    }
    if (contentToHideCreatorID == null) {
      throw const UserHideContentInvalidDataException(
          message: 'Null contentToHideCreatorID provided when hiding content');
    }
    if (contentIDToHide == null) {
      throw const UserHideContentInvalidDataException(
          message: 'Null contentIDToHide provided when hiding content');
    }
    if (contentType == null) {
      throw const UserHideContentInvalidDataException(
          message: 'Null contentType provided when hiding content');
    }
    if (contentType == ContentType.request &&
        user.hiddenRequests.contains(contentIDToHide)) {
      throw UserHideContentInvalidDataException(
          message:
              'Attempted to hide request which is already hidden: $contentIDToHide');
    }
    if (contentType == ContentType.letter &&
        user.hiddenLetters.contains(contentIDToHide)) {
      throw UserHideContentInvalidDataException(
          message:
              'Attempted to hide letter which is already hidden: $contentIDToHide');
    }
    if (user.blockedUsers.contains(contentIDToHide)) {
      throw UserHideContentInvalidDataException(
          message:
              'Attempted to hide content ($contentIDToHide) created by a user that was already blocked ($contentToHideCreatorID)');
    }

    final db = Firestore.instance;
    final userDoc = db.collection('users').document(user.id);
    if (contentType == ContentType.request) {
      batch.updateData(userDoc, <String, dynamic>{
        'hiddenRequests': FieldValue.arrayUnion(<String>[contentIDToHide]),
      });
      return;
    }

    if (contentType == ContentType.letter) {
      batch.updateData(userDoc, <String, dynamic>{
        'hiddenLetters': FieldValue.arrayUnion(<String>[contentIDToHide]),
      });
      return;
    }

    throw UserHideContentInvalidDataException(
        message:
            'Unclear what to do when trying to hide content ($contentIDToHide) of contentType $contentType');
  }
}
