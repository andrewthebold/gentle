// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, non_constant_identifier_names

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$_$_UserModelFromJson(Map<String, dynamic> json) {
  return _$_UserModel(
    id: json['id'] as String,
    joinDate: json['joinDate'] == null
        ? null
        : DateTime.parse(json['joinDate'] as String),
    completedRequests: (json['completedRequests'] as List)
            ?.map((e) => e as String)
            ?.toList() ??
        [],
    blockedUsers:
        (json['blockedUsers'] as List)?.map((e) => e as String)?.toList() ?? [],
    hiddenRequests:
        (json['hiddenRequests'] as List)?.map((e) => e as String)?.toList() ??
            [],
    hiddenLetters:
        (json['hiddenLetters'] as List)?.map((e) => e as String)?.toList() ??
            [],
  );
}

Map<String, dynamic> _$_$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'joinDate': instance.joinDate?.toIso8601String(),
      'completedRequests': instance.completedRequests,
      'blockedUsers': instance.blockedUsers,
      'hiddenRequests': instance.hiddenRequests,
      'hiddenLetters': instance.hiddenLetters,
    };
