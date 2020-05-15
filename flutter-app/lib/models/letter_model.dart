import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gentle/components/avatar.dart';
import 'package:gentle/constants.dart';
import 'package:gentle/exceptions.dart';
import 'package:gentle/models/activity_log_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/models/user_model.dart';
import 'package:gentle/sanitizer.dart';
import 'package:characters/characters.dart';

part 'letter_model.freezed.dart';
part 'letter_model.g.dart';

@freezed
abstract class LetterModel implements _$LetterModel {
  factory LetterModel({
    @required String id,
    @required bool published,
    @required DateTime creationDate,
    @nullable String requestID,
    @nullable String requestMessage,
    @nullable String requestCreatorID,
    @JsonKey(unknownEnumValue: AvatarName.unknown)
    @nullable
        AvatarName requestCreatorAvatar,
    @required String letterSenderID,
    @JsonKey(unknownEnumValue: AvatarName.unknown)
    @required
        AvatarName letterSenderAvatar,
    @required String letterMessage,
    @required String recipientID,
    @nullable DateTime reactionTime,
    @JsonKey(unknownEnumValue: ReactionType.unknown)
    @nullable
        ReactionType reactionType,
  }) = _LetterModel;

  const LetterModel._();

  factory LetterModel.fromJson(Map<String, dynamic> json) =>
      _$LetterModelFromJson(json);

  factory LetterModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data
      // https://stackoverflow.com/a/60818281
      ..['creationDate'] =
          (doc.data['creationDate'] as Timestamp).toDate().toString()
      ..['requestMessage'] = doc.data['requestMessage'] != null
          ? Sanitizer.sanitizeUserInput(doc.data['requestMessage'] as String)
          : null
      ..['letterMessage'] = doc.data['letterMessage'] != null
          ? Sanitizer.sanitizeUserInput(doc.data['letterMessage'] as String)
          : null
      ..['reactionTime'] = doc.data['reactionTime'] != null
          ? (doc.data['reactionTime'] as Timestamp).toDate().toString()
          : null;
    return LetterModel.fromJson(data);
  }

  static Future<void> dangerousCommitNewLetter({
    @required String requestID,
    @required String requestMessage,
    @required UserModel user,
    @required AvatarName senderAvatarName,
    @required String letterMessage,
    @required String recipientID,
    @required AvatarName recipientAvatar,
  }) async {
    if (requestID == null) {
      throw const LetterCreateInvalidDataException(
          message: 'Null requestID provided when sending letter');
    }
    if (requestMessage == null) {
      throw const LetterCreateInvalidDataException(
          message: 'Null requestMessage provided when sending letter');
    }
    if (requestMessage.characters.length > Constants.maxRequestLength) {
      throw LetterCreateInvalidDataException(
          message:
              'requestMessage provided when sending letter is too long: ${requestMessage.characters.length}');
    }
    if (user == null) {
      throw const LetterCreateInvalidDataException(
          message: 'Null user provided when sending letter');
    }
    if (senderAvatarName == null) {
      throw const LetterCreateInvalidDataException(
          message: 'Null senderAvatarName provided when sending letter');
    }
    if (letterMessage == null) {
      throw const LetterCreateInvalidDataException(
          message: 'Null letterMessage provided when sending letter');
    }
    if (letterMessage.characters.length > Constants.maxLetterLength) {
      throw LetterCreateInvalidDataException(
          message:
              'letterMessage provided when sending letter is too long: ${letterMessage.characters.length}');
    }
    if (recipientID == null) {
      throw const LetterCreateInvalidDataException(
          message: 'Null recipientID provided when sending letter');
    }
    if (user.id == recipientID) {
      throw LetterCreateInvalidDataException(
          message: 'Attempted to send letter to self: ${user.id}');
    }
    if (recipientAvatar == null) {
      throw const LetterCreateInvalidDataException(
          message: 'Null recipientAvatar provided when sending letter');
    }

    final db = Firestore.instance;
    final batch = db.batch();

    // Create letter
    final letterDoc = db.collection('letters').document();
    final letterData = <String, dynamic>{
      'id': letterDoc.documentID,
      'published': false,
      'creationDate': FieldValue.serverTimestamp(),
      'requestID': requestID,
      'requestMessage': requestMessage,
      'requestCreatorID': recipientID,
      'requestCreatorAvatar': EnumToString.parse(recipientAvatar),
      'letterSenderID': user.id,
      'letterSenderAvatar': EnumToString.parse(senderAvatarName),
      'letterMessage': letterMessage,
      'recipientID': recipientID,
    };

    batch.setData(
      letterDoc,
      letterData,
    );

    final letterMessageExcerpt =
        Sanitizer.sanitizeUserInputExcerpt(letterMessage);

    ActivityLogItemModel.dangerousAddActivityLogItemWriteToBatch(
      batch: batch,
      user: user,
      type: ActivityLogItemType.sentReply,
      linkedContentID: letterDoc.documentID,
      linkedContentCreatorID: user.id,
      linkedContentAvatar: recipientAvatar,
      linkedContentExcerpt: letterMessageExcerpt,
    );

    final userUpdateData = UserModel.dangerousCompleteRequestWriteToBatch(
      batch: batch,
      user: user,
      requestID: requestID,
    );

    try {
      await batch.commit();
    } on Exception catch (exception) {
      throw LetterCommitException(
        capturedException: exception,
        message: '[LETTER] $letterData [USER] $userUpdateData',
      );
    }
  }

  static Future<void> dangerousUpdateLetterReaction({
    @required LetterModel letter,
    @required UserModel user,
    @required ReactionType reactionType,
  }) async {
    if (letter == null) {
      throw const LetterReactInvalidDataException(
        message: 'Attempted to react to null letter',
      );
    }
    if (letter.letterSenderAvatar == AvatarName.gentle) {
      throw const LetterReactInvalidDataException(
        message: 'Attempted to react to official letter',
      );
    }
    if (user == null) {
      throw const LetterReactInvalidDataException(
        message: 'Attempted to react to letter as null user',
      );
    }
    if (letter.letterSenderID == user.id) {
      throw const LetterReactInvalidDataException(
        message: 'Attempted to react to letter created by self',
      );
    }
    if (reactionType == null) {
      throw const LetterReactInvalidDataException(
        message: 'Attempted to react to letter with reactionType',
      );
    }
    if (reactionType == ReactionType.unknown) {
      throw const LetterReactInvalidDataException(
        message: 'Attempted to react to letter with unknown reaction',
      );
    }

    final db = Firestore.instance;
    final letterDoc = db.collection('letters').document(letter.id);
    final letterUpdateData = <String, dynamic>{
      'reactionType': EnumToString.parse(reactionType),
      'reactionTime': FieldValue.serverTimestamp(),
    };
    await letterDoc.updateData(letterUpdateData);
  }
}
