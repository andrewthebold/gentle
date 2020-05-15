// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'activity_log_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ActivityLogItemModel _$ActivityLogItemModelFromJson(Map<String, dynamic> json) {
  return _ActivityLogItemModel.fromJson(json);
}

class _$ActivityLogItemModelTearOff {
  const _$ActivityLogItemModelTearOff();

  _ActivityLogItemModel call(
      {@required
          String id,
      @required
          DateTime creationDate,
      @required
      @JsonKey(unknownEnumValue: ActivityLogItemType.unknown)
          ActivityLogItemType type,
      @required
          String linkedContentID,
      @required
          String linkedContentCreatorID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName linkedContentAvatar,
      @required
          String linkedContentExcerpt,
      @JsonKey(unknownEnumValue: ReactionType.unknown)
      @nullable
          ReactionType reactionType}) {
    return _ActivityLogItemModel(
      id: id,
      creationDate: creationDate,
      type: type,
      linkedContentID: linkedContentID,
      linkedContentCreatorID: linkedContentCreatorID,
      linkedContentAvatar: linkedContentAvatar,
      linkedContentExcerpt: linkedContentExcerpt,
      reactionType: reactionType,
    );
  }
}

// ignore: unused_element
const $ActivityLogItemModel = _$ActivityLogItemModelTearOff();

mixin _$ActivityLogItemModel {
  String get id;
  DateTime get creationDate;
  @JsonKey(unknownEnumValue: ActivityLogItemType.unknown)
  ActivityLogItemType get type;
  String get linkedContentID;
  String get linkedContentCreatorID;
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  AvatarName get linkedContentAvatar;
  String get linkedContentExcerpt;
  @JsonKey(unknownEnumValue: ReactionType.unknown)
  @nullable
  ReactionType get reactionType;

  Map<String, dynamic> toJson();
  $ActivityLogItemModelCopyWith<ActivityLogItemModel> get copyWith;
}

abstract class $ActivityLogItemModelCopyWith<$Res> {
  factory $ActivityLogItemModelCopyWith(ActivityLogItemModel value,
          $Res Function(ActivityLogItemModel) then) =
      _$ActivityLogItemModelCopyWithImpl<$Res>;
  $Res call(
      {String id,
      DateTime creationDate,
      @JsonKey(unknownEnumValue: ActivityLogItemType.unknown)
          ActivityLogItemType type,
      String linkedContentID,
      String linkedContentCreatorID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName linkedContentAvatar,
      String linkedContentExcerpt,
      @JsonKey(unknownEnumValue: ReactionType.unknown)
      @nullable
          ReactionType reactionType});
}

class _$ActivityLogItemModelCopyWithImpl<$Res>
    implements $ActivityLogItemModelCopyWith<$Res> {
  _$ActivityLogItemModelCopyWithImpl(this._value, this._then);

  final ActivityLogItemModel _value;
  // ignore: unused_field
  final $Res Function(ActivityLogItemModel) _then;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object type = freezed,
    Object linkedContentID = freezed,
    Object linkedContentCreatorID = freezed,
    Object linkedContentAvatar = freezed,
    Object linkedContentExcerpt = freezed,
    Object reactionType = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      type: type == freezed ? _value.type : type as ActivityLogItemType,
      linkedContentID: linkedContentID == freezed
          ? _value.linkedContentID
          : linkedContentID as String,
      linkedContentCreatorID: linkedContentCreatorID == freezed
          ? _value.linkedContentCreatorID
          : linkedContentCreatorID as String,
      linkedContentAvatar: linkedContentAvatar == freezed
          ? _value.linkedContentAvatar
          : linkedContentAvatar as AvatarName,
      linkedContentExcerpt: linkedContentExcerpt == freezed
          ? _value.linkedContentExcerpt
          : linkedContentExcerpt as String,
      reactionType: reactionType == freezed
          ? _value.reactionType
          : reactionType as ReactionType,
    ));
  }
}

abstract class _$ActivityLogItemModelCopyWith<$Res>
    implements $ActivityLogItemModelCopyWith<$Res> {
  factory _$ActivityLogItemModelCopyWith(_ActivityLogItemModel value,
          $Res Function(_ActivityLogItemModel) then) =
      __$ActivityLogItemModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      DateTime creationDate,
      @JsonKey(unknownEnumValue: ActivityLogItemType.unknown)
          ActivityLogItemType type,
      String linkedContentID,
      String linkedContentCreatorID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName linkedContentAvatar,
      String linkedContentExcerpt,
      @JsonKey(unknownEnumValue: ReactionType.unknown)
      @nullable
          ReactionType reactionType});
}

class __$ActivityLogItemModelCopyWithImpl<$Res>
    extends _$ActivityLogItemModelCopyWithImpl<$Res>
    implements _$ActivityLogItemModelCopyWith<$Res> {
  __$ActivityLogItemModelCopyWithImpl(
      _ActivityLogItemModel _value, $Res Function(_ActivityLogItemModel) _then)
      : super(_value, (v) => _then(v as _ActivityLogItemModel));

  @override
  _ActivityLogItemModel get _value => super._value as _ActivityLogItemModel;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object type = freezed,
    Object linkedContentID = freezed,
    Object linkedContentCreatorID = freezed,
    Object linkedContentAvatar = freezed,
    Object linkedContentExcerpt = freezed,
    Object reactionType = freezed,
  }) {
    return _then(_ActivityLogItemModel(
      id: id == freezed ? _value.id : id as String,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      type: type == freezed ? _value.type : type as ActivityLogItemType,
      linkedContentID: linkedContentID == freezed
          ? _value.linkedContentID
          : linkedContentID as String,
      linkedContentCreatorID: linkedContentCreatorID == freezed
          ? _value.linkedContentCreatorID
          : linkedContentCreatorID as String,
      linkedContentAvatar: linkedContentAvatar == freezed
          ? _value.linkedContentAvatar
          : linkedContentAvatar as AvatarName,
      linkedContentExcerpt: linkedContentExcerpt == freezed
          ? _value.linkedContentExcerpt
          : linkedContentExcerpt as String,
      reactionType: reactionType == freezed
          ? _value.reactionType
          : reactionType as ReactionType,
    ));
  }
}

