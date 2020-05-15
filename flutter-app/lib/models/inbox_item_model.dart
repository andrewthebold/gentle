import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gentle/components/avatar.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/activity_log_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/models/user_model.dart';
import 'package:gentle/sanitizer.dart';

part 'inbox_item_model.freezed.dart';
part 'inbox_item_model.g.dart';

@freezed
abstract class InboxItemModel implements _$InboxItemModel {
  factory InboxItemModel({
    @required String id,
    @required DateTime creationDate,
    @required String linkedContentID,
    @required String linkedContentCreatorID,
    @JsonKey(unknownEnumValue: AvatarName.unknown)
    @required
        AvatarName linkedContentAvatar,
    @required String linkedContentExcerpt,
  }) = _InboxItemModel;

  const InboxItemModel._();

  factory InboxItemModel.fromJson(Map<String, dynamic> json) =>
      _$InboxItemModelFromJson(json);

  factory InboxItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data
      // https://stackoverflow.com/a/60818281
      ..['creationDate'] =
          (doc.data['creationDate'] as Timestamp).toDate().toString()
      ..['linkedContentExcerpt'] = Sanitizer.sanitizeUserInputExcerpt(
          doc.data['linkedContentExcerpt'] as String);
    return InboxItemModel.fromJson(data);
  }

  static Future<void> dangerousCommitRead({
    @required UserModel user,
    @required InboxItemModel item,
    ReactionType reactionType,
  }) async {
    if (user == null) {
      throw const InboxReadInvalidDataException(
          message: 'Null user provided when marking inbox item read');
    }
    if (item == null) {
      throw const InboxReadInvalidDataException(
          message: 'Null item provided when marking inbox item read');
    }

    final db = Firestore.instance;
    final batch = db.batch();
    final inboxItemToDeleteDoc = db
        .collection('users')
        .document(user.id)
        .collection('inbox')
        .document(item.id);
    batch.delete(inboxItemToDeleteDoc);

    ActivityLogItemModel.dangerousAddActivityLogItemWriteToBatch(
      batch: batch,
      user: user,
      type: ActivityLogItemType.openedMail,
      linkedContentID: item.linkedContentID,
      linkedContentCreatorID: item.linkedContentCreatorID,
      linkedContentAvatar: item.linkedContentAvatar,
      linkedContentExcerpt: item.linkedContentExcerpt,
      reactionType: reactionType,
    );

    await batch.commit();
  }
}
