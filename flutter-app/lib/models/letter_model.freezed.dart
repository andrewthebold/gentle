// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'letter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
LetterModel _$LetterModelFromJson(Map<String, dynamic> json) {
  return _LetterModel.fromJson(json);
}

class _$LetterModelTearOff {
  const _$LetterModelTearOff();

  _LetterModel call(
      {@required
          String id,
      @required
          bool published,
      @required
          DateTime creationDate,
      @nullable
          String requestID,
      @nullable
          String requestMessage,
      @nullable
          String requestCreatorID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
      @nullable
          AvatarName requestCreatorAvatar,
      @required
          String letterSenderID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName letterSenderAvatar,
      @required
          String letterMessage,
      @required
          String recipientID,
      @nullable
          DateTime reactionTime,
      @JsonKey(unknownEnumValue: ReactionType.unknown)
      @nullable
          ReactionType reactionType}) {
    return _LetterModel(
      id: id,
      published: published,
      creationDate: creationDate,
      requestID: requestID,
      requestMessage: requestMessage,
      requestCreatorID: requestCreatorID,
      requestCreatorAvatar: requestCreatorAvatar,
      letterSenderID: letterSenderID,
      letterSenderAvatar: letterSenderAvatar,
      letterMessage: letterMessage,
      recipientID: recipientID,
      reactionTime: reactionTime,
      reactionType: reactionType,
    );
  }
}

// ignore: unused_element
const $LetterModel = _$LetterModelTearOff();

mixin _$LetterModel {
  String get id;
  bool get published;
  DateTime get creationDate;
  @nullable
  String get requestID;
  @nullable
  String get requestMessage;
  @nullable
  String get requestCreatorID;
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  @nullable
  AvatarName get requestCreatorAvatar;
  String get letterSenderID;
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  AvatarName get letterSenderAvatar;
  String get letterMessage;
  String get recipientID;
  @nullable
  DateTime get reactionTime;
  @JsonKey(unknownEnumValue: ReactionType.unknown)
  @nullable
  ReactionType get reactionType;

  Map<String, dynamic> toJson();
  $LetterModelCopyWith<LetterModel> get copyWith;
}

abstract class $LetterModelCopyWith<$Res> {
  factory $LetterModelCopyWith(
          LetterModel value, $Res Function(LetterModel) then) =
      _$LetterModelCopyWithImpl<$Res>;
  $Res call(
      {String id,
      bool published,
      DateTime creationDate,
      @nullable
          String requestID,
      @nullable
          String requestMessage,
      @nullable
          String requestCreatorID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
      @nullable
          AvatarName requestCreatorAvatar,
      String letterSenderID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName letterSenderAvatar,
      String letterMessage,
      String recipientID,
      @nullable
          DateTime reactionTime,
      @JsonKey(unknownEnumValue: ReactionType.unknown)
      @nullable
          ReactionType reactionType});
}

class _$LetterModelCopyWithImpl<$Res> implements $LetterModelCopyWith<$Res> {
  _$LetterModelCopyWithImpl(this._value, this._then);

  final LetterModel _value;
  // ignore: unused_field
  final $Res Function(LetterModel) _then;

  @override
  $Res call({
    Object id = freezed,
    Object published = freezed,
    Object creationDate = freezed,
    Object requestID = freezed,
    Object requestMessage = freezed,
    Object requestCreatorID = freezed,
    Object requestCreatorAvatar = freezed,
    Object letterSenderID = freezed,
    Object letterSenderAvatar = freezed,
    Object letterMessage = freezed,
    Object recipientID = freezed,
    Object reactionTime = freezed,
    Object reactionType = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      published: published == freezed ? _value.published : published as bool,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      requestID: requestID == freezed ? _value.requestID : requestID as String,
      requestMessage: requestMessage == freezed
          ? _value.requestMessage
          : requestMessage as String,
      requestCreatorID: requestCreatorID == freezed
          ? _value.requestCreatorID
          : requestCreatorID as String,
      requestCreatorAvatar: requestCreatorAvatar == freezed
          ? _value.requestCreatorAvatar
          : requestCreatorAvatar as AvatarName,
      letterSenderID: letterSenderID == freezed
          ? _value.letterSenderID
          : letterSenderID as String,
      letterSenderAvatar: letterSenderAvatar == freezed
          ? _value.letterSenderAvatar
          : letterSenderAvatar as AvatarName,
      letterMessage: letterMessage == freezed
          ? _value.letterMessage
          : letterMessage as String,
      recipientID:
          recipientID == freezed ? _value.recipientID : recipientID as String,
      reactionTime: reactionTime == freezed
          ? _value.reactionTime
          : reactionTime as DateTime,
      reactionType: reactionType == freezed
          ? _value.reactionType
          : reactionType as ReactionType,
    ));
  }
}