@JsonSerializable()
class _$_ActivityLogItemModel extends _ActivityLogItemModel
    with DiagnosticableTreeMixin {
  _$_ActivityLogItemModel(
      {@required
          this.id,
      @required
          this.creationDate,
      @required
      @JsonKey(unknownEnumValue: ActivityLogItemType.unknown)
          this.type,
      @required
          this.linkedContentID,
      @required
          this.linkedContentCreatorID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          this.linkedContentAvatar,
      @required
          this.linkedContentExcerpt,
      @JsonKey(unknownEnumValue: ReactionType.unknown)
      @nullable
          this.reactionType})
      : assert(id != null),
        assert(creationDate != null),
        assert(type != null),
        assert(linkedContentID != null),
        assert(linkedContentCreatorID != null),
        assert(linkedContentAvatar != null),
        assert(linkedContentExcerpt != null),
        super._();

  factory _$_ActivityLogItemModel.fromJson(Map<String, dynamic> json) =>
      _$_$_ActivityLogItemModelFromJson(json);

  @override
  final String id;
  @override
  final DateTime creationDate;
  @override
  @JsonKey(unknownEnumValue: ActivityLogItemType.unknown)
  final ActivityLogItemType type;
  @override
  final String linkedContentID;
  @override
  final String linkedContentCreatorID;
  @override
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  final AvatarName linkedContentAvatar;
  @override
  final String linkedContentExcerpt;
  @override
  @JsonKey(unknownEnumValue: ReactionType.unknown)
  @nullable
  final ReactionType reactionType;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ActivityLogItemModel(id: $id, creationDate: $creationDate, type: $type, linkedContentID: $linkedContentID, linkedContentCreatorID: $linkedContentCreatorID, linkedContentAvatar: $linkedContentAvatar, linkedContentExcerpt: $linkedContentExcerpt, reactionType: $reactionType)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ActivityLogItemModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('creationDate', creationDate))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('linkedContentID', linkedContentID))
      ..add(
          DiagnosticsProperty('linkedContentCreatorID', linkedContentCreatorID))
      ..add(DiagnosticsProperty('linkedContentAvatar', linkedContentAvatar))
      ..add(DiagnosticsProperty('linkedContentExcerpt', linkedContentExcerpt))
      ..add(DiagnosticsProperty('reactionType', reactionType));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ActivityLogItemModel &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.creationDate, creationDate) ||
                const DeepCollectionEquality()
                    .equals(other.creationDate, creationDate)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.linkedContentID, linkedContentID) ||
                const DeepCollectionEquality()
                    .equals(other.linkedContentID, linkedContentID)) &&
            (identical(other.linkedContentCreatorID, linkedContentCreatorID) ||
                const DeepCollectionEquality().equals(
                    other.linkedContentCreatorID, linkedContentCreatorID)) &&
            (identical(other.linkedContentAvatar, linkedContentAvatar) ||
                const DeepCollectionEquality()
                    .equals(other.linkedContentAvatar, linkedContentAvatar)) &&
            (identical(other.linkedContentExcerpt, linkedContentExcerpt) ||
                const DeepCollectionEquality().equals(
                    other.linkedContentExcerpt, linkedContentExcerpt)) &&
            (identical(other.reactionType, reactionType) ||
                const DeepCollectionEquality()
                    .equals(other.reactionType, reactionType)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(creationDate) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(linkedContentID) ^
      const DeepCollectionEquality().hash(linkedContentCreatorID) ^
      const DeepCollectionEquality().hash(linkedContentAvatar) ^
      const DeepCollectionEquality().hash(linkedContentExcerpt) ^
      const DeepCollectionEquality().hash(reactionType);

  @override
  _$ActivityLogItemModelCopyWith<_ActivityLogItemModel> get copyWith =>
      __$ActivityLogItemModelCopyWithImpl<_ActivityLogItemModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ActivityLogItemModelToJson(this);
  }
}

abstract class _ActivityLogItemModel extends ActivityLogItemModel {
  _ActivityLogItemModel._() : super._();
  factory _ActivityLogItemModel(
      {@required
          String id,
      @required
          DateTime creationDate,
      @required
      @JsonKey(unknownEnumValue: ActivityLogItemType.unknown)
          ActivityLogItemType type,
      @required
          String linkedContentID,
      @required
          String linkedContentCreatorID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName linkedContentAvatar,
      @required
          String linkedContentExcerpt,
      @JsonKey(unknownEnumValue: ReactionType.unknown)
      @nullable
          ReactionType reactionType}) = _$_ActivityLogItemModel;

  factory _ActivityLogItemModel.fromJson(Map<String, dynamic> json) =
      _$_ActivityLogItemModel.fromJson;

  @override
  String get id;
  @override
  DateTime get creationDate;
  @override
  @JsonKey(unknownEnumValue: ActivityLogItemType.unknown)
  ActivityLogItemType get type;
  @override
  String get linkedContentID;
  @override
  String get linkedContentCreatorID;
  @override
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  AvatarName get linkedContentAvatar;
  @override
  String get linkedContentExcerpt;
  @override
  @JsonKey(unknownEnumValue: ReactionType.unknown)
  @nullable
  ReactionType get reactionType;
  @override
  _$ActivityLogItemModelCopyWith<_ActivityLogItemModel> get copyWith;
}
