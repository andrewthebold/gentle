import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';

part 'local_reaction_model.freezed.dart';

/// A reaction that's stored for a given session in order to update various
/// parts of the UI when a reaction happens.
@freezed
abstract class LocalReactionModel implements _$LocalReactionModel {
  factory LocalReactionModel({
    @required String linkedLetterID,
    @required ReactionType reactionType,
    @required DateTime reactionTime,
  }) = _LocalReactionModel;
}