abstract class _$LetterModelCopyWith<$Res>
    implements $LetterModelCopyWith<$Res> {
  factory _$LetterModelCopyWith(
          _LetterModel value, $Res Function(_LetterModel) then) =
      __$LetterModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      bool published,
      DateTime creationDate,
      @nullable
          String requestID,
      @nullable
          String requestMessage,
      @nullable
          String requestCreatorID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
      @nullable
          AvatarName requestCreatorAvatar,
      String letterSenderID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName letterSenderAvatar,
      String letterMessage,
      String recipientID,
      @nullable
          DateTime reactionTime,
      @JsonKey(unknownEnumValue: ReactionType.unknown)
      @nullable
          ReactionType reactionType});
}

class __$LetterModelCopyWithImpl<$Res> extends _$LetterModelCopyWithImpl<$Res>
    implements _$LetterModelCopyWith<$Res> {
  __$LetterModelCopyWithImpl(
      _LetterModel _value, $Res Function(_LetterModel) _then)
      : super(_value, (v) => _then(v as _LetterModel));

  @override
  _LetterModel get _value => super._value as _LetterModel;

  @override
  $Res call({
    Object id = freezed,
    Object published = freezed,
    Object creationDate = freezed,
    Object requestID = freezed,
    Object requestMessage = freezed,
    Object requestCreatorID = freezed,
    Object requestCreatorAvatar = freezed,
    Object letterSenderID = freezed,
    Object letterSenderAvatar = freezed,
    Object letterMessage = freezed,
    Object recipientID = freezed,
    Object reactionTime = freezed,
    Object reactionType = freezed,
  }) {
    return _then(_LetterModel(
      id: id == freezed ? _value.id : id as String,
      published: published == freezed ? _value.published : published as bool,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      requestID: requestID == freezed ? _value.requestID : requestID as String,
      requestMessage: requestMessage == freezed
          ? _value.requestMessage
          : requestMessage as String,
      requestCreatorID: requestCreatorID == freezed
          ? _value.requestCreatorID
          : requestCreatorID as String,
      requestCreatorAvatar: requestCreatorAvatar == freezed
          ? _value.requestCreatorAvatar
          : requestCreatorAvatar as AvatarName,
      letterSenderID: letterSenderID == freezed
          ? _value.letterSenderID
          : letterSenderID as String,
      letterSenderAvatar: letterSenderAvatar == freezed
          ? _value.letterSenderAvatar
          : letterSenderAvatar as AvatarName,
      letterMessage: letterMessage == freezed
          ? _value.letterMessage
          : letterMessage as String,
      recipientID:
          recipientID == freezed ? _value.recipientID : recipientID as String,
      reactionTime: reactionTime == freezed
          ? _value.reactionTime
          : reactionTime as DateTime,
      reactionType: reactionType == freezed
          ? _value.reactionType
          : reactionType as ReactionType,
    ));
  }
}

@JsonSerializable()
class _$_LetterModel extends _LetterModel with DiagnosticableTreeMixin {
  _$_LetterModel(
      {@required
          this.id,
      @required
          this.published,
      @required
          this.creationDate,
      @nullable
          this.requestID,
      @nullable
          this.requestMessage,
      @nullable
          this.requestCreatorID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
      @nullable
          this.requestCreatorAvatar,
      @required
          this.letterSenderID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          this.letterSenderAvatar,
      @required
          this.letterMessage,
      @required
          this.recipientID,
      @nullable
          this.reactionTime,
      @JsonKey(unknownEnumValue: ReactionType.unknown)
      @nullable
          this.reactionType})
      : assert(id != null),
        assert(published != null),
        assert(creationDate != null),
        assert(letterSenderID != null),
        assert(letterSenderAvatar != null),
        assert(letterMessage != null),
        assert(recipientID != null),
        super._();

  factory _$_LetterModel.fromJson(Map<String, dynamic> json) =>
      _$_$_LetterModelFromJson(json);

