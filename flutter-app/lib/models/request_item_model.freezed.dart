// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'request_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
RequestItemModel _$RequestItemModelFromJson(Map<String, dynamic> json) {
  return _RequestItemModel.fromJson(json);
}

class _$RequestItemModelTearOff {
  const _$RequestItemModelTearOff();

  _RequestItemModel call(
      {@required
          String id,
      @required
          bool published,
      @required
          DateTime creationDate,
      @required
          int responseCount,
      @required
          String requesterID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName requesterAvatar,
      @required
          String requestMessage}) {
    return _RequestItemModel(
      id: id,
      published: published,
      creationDate: creationDate,
      responseCount: responseCount,
      requesterID: requesterID,
      requesterAvatar: requesterAvatar,
      requestMessage: requestMessage,
    );
  }
}

// ignore: unused_element
const $RequestItemModel = _$RequestItemModelTearOff();

mixin _$RequestItemModel {
  String get id;
  bool get published;
  DateTime get creationDate;
  int get responseCount;
  String get requesterID;
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  AvatarName get requesterAvatar;
  String get requestMessage;

  Map<String, dynamic> toJson();
  $RequestItemModelCopyWith<RequestItemModel> get copyWith;
}

abstract class $RequestItemModelCopyWith<$Res> {
  factory $RequestItemModelCopyWith(
          RequestItemModel value, $Res Function(RequestItemModel) then) =
      _$RequestItemModelCopyWithImpl<$Res>;
  $Res call(
      {String id,
      bool published,
      DateTime creationDate,
      int responseCount,
      String requesterID,
      @JsonKey(unknownEnumValue: AvatarName.unknown) AvatarName requesterAvatar,
      String requestMessage});
}

class _$RequestItemModelCopyWithImpl<$Res>
    implements $RequestItemModelCopyWith<$Res> {
  _$RequestItemModelCopyWithImpl(this._value, this._then);

  final RequestItemModel _value;
  // ignore: unused_field
  final $Res Function(RequestItemModel) _then;

  @override
  $Res call({
    Object id = freezed,
    Object published = freezed,
    Object creationDate = freezed,
    Object responseCount = freezed,
    Object requesterID = freezed,
    Object requesterAvatar = freezed,
    Object requestMessage = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      published: published == freezed ? _value.published : published as bool,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      responseCount: responseCount == freezed
          ? _value.responseCount
          : responseCount as int,
      requesterID:
          requesterID == freezed ? _value.requesterID : requesterID as String,
      requesterAvatar: requesterAvatar == freezed
          ? _value.requesterAvatar
          : requesterAvatar as AvatarName,
      requestMessage: requestMessage == freezed
          ? _value.requestMessage
          : requestMessage as String,
    ));
  }
}

abstract class _$RequestItemModelCopyWith<$Res>
    implements $RequestItemModelCopyWith<$Res> {
  factory _$RequestItemModelCopyWith(
          _RequestItemModel value, $Res Function(_RequestItemModel) then) =
      __$RequestItemModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      bool published,
      DateTime creationDate,
      int responseCount,
      String requesterID,
      @JsonKey(unknownEnumValue: AvatarName.unknown) AvatarName requesterAvatar,
      String requestMessage});
}

class __$RequestItemModelCopyWithImpl<$Res>
    extends _$RequestItemModelCopyWithImpl<$Res>
    implements _$RequestItemModelCopyWith<$Res> {
  __$RequestItemModelCopyWithImpl(
      _RequestItemModel _value, $Res Function(_RequestItemModel) _then)
      : super(_value, (v) => _then(v as _RequestItemModel));

  @override
  _RequestItemModel get _value => super._value as _RequestItemModel;

  @override
  $Res call({
    Object id = freezed,
    Object published = freezed,
    Object creationDate = freezed,
    Object responseCount = freezed,
    Object requesterID = freezed,
    Object requesterAvatar = freezed,
    Object requestMessage = freezed,
  }) {
    return _then(_RequestItemModel(
      id: id == freezed ? _value.id : id as String,
      published: published == freezed ? _value.published : published as bool,
      creationDate: creationDate == freezed
          ? _value.creationDate
          : creationDate as DateTime,
      responseCount: responseCount == freezed
          ? _value.responseCount
          : responseCount as int,
      requesterID:
          requesterID == freezed ? _value.requesterID : requesterID as String,
      requesterAvatar: requesterAvatar == freezed
          ? _value.requesterAvatar
          : requesterAvatar as AvatarName,
      requestMessage: requestMessage == freezed
          ? _value.requestMessage
          : requestMessage as String,
    ));
  }
}

