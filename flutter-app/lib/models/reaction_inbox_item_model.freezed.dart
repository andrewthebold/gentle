// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'reaction_inbox_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
ReactionInboxItemModel _$ReactionInboxItemModelFromJson(
    Map<String, dynamic> json) {
  return _ReactionInboxItemModel.fromJson(json);
}

class _$ReactionInboxItemModelTearOff {
  const _$ReactionInboxItemModelTearOff();

  _ReactionInboxItemModel call(
      {@required
          String id,
      @required
          DateTime creationDate,
      @required
      @JsonKey(unknownEnumValue: ReactionType.unknown)
          ReactionType type,
      @required
          String linkedContentID}) {
    return _ReactionInboxItemModel(
      id: id,
      creationDate: creationDate,
      type: type,
      linkedContentID: linkedContentID,
    );
  }
}

// ignore: unused_element
const $ReactionInboxItemModel = _$ReactionInboxItemModelTearOff();

mixin _$ReactionInboxItemModel {
  String get id;
  DateTime get creationDate;
  @JsonKey(unknownEnumValue: ReactionType.unknown)
  ReactionType get type;
  String get linkedContentID;

  Map<String, dynamic> toJson();
  $ReactionInboxItemModelCopyWith<ReactionInboxItemModel> get copyWith;
}

abstract class $ReactionInboxItemModelCopyWith<$Res> {
  factory $ReactionInboxItemModelCopyWith(ReactionInboxItemModel value,
          $Res Function(ReactionInboxItemModel) then) =
      _$ReactionInboxItemModelCopyWithImpl<$Res>;
  $Res call(
      {String id,
      DateTime creationDate,
      @JsonKey(unknownEnumValue: ReactionType.unknown) ReactionType type,
      String linkedContentID});
}

class _$ReactionInboxItemModelCopyWithImpl<$Res>
    implements $ReactionInboxItemModelCopyWith<$Res> {
  _$ReactionInboxItemModelCopyWithImpl(this._value, this._then);

  final ReactionInboxItemModel _value;
  // ignore: unused_field
  final $Res Function(ReactionInboxItemModel) _then;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object type = freezed,
    Object linkedContentID = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      type: type == freezed ? _value.type : type as ReactionType,
      linkedContentID: linkedContentID == freezed
          ? _value.linkedContentID
          : linkedContentID as String,
    ));
  }
}

abstract class _$ReactionInboxItemModelCopyWith<$Res>
    implements $ReactionInboxItemModelCopyWith<$Res> {
  factory _$ReactionInboxItemModelCopyWith(_ReactionInboxItemModel value,
          $Res Function(_ReactionInboxItemModel) then) =
      __$ReactionInboxItemModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      DateTime creationDate,
      @JsonKey(unknownEnumValue: ReactionType.unknown) ReactionType type,
      String linkedContentID});
}

class __$ReactionInboxItemModelCopyWithImpl<$Res>
    extends _$ReactionInboxItemModelCopyWithImpl<$Res>
    implements _$ReactionInboxItemModelCopyWith<$Res> {
  __$ReactionInboxItemModelCopyWithImpl(_ReactionInboxItemModel _value,
      $Res Function(_ReactionInboxItemModel) _then)
      : super(_value, (v) => _then(v as _ReactionInboxItemModel));

  @override
  _ReactionInboxItemModel get _value => super._value as _ReactionInboxItemModel;

  @override
  $Res call({
    Object id = freezed,
    Object creationDate = freezed,
    Object type = freezed,
    Object linkedContentID = freezed,
  }) {
    return _then(_ReactionInboxItemModel(
      id: id == freezed ? _value.id : id as String,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      type: type == freezed ? _value.type : type as ReactionType,
      linkedContentID: linkedContentID == freezed
          ? _value.linkedContentID
          : linkedContentID as String,
    ));
  }
}

@JsonSerializable()
class _$_ReactionInboxItemModel extends _ReactionInboxItemModel {
  _$_ReactionInboxItemModel(
      {@required this.id,
      @required this.creationDate,
      @required @JsonKey(unknownEnumValue: ReactionType.unknown) this.type,
      @required this.linkedContentID})
      : assert(id != null),
        assert(creationDate != null),
        assert(type != null),
        assert(linkedContentID != null),
        super._();

  factory _$_ReactionInboxItemModel.fromJson(Map<String, dynamic> json) =>
      _$_$_ReactionInboxItemModelFromJson(json);

  @override
  final String id;
  @override
  final DateTime creationDate;
  @override
  @JsonKey(unknownEnumValue: ReactionType.unknown)
  final ReactionType type;
  @override
  final String linkedContentID;

  @override
  String toString() {
    return 'ReactionInboxItemModel(id: $id, creationDate: $creationDate, type: $type, linkedContentID: $linkedContentID)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ReactionInboxItemModel &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.creationDate, creationDate) ||
                const DeepCollectionEquality()
                    .equals(other.creationDate, creationDate)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.linkedContentID, linkedContentID) ||
                const DeepCollectionEquality()
                    .equals(other.linkedContentID, linkedContentID)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(creationDate) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(linkedContentID);

  @override
  _$ReactionInboxItemModelCopyWith<_ReactionInboxItemModel> get copyWith =>
      __$ReactionInboxItemModelCopyWithImpl<_ReactionInboxItemModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ReactionInboxItemModelToJson(this);
  }
}

abstract class _ReactionInboxItemModel extends ReactionInboxItemModel {
  _ReactionInboxItemModel._() : super._();
  factory _ReactionInboxItemModel(
      {@required
          String id,
      @required
          DateTime creationDate,
      @required
      @JsonKey(unknownEnumValue: ReactionType.unknown)
          ReactionType type,
      @required
          String linkedContentID}) = _$_ReactionInboxItemModel;

  factory _ReactionInboxItemModel.fromJson(Map<String, dynamic> json) =
      _$_ReactionInboxItemModel.fromJson;

  @override
  String get id;
  @override
  DateTime get creationDate;
  @override
  @JsonKey(unknownEnumValue: ReactionType.unknown)
  ReactionType get type;
  @override
  String get linkedContentID;
  @override
  _$ReactionInboxItemModelCopyWith<_ReactionInboxItemModel> get copyWith;
}
