import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/user_model.dart';

part 'reaction_inbox_item_model.freezed.dart';
part 'reaction_inbox_item_model.g.dart';

enum ReactionType {
  love,
  inspire,
  thanks,
  unknown,
}

@freezed
abstract class ReactionInboxItemModel implements _$ReactionInboxItemModel {
  factory ReactionInboxItemModel({
    @required String id,
    @required DateTime creationDate,
    @JsonKey(unknownEnumValue: ReactionType.unknown)
    @required
        ReactionType type,
    @required String linkedContentID,
  }) = _ReactionInboxItemModel;

  const ReactionInboxItemModel._();

  factory ReactionInboxItemModel.fromJson(Map<String, dynamic> json) =>
      _$ReactionInboxItemModelFromJson(json);

  factory ReactionInboxItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data
      // https://stackoverflow.com/a/60818281
      ..['creationDate'] =
          (doc.data['creationDate'] as Timestamp).toDate().toString();
    return ReactionInboxItemModel.fromJson(data);
  }

  static Future<void> dangerousDeleteReactions({
    @required UserModel user,
    @required List<ReactionInboxItemModel> reactions,
  }) async {
    if (user == null) {
      throw const ReactionInboxDeleteInvalidDataException(
        message: 'Null user provided when deleting reaction inbox items',
      );
    }
    if (reactions == null) {
      throw const ReactionInboxDeleteInvalidDataException(
        message: 'Null reactions provided when deleting reaction inbox items',
      );
    }
    if (reactions.isEmpty) {
      throw const ReactionInboxDeleteInvalidDataException(
        message:
            'Empty reactions list provided when deleting reaction inbox items',
      );
    }

    final db = Firestore.instance;
    final batch = db.batch();

    for (final reaction in reactions) {
      final reactionDoc = db
          .collection('users')
          .document(user.id)
          .collection('reactionInbox')
          .document(reaction.id);

      batch.delete(reactionDoc);
    }

    await batch.commit();
  }
}
