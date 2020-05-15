// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'local_reaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$LocalReactionModelTearOff {
  const _$LocalReactionModelTearOff();

  _LocalReactionModel call(
      {@required String linkedLetterID,
      @required ReactionType reactionType,
      @required DateTime reactionTime}) {
    return _LocalReactionModel(
      linkedLetterID: linkedLetterID,
      reactionType: reactionType,
      reactionTime: reactionTime,
    );
  }
}

// ignore: unused_element
const $LocalReactionModel = _$LocalReactionModelTearOff();

mixin _$LocalReactionModel {
  String get linkedLetterID;
  ReactionType get reactionType;
  DateTime get reactionTime;

  $LocalReactionModelCopyWith<LocalReactionModel> get copyWith;
}

abstract class $LocalReactionModelCopyWith<$Res> {
  factory $LocalReactionModelCopyWith(
          LocalReactionModel value, $Res Function(LocalReactionModel) then) =
      _$LocalReactionModelCopyWithImpl<$Res>;
  $Res call(
      {String linkedLetterID,
      ReactionType reactionType,
      DateTime reactionTime});
}

class _$LocalReactionModelCopyWithImpl<$Res>
    implements $LocalReactionModelCopyWith<$Res> {
  _$LocalReactionModelCopyWithImpl(this._value, this._then);

  final LocalReactionModel _value;
  // ignore: unused_field
  final $Res Function(LocalReactionModel) _then;

  @override
  $Res call({
    Object linkedLetterID = freezed,
    Object reactionType = freezed,
    Object reactionTime = freezed,
  }) {
    return _then(_value.copyWith(
      linkedLetterID: linkedLetterID == freezed
          ? _value.linkedLetterID
          : linkedLetterID as String,
      reactionType: reactionType == freezed
          ? _value.reactionType
          : reactionType as ReactionType,
      reactionTime: reactionTime == freezed
          ? _value.reactionTime
          : reactionTime as DateTime,
    ));
  }
}

abstract class _$LocalReactionModelCopyWith<$Res>
    implements $LocalReactionModelCopyWith<$Res> {
  factory _$LocalReactionModelCopyWith(
          _LocalReactionModel value, $Res Function(_LocalReactionModel) then) =
      __$LocalReactionModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String linkedLetterID,
      ReactionType reactionType,
      DateTime reactionTime});
}

class __$LocalReactionModelCopyWithImpl<$Res>
    extends _$LocalReactionModelCopyWithImpl<$Res>
    implements _$LocalReactionModelCopyWith<$Res> {
  __$LocalReactionModelCopyWithImpl(
      _LocalReactionModel _value, $Res Function(_LocalReactionModel) _then)
      : super(_value, (v) => _then(v as _LocalReactionModel));

  @override
  _LocalReactionModel get _value => super._value as _LocalReactionModel;

  @override
  $Res call({
    Object linkedLetterID = freezed,
    Object reactionType = freezed,
    Object reactionTime = freezed,
  }) {
    return _then(_LocalReactionModel(
      linkedLetterID: linkedLetterID == freezed
          ? _value.linkedLetterID
          : linkedLetterID as String,
      reactionType: reactionType == freezed
          ? _value.reactionType
          : reactionType as ReactionType,
      reactionTime: reactionTime == freezed
          ? _value.reactionTime
          : reactionTime as DateTime,
    ));
  }
}

class _$_LocalReactionModel implements _LocalReactionModel {
  _$_LocalReactionModel(
      {@required this.linkedLetterID,
      @required this.reactionType,
      @required this.reactionTime})
      : assert(linkedLetterID != null),
        assert(reactionType != null),
        assert(reactionTime != null);

  @override
  final String linkedLetterID;
  @override
  final ReactionType reactionType;
  @override
  final DateTime reactionTime;

  @override
  String toString() {
    return 'LocalReactionModel(linkedLetterID: $linkedLetterID, reactionType: $reactionType, reactionTime: $reactionTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LocalReactionModel &&
            (identical(other.linkedLetterID, linkedLetterID) ||
                const DeepCollectionEquality()
                    .equals(other.linkedLetterID, linkedLetterID)) &&
            (identical(other.reactionType, reactionType) ||
                const DeepCollectionEquality()
                    .equals(other.reactionType, reactionType)) &&
            (identical(other.reactionTime, reactionTime) ||
                const DeepCollectionEquality()
                    .equals(other.reactionTime, reactionTime)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(linkedLetterID) ^
      const DeepCollectionEquality().hash(reactionType) ^
      const DeepCollectionEquality().hash(reactionTime);

  @override
  _$LocalReactionModelCopyWith<_LocalReactionModel> get copyWith =>
      __$LocalReactionModelCopyWithImpl<_LocalReactionModel>(this, _$identity);
}

abstract class _LocalReactionModel implements LocalReactionModel {
  factory _LocalReactionModel(
      {@required String linkedLetterID,
      @required ReactionType reactionType,
      @required DateTime reactionTime}) = _$_LocalReactionModel;

  @override
  String get linkedLetterID;
  @override
  ReactionType get reactionType;
  @override
  DateTime get reactionTime;
  @override
  _$LocalReactionModelCopyWith<_LocalReactionModel> get copyWith;
}
