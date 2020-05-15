// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'inbox_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
InboxItemModel _$InboxItemModelFromJson(Map<String, dynamic> json) {
  return _InboxItemModel.fromJson(json);
}

class _$InboxItemModelTearOff {
  const _$InboxItemModelTearOff();

  _InboxItemModel call(
      {@required
          String id,
      @required
          DateTime creationDate,
      @required
          String linkedContentID,
      @required
          String linkedContentCreatorID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName linkedContentAvatar,
      @required
          String linkedContentExcerpt}) {
    return _InboxItemModel(
      id: id,
      creationDate: creationDate,
      linkedContentID: linkedContentID,
      linkedContentCreatorID: linkedContentCreatorID,
      linkedContentAvatar: linkedContentAvatar,
      linkedContentExcerpt: linkedContentExcerpt,
    );
  }
}

// ignore: unused_element
const $InboxItemModel = _$InboxItemModelTearOff();

mixin _$InboxItemModel {
  String get id;
  DateTime get creationDate;
  String get linkedContentID;
  String get linkedContentCreatorID;
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  AvatarName get linkedContentAvatar;
  String get linkedContentExcerpt;

  Map<String, dynamic> toJson();
  $InboxItemModelCopyWith<InboxItemModel> get copyWith;
}

abstract class $InboxItemModelCopyWith<$Res> {
  factory $InboxItemModelCopyWith(
          InboxItemModel value, $Res Function(InboxItemModel) then) =
      _$InboxItemModelCopyWithImpl<$Res>;
  $Res call(
      {String id,
      DateTime creationDate,
      String linkedContentID,
      String linkedContentCreatorID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName linkedContentAvatar,
      String linkedContentExcerpt});
}

class _$InboxItemModelCopyWithImpl<$Res>
    implements $InboxItemModelCopyWith<$Res> {
  _$InboxItemModelCopyWithImpl(this._value, this._then);

  final InboxItemModel _value;
  // ignore: unused_field
  final $Res Function(InboxItemModel) _then;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object linkedContentID = freezed,
    Object linkedContentCreatorID = freezed,
    Object linkedContentAvatar = freezed,
    Object linkedContentExcerpt = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
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
    ));
  }
}

abstract class _$InboxItemModelCopyWith<$Res>
    implements $InboxItemModelCopyWith<$Res> {
  factory _$InboxItemModelCopyWith(
          _InboxItemModel value, $Res Function(_InboxItemModel) then) =
      __$InboxItemModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      DateTime creationDate,
      String linkedContentID,
      String linkedContentCreatorID,
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName linkedContentAvatar,
      String linkedContentExcerpt});
}

class __$InboxItemModelCopyWithImpl<$Res>
    extends _$InboxItemModelCopyWithImpl<$Res>
    implements _$InboxItemModelCopyWith<$Res> {
  __$InboxItemModelCopyWithImpl(
      _InboxItemModel _value, $Res Function(_InboxItemModel) _then)
      : super(_value, (v) => _then(v as _InboxItemModel));

  @override
  _InboxItemModel get _value => super._value as _InboxItemModel;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object linkedContentID = freezed,
    Object linkedContentCreatorID = freezed,
    Object linkedContentAvatar = freezed,
    Object linkedContentExcerpt = freezed,
  }) {
    return _then(_InboxItemModel(
      id: id == freezed ? _value.id : id as String,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
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
    ));
  }
}

@JsonSerializable()
class _$_InboxItemModel extends _InboxItemModel with DiagnosticableTreeMixin {
  _$_InboxItemModel(
      {@required
          this.id,
      @required
          this.creationDate,
      @required
          this.linkedContentID,
      @required
          this.linkedContentCreatorID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          this.linkedContentAvatar,
      @required
          this.linkedContentExcerpt})
      : assert(id != null),
        assert(creationDate != null),
        assert(linkedContentID != null),
        assert(linkedContentCreatorID != null),
        assert(linkedContentAvatar != null),
        assert(linkedContentExcerpt != null),
        super._();

  factory _$_InboxItemModel.fromJson(Map<String, dynamic> json) =>
      _$_$_InboxItemModelFromJson(json);

  @override
  final String id;
  @override
  final DateTime creationDate;
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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InboxItemModel(id: $id, creationDate: $creationDate, linkedContentID: $linkedContentID, linkedContentCreatorID: $linkedContentCreatorID, linkedContentAvatar: $linkedContentAvatar, linkedContentExcerpt: $linkedContentExcerpt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InboxItemModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('creationDate', creationDate))
      ..add(DiagnosticsProperty('linkedContentID', linkedContentID))
      ..add(
          DiagnosticsProperty('linkedContentCreatorID', linkedContentCreatorID))
      ..add(DiagnosticsProperty('linkedContentAvatar', linkedContentAvatar))
      ..add(DiagnosticsProperty('linkedContentExcerpt', linkedContentExcerpt));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _InboxItemModel &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.creationDate, creationDate) ||
                const DeepCollectionEquality()
                    .equals(other.creationDate, creationDate)) &&
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
                const DeepCollectionEquality()
                    .equals(other.linkedContentExcerpt, linkedContentExcerpt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(creationDate) ^
      const DeepCollectionEquality().hash(linkedContentID) ^
      const DeepCollectionEquality().hash(linkedContentCreatorID) ^
      const DeepCollectionEquality().hash(linkedContentAvatar) ^
      const DeepCollectionEquality().hash(linkedContentExcerpt);

  @override
  _$InboxItemModelCopyWith<_InboxItemModel> get copyWith =>
      __$InboxItemModelCopyWithImpl<_InboxItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_InboxItemModelToJson(this);
  }
}

abstract class _InboxItemModel extends InboxItemModel {
  _InboxItemModel._() : super._();
  factory _InboxItemModel(
      {@required
          String id,
      @required
          DateTime creationDate,
      @required
          String linkedContentID,
      @required
          String linkedContentCreatorID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName linkedContentAvatar,
      @required
          String linkedContentExcerpt}) = _$_InboxItemModel;

  factory _InboxItemModel.fromJson(Map<String, dynamic> json) =
      _$_InboxItemModel.fromJson;

  @override
  String get id;
  @override
  DateTime get creationDate;
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
  _$InboxItemModelCopyWith<_InboxItemModel> get copyWith;
}
