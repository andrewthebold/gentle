import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gentle/components/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/models/user_model.dart';
import 'package:gentle/sanitizer.dart';

part 'activity_log_item_model.freezed.dart';
part 'activity_log_item_model.g.dart';

enum ActivityLogItemType {
  sentRequest,
  openedMail,
  sentReply,
  unknown,
}

@freezed
abstract class ActivityLogItemModel implements _$ActivityLogItemModel {
  factory ActivityLogItemModel({
    @required String id,
    @required DateTime creationDate,
    @JsonKey(unknownEnumValue: ActivityLogItemType.unknown)
    @required
        ActivityLogItemType type,
    @required String linkedContentID,
    @required String linkedContentCreatorID,
    @JsonKey(unknownEnumValue: AvatarName.unknown)
    @required
        AvatarName linkedContentAvatar,
    @required String linkedContentExcerpt,
    @JsonKey(unknownEnumValue: ReactionType.unknown)
    @nullable
        ReactionType reactionType,
  }) = _ActivityLogItemModel;

  const ActivityLogItemModel._();

  factory ActivityLogItemModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogItemModelFromJson(json);

  factory ActivityLogItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data
      // https://stackoverflow.com/a/60818281
      ..['creationDate'] = doc.data['creationDate'] != null
          ? (doc.data['creationDate'] as Timestamp).toDate().toString()
          : DateTime.now().toString()
      ..['excerpt'] =
          Sanitizer.sanitizeUserInputExcerpt(doc.data['excerpt'] as String);
    return ActivityLogItemModel.fromJson(data);
  }

  static Map<String, dynamic> dangerousAddActivityLogItemWriteToBatch({
    @required WriteBatch batch,
    @required UserModel user,
    @required ActivityLogItemType type,
    @required String linkedContentID,
    @required String linkedContentCreatorID,
    @required AvatarName linkedContentAvatar,
    @required String linkedContentExcerpt,
    ReactionType reactionType,
  }) {
    if (batch == null) {
      throw const ActivityLogCreateInvalidDataException(
          message: 'Null batch provided when creating activity log item');
    }
    if (user == null) {
      throw const ActivityLogCreateInvalidDataException(
          message: 'Null user provided when creating activity log item');
    }
    if (type == null) {
      throw const ActivityLogCreateInvalidDataException(
          message:
              'Null activity type provided when creating activity log item');
    }
    if (linkedContentID == null) {
      throw const ActivityLogCreateInvalidDataException(
          message:
              'Null linkedContentID provided when creating activity log item');
    }
    if (linkedContentCreatorID == null) {
      throw const ActivityLogCreateInvalidDataException(
          message:
              'Null linkedContentCreatorID provided when creating activity log item');
    }
    if (linkedContentAvatar == null) {
      throw const ActivityLogCreateInvalidDataException(
          message:
              'Null linkedContentAvatar provided when creating activity log item');
    }
    if (linkedContentExcerpt == null) {
      throw const ActivityLogCreateInvalidDataException(
          message:
              'Null linkedContentExcerpt provided when creating activity log item');
    }
    if (linkedContentExcerpt.isEmpty) {
      throw const ActivityLogCreateInvalidDataException(
          message:
              'Empty linkedContentExcerpt provided when creating activity log item');
    }
    if (reactionType != null && reactionType == ReactionType.unknown) {
      throw const ActivityLogCreateInvalidDataException(
          message: 'Attempted to use unknown reaction type');
    }

    final db = Firestore.instance;
    final activityLogItemDoc = db
        .collection('users')
        .document(user.id)
        .collection('activityLog')
        .document();
    final activityLogItemData = <String, dynamic>{
      'id': activityLogItemDoc.documentID,
      'creationDate': FieldValue.serverTimestamp(),
      'type': EnumToString.parse(type),
      'linkedContentID': linkedContentID,
      'linkedContentCreatorID': linkedContentCreatorID,
      'linkedContentAvatar': EnumToString.parse(linkedContentAvatar),
      'linkedContentExcerpt':
          Sanitizer.sanitizeUserInputExcerpt(linkedContentExcerpt),
    };
    if (reactionType != null) {
      activityLogItemData['reactionType'] = EnumToString.parse(reactionType);
      assert(activityLogItemData['reactionType'] is String);
    }
    batch.setData(activityLogItemDoc, activityLogItemData);
    return activityLogItemData;
  }
}