@JsonSerializable()
class _$_RequestItemModel extends _RequestItemModel
    with DiagnosticableTreeMixin {
  _$_RequestItemModel(
      {@required
          this.id,
      @required
          this.published,
      @required
          this.creationDate,
      @required
          this.responseCount,
      @required
          this.requesterID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          this.requesterAvatar,
      @required
          this.requestMessage})
      : assert(id != null),
        assert(published != null),
        assert(creationDate != null),
        assert(responseCount != null),
        assert(requesterID != null),
        assert(requesterAvatar != null),
        assert(requestMessage != null),
        super._();

  factory _$_RequestItemModel.fromJson(Map<String, dynamic> json) =>
      _$_$_RequestItemModelFromJson(json);

  @override
  final String id;
  @override
  final bool published;
  @override
  final DateTime creationDate;
  @override
  final int responseCount;
  @override
  final String requesterID;
  @override
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  final AvatarName requesterAvatar;
  @override
  final String requestMessage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RequestItemModel(id: $id, published: $published, creationDate: $creationDate, responseCount: $responseCount, requesterID: $requesterID, requesterAvatar: $requesterAvatar, requestMessage: $requestMessage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RequestItemModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('published', published))
      ..add(DiagnosticsProperty('creationDate', creationDate))
      ..add(DiagnosticsProperty('responseCount', responseCount))
      ..add(DiagnosticsProperty('requesterID', requesterID))
      ..add(DiagnosticsProperty('requesterAvatar', requesterAvatar))
      ..add(DiagnosticsProperty('requestMessage', requestMessage));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _RequestItemModel &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.published, published) ||
                const DeepCollectionEquality()
                    .equals(other.published, published)) &&
            (identical(other.creationDate, creationDate) ||
                const DeepCollectionEquality()
                    .equals(other.creationDate, creationDate)) &&
            (identical(other.responseCount, responseCount) ||
                const DeepCollectionEquality()
                    .equals(other.responseCount, responseCount)) &&
            (identical(other.requesterID, requesterID) ||
                const DeepCollectionEquality()
                    .equals(other.requesterID, requesterID)) &&
            (identical(other.requesterAvatar, requesterAvatar) ||
                const DeepCollectionEquality()
                    .equals(other.requesterAvatar, requesterAvatar)) &&
            (identical(other.requestMessage, requestMessage) ||
                const DeepCollectionEquality()
                    .equals(other.requestMessage, requestMessage)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(published) ^
      const DeepCollectionEquality().hash(creationDate) ^
      const DeepCollectionEquality().hash(responseCount) ^
      const DeepCollectionEquality().hash(requesterID) ^
      const DeepCollectionEquality().hash(requesterAvatar) ^
      const DeepCollectionEquality().hash(requestMessage);

  @override
  _$RequestItemModelCopyWith<_RequestItemModel> get copyWith =>
      __$RequestItemModelCopyWithImpl<_RequestItemModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_RequestItemModelToJson(this);
  }
}

abstract class _RequestItemModel extends RequestItemModel {
  _RequestItemModel._() : super._();
  factory _RequestItemModel(
      {@required
          String id,
      @required
          bool published,
      @required
          DateTime creationDate,
      @required
          int responseCount,
      @required
          String requesterID,
      @required
      @JsonKey(unknownEnumValue: AvatarName.unknown)
          AvatarName requesterAvatar,
      @required
          String requestMessage}) = _$_RequestItemModel;

  factory _RequestItemModel.fromJson(Map<String, dynamic> json) =
      _$_RequestItemModel.fromJson;

  @override
  String get id;
  @override
  bool get published;
  @override
  DateTime get creationDate;
  @override
  int get responseCount;
  @override
  String get requesterID;
  @override
  @JsonKey(unknownEnumValue: AvatarName.unknown)
  AvatarName get requesterAvatar;
  @override
  String get requestMessage;
  @override
  _$RequestItemModelCopyWith<_RequestItemModel> get copyWith;
}
