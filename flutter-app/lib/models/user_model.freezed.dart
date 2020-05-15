// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

class _$UserModelTearOff {
  const _$UserModelTearOff();

  _UserModel call(
      {@required String id,
      @required DateTime joinDate,
      List<String> completedRequests = const <String>[],
      List<String> blockedUsers = const <String>[],
      List<String> hiddenRequests = const <String>[],
      List<String> hiddenLetters = const <String>[]}) {
    return _UserModel(
      id: id,
      joinDate: joinDate,
      completedRequests: completedRequests,
      blockedUsers: blockedUsers,
      hiddenRequests: hiddenRequests,
      hiddenLetters: hiddenLetters,
    );
  }
}

// ignore: unused_element
const $UserModel = _$UserModelTearOff();

mixin _$UserModel {
  String get id;
  DateTime get joinDate;
  List<String> get completedRequests;
  List<String> get blockedUsers;
  List<String> get hiddenRequests;
  List<String> get hiddenLetters;

  Map<String, dynamic> toJson();
  $UserModelCopyWith<UserModel> get copyWith;
}

abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res>;
  $Res call(
      {String id,
      DateTime joinDate,
      List<String> completedRequests,
      List<String> blockedUsers,
      List<String> hiddenRequests,
      List<String> hiddenLetters});
}

class _$UserModelCopyWithImpl<$Res> implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  final UserModel _value;
  // ignore: unused_field
  final $Res Function(UserModel) _then;

  @override
  $Res call({
    Object id = freezed,
    Object joinDate = freezed,
    Object completedRequests = freezed,
    Object blockedUsers = freezed,
    Object hiddenRequests = freezed,
    Object hiddenLetters = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      joinDate: joinDate == freezed ? _value.joinDate : joinDate as DateTime,
      completedRequests: completedRequests == freezed
          ? _value.completedRequests
          : completedRequests as List<String>,
      blockedUsers: blockedUsers == freezed
          ? _value.blockedUsers
          : blockedUsers as List<String>,
      hiddenRequests: hiddenRequests == freezed
          ? _value.hiddenRequests
          : hiddenRequests as List<String>,
      hiddenLetters: hiddenLetters == freezed
          ? _value.hiddenLetters
          : hiddenLetters as List<String>,
    ));
  }
}

abstract class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(
          _UserModel value, $Res Function(_UserModel) then) =
      __$UserModelCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      DateTime joinDate,
      List<String> completedRequests,
      List<String> blockedUsers,
      List<String> hiddenRequests,
      List<String> hiddenLetters});
}

class __$UserModelCopyWithImpl<$Res> extends _$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(_UserModel _value, $Res Function(_UserModel) _then)
      : super(_value, (v) => _then(v as _UserModel));

  @override
  _UserModel get _value => super._value as _UserModel;

  @override
  $Res call({
    Object id = freezed,
    Object joinDate = freezed,
    Object completedRequests = freezed,
    Object blockedUsers = freezed,
    Object hiddenRequests = freezed,
    Object hiddenLetters = freezed,
  }) {
    return _then(_UserModel(
      id: id == freezed ? _value.id : id as String,
      joinDate: joinDate == freezed ? _value.joinDate : joinDate as DateTime,
      completedRequests: completedRequests == freezed
          ? _value.completedRequests
          : completedRequests as List<String>,
      blockedUsers: blockedUsers == freezed
          ? _value.blockedUsers
          : blockedUsers as List<String>,
      hiddenRequests: hiddenRequests == freezed
          ? _value.hiddenRequests
          : hiddenRequests as List<String>,
      hiddenLetters: hiddenLetters == freezed
          ? _value.hiddenLetters
          : hiddenLetters as List<String>,
    ));
  }
}

@JsonSerializable()
class _$_UserModel extends _UserModel with DiagnosticableTreeMixin {
  _$_UserModel(
      {@required this.id,
      @required this.joinDate,
      this.completedRequests = const <String>[],
      this.blockedUsers = const <String>[],
      this.hiddenRequests = const <String>[],
      this.hiddenLetters = const <String>[]})
      : assert(id != null),
        assert(joinDate != null),
        assert(completedRequests != null),
        assert(blockedUsers != null),
        assert(hiddenRequests != null),
        assert(hiddenLetters != null),
        super._();

  factory _$_UserModel.fromJson(Map<String, dynamic> json) =>
      _$_$_UserModelFromJson(json);

  @override
  final String id;
  @override
  final DateTime joinDate;
  @JsonKey(defaultValue: const <String>[])
  @override
  final List<String> completedRequests;
  @JsonKey(defaultValue: const <String>[])
  @override
  final List<String> blockedUsers;
  @JsonKey(defaultValue: const <String>[])
  @override
  final List<String> hiddenRequests;
  @JsonKey(defaultValue: const <String>[])
  @override
  final List<String> hiddenLetters;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserModel(id: $id, joinDate: $joinDate, completedRequests: $completedRequests, blockedUsers: $blockedUsers, hiddenRequests: $hiddenRequests, hiddenLetters: $hiddenLetters)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('joinDate', joinDate))
      ..add(DiagnosticsProperty('completedRequests', completedRequests))
      ..add(DiagnosticsProperty('blockedUsers', blockedUsers))
      ..add(DiagnosticsProperty('hiddenRequests', hiddenRequests))
      ..add(DiagnosticsProperty('hiddenLetters', hiddenLetters));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserModel &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.joinDate, joinDate) ||
                const DeepCollectionEquality()
                    .equals(other.joinDate, joinDate)) &&
            (identical(other.completedRequests, completedRequests) ||
                const DeepCollectionEquality()
                    .equals(other.completedRequests, completedRequests)) &&
            (identical(other.blockedUsers, blockedUsers) ||
                const DeepCollectionEquality()
                    .equals(other.blockedUsers, blockedUsers)) &&
            (identical(other.hiddenRequests, hiddenRequests) ||
                const DeepCollectionEquality()
                    .equals(other.hiddenRequests, hiddenRequests)) &&
            (identical(other.hiddenLetters, hiddenLetters) ||
                const DeepCollectionEquality()
                    .equals(other.hiddenLetters, hiddenLetters)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(joinDate) ^
      const DeepCollectionEquality().hash(completedRequests) ^
      const DeepCollectionEquality().hash(blockedUsers) ^
      const DeepCollectionEquality().hash(hiddenRequests) ^
      const DeepCollectionEquality().hash(hiddenLetters);

  @override
  _$UserModelCopyWith<_UserModel> get copyWith =>
      __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserModelToJson(this);
  }
}

abstract class _UserModel extends UserModel {
  _UserModel._() : super._();
  factory _UserModel(
      {@required String id,
      @required DateTime joinDate,
      List<String> completedRequests,
      List<String> blockedUsers,
      List<String> hiddenRequests,
      List<String> hiddenLetters}) = _$_UserModel;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$_UserModel.fromJson;

  @override
  String get id;
  @override
  DateTime get joinDate;
  @override
  List<String> get completedRequests;
  @override
  List<String> get blockedUsers;
  @override
  List<String> get hiddenRequests;
  @override
  List<String> get hiddenLetters;
  @override
  _$UserModelCopyWith<_UserModel> get copyWith;
}
