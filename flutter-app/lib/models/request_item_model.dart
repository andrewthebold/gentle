import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gentle/components/avatar.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/activity_log_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:gentle/models/user_model.dart';
import 'package:gentle/sanitizer.dart';

part 'request_item_model.freezed.dart';
part 'request_item_model.g.dart';

@freezed
abstract class RequestItemModel implements _$RequestItemModel {
  factory RequestItemModel({
    @required String id,
    @required bool published,
    @required DateTime creationDate,
    @required int responseCount,
    @required String requesterID,
    @JsonKey(unknownEnumValue: AvatarName.unknown)
    @required
        AvatarName requesterAvatar,
    @required String requestMessage,
  }) = _RequestItemModel;

  const RequestItemModel._();

  factory RequestItemModel.fromJson(Map<String, dynamic> json) =>
      _$RequestItemModelFromJson(json);

  factory RequestItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data
      // https://stackoverflow.com/a/60818281
      ..['creationDate'] =
          (doc.data['creationDate'] as Timestamp).toDate().toString()
      ..['requestMessage'] = doc.data['requestMessage'] != null
          ? Sanitizer.sanitizeUserInput(doc.data['requestMessage'] as String)
          : null;
    return RequestItemModel.fromJson(data);
  }

  /// Creates a new request and an associated activity log item.
  static Future<void> dangerousCommitNewRequest({
    @required UserModel user,
    @required AvatarName requesterAvatar,
    @required String requestMessage,
  }) async {
    final db = Firestore.instance;
    final batch = db.batch();

    final sanitizedMessage = Sanitizer.sanitizeUserInput(requestMessage);

    final requestDoc = db.collection('requests').document();
    final requestData = <String, dynamic>{
      'id': requestDoc.documentID,
      'published': false,
      'creationDate': FieldValue.serverTimestamp(),
      'responseCount': 0,
      'requesterID': user.id,
      'requesterAvatar': EnumToString.parse(requesterAvatar),
      'requestMessage': sanitizedMessage,
    };
    batch.setData(requestDoc, requestData);

    final alData = ActivityLogItemModel.dangerousAddActivityLogItemWriteToBatch(
      batch: batch,
      user: user,
      type: ActivityLogItemType.sentRequest,
      linkedContentID: requestDoc.documentID,
      linkedContentCreatorID: user.id,
      linkedContentAvatar: requesterAvatar,
      linkedContentExcerpt:
          Sanitizer.sanitizeUserInputExcerpt(sanitizedMessage),
    );

    try {
      await batch.commit();
    } on Exception catch (exception) {
      throw RequestCommitException(
        capturedException: exception,
        message: '[REQUEST] $requestData [AL] $alData',
      );
    }
  }
}