  @override
  final String id;
  @override
  final bool published;
  @override
  final DateTime creationDate;
  @override
  @nullable
  final String requestID;
  @override
  @nullable
  final String requestMessage;
  @override
  @nullable
  final String requestCreatorID;
  @override
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  @nullable
  final AvatarName requestCreatorAvatar;
  @override
  final String letterSenderID;
  @override
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  final AvatarName letterSenderAvatar;
  @override
  final String letterMessage;
  @override
  final String recipientID;
  @override
  @nullable
  final DateTime reactionTime;
  @override
  @JsonKey(unknownEnumValue: ReactionType.unknown)
  @nullable
  final ReactionType reactionType;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LetterModel(id: $id, published: $published, creationDate: $creationDate, requestID: $requestID, requestMessage: $requestMessage, requestCreatorID: $requestCreatorID, requestCreatorAvatar: $requestCreatorAvatar, letterSenderID: $letterSenderID, letterSenderAvatar: $letterSenderAvatar, letterMessage: $letterMessage, recipientID: $recipientID, reactionTime: $reactionTime, reactionType: $reactionType)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LetterModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('published', published))
      ..add(DiagnosticsProperty('creationDate', creationDate))
      ..add(DiagnosticsProperty('requestID', requestID))
      ..add(DiagnosticsProperty('requestMessage', requestMessage))
      ..add(DiagnosticsProperty('requestCreatorID', requestCreatorID))
      ..add(DiagnosticsProperty('requestCreatorAvatar', requestCreatorAvatar))
      ..add(DiagnosticsProperty('letterSenderID', letterSenderID))
      ..add(DiagnosticsProperty('letterSenderAvatar', letterSenderAvatar))
      ..add(DiagnosticsProperty('letterMessage', letterMessage))
      ..add(DiagnosticsProperty('recipientID', recipientID))
      ..add(DiagnosticsProperty('reactionTime', reactionTime))
      ..add(DiagnosticsProperty('reactionType', reactionType));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LetterModel &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.published, published) ||
                const DeepCollectionEquality()
                    .equals(other.published, published)) &&
            (identical(other.creationDate, creationDate) ||
                const DeepCollectionEquality()
                    .equals(other.creationDate, creationDate)) &&
            (identical(other.requestID, requestID) ||
                const DeepCollectionEquality()
                    .equals(other.requestID, requestID)) &&
            (identical(other.requestMessage, requestMessage) ||
                const DeepCollectionEquality()
                    .equals(other.requestMessage, requestMessage)) &&
            (identical(other.requestCreatorID, requestCreatorID) ||
                const DeepCollectionEquality()
                    .equals(other.requestCreatorID, requestCreatorID)) &&
            (identical(other.requestCreatorAvatar, requestCreatorAvatar) ||
                const DeepCollectionEquality().equals(
                    other.requestCreatorAvatar, requestCreatorAvatar)) &&
            (identical(other.letterSenderID, letterSenderID) ||
                const DeepCollectionEquality()
                    .equals(other.letterSenderID, letterSenderID)) &&
            (identical(other.letterSenderAvatar, letterSenderAvatar) ||
                const DeepCollectionEquality()
                    .equals(other.letterSenderAvatar, letterSenderAvatar)) &&
            (identical(other.letterMessage, letterMessage) ||
                const DeepCollectionEquality()
                    .equals(other.letterMessage, letterMessage)) &&
            (identical(other.recipientID, recipientID) ||
                const DeepCollectionEquality()
                    .equals(other.recipientID, recipientID)) &&
            (identical(other.reactionTime, reactionTime) ||
                const DeepCollectionEquality()
                    .equals(other.reactionTime, reactionTime)) &&
            (identical(other.reactionType, reactionType) ||
                const DeepCollectionEquality()
                    .equals(other.reactionType, reactionType)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(published) ^
      const DeepCollectionEquality().hash(creationDate) ^
      const DeepCollectionEquality().hash(requestID) ^
      const DeepCollectionEquality().hash(requestMessage) ^
      const DeepCollectionEquality().hash(requestCreatorID) ^
      const DeepCollectionEquality().hash(requestCreatorAvatar) ^
      const DeepCollectionEquality().hash(letterSenderID) ^
      const DeepCollectionEquality().hash(letterSenderAvatar) ^
      const DeepCollectionEquality().hash(letterMessage) ^
      const DeepCollectionEquality().hash(recipientID) ^
      const DeepCollectionEquality().hash(reactionTime) ^
      const DeepCollectionEquality().hash(reactionType);

  @override
  _$LetterModelCopyWith<_LetterModel> get copyWith =>
      __$LetterModelCopyWithImpl<_LetterModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_LetterModelToJson(this);
  }
}

abstract class _LetterModel extends LetterModel {
  _LetterModel._() : super._();
  factory _LetterModel(
      {@required
          String id,
      @required
          bool published,
      @required
          DateTime creationDate,
      @nullable
          String requestID,
      @nullable
          String requestMessage,
      @nullable
          String requestCreatorID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
      @nullable
          AvatarName requestCreatorAvatar,
      @required
          String letterSenderID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName letterSenderAvatar,
      @required
          String letterMessage,
      @required
          String recipientID,
      @nullable
          DateTime reactionTime,
      @JsonKey(unknownEnumValue: ReactionType.unknown)
      @nullable
          ReactionType reactionType}) = _$_LetterModel;

  factory _LetterModel.fromJson(Map<String, dynamic> json) =
      _$_LetterModel.fromJson;

  @override
  String get id;
  @override
  bool get published;
  @override
  DateTime get creationDate;
  @override
  @nullable
  String get requestID;
  @override
  @nullable
  String get requestMessage;
  @override
  @nullable
  String get requestCreatorID;
  @override
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  @nullable
  AvatarName get requestCreatorAvatar;
  @override
  String get letterSenderID;
  @override
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  AvatarName get letterSenderAvatar;
  @override
  String get letterMessage;
  @override
  String get recipientID;
  @override
  @nullable
  DateTime get reactionTime;
  @override
  @JsonKey(unknownEnumValue: ReactionType.unknown)
  @nullable
  ReactionType get reactionType;
  @override
  _$LetterModelCopyWith<_LetterModel> get copyWith;
}
