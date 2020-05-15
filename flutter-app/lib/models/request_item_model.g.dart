// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, non_constant_identifier_names

part of 'request_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RequestItemModel _$_$_RequestItemModelFromJson(Map<String, dynamic> json) {
  return _$_RequestItemModel(
    id: json['id'] as String,
    published: json['published'] as bool,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    responseCount: json['responseCount'] as int,
    requesterID: json['requesterID'] as String,
    requesterAvatar: _$enumDecodeNullable(
        _$AvatarNameEnumMap, json['requesterAvatar'],
        unknownValue: AvatarName.unknown),
    requestMessage: json['requestMessage'] as String,
  );
}

Map<String, dynamic> _$_$_RequestItemModelToJson(
        _$_RequestItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'published': instance.published,
      'creationDate': instance.creationDate?.toIso8601String(),
      'responseCount': instance.responseCount,
      'requesterID': instance.requesterID,
      'requesterAvatar': _$AvatarNameEnumMap[instance.requesterAvatar],
      'requestMessage': instance.requestMessage,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$AvatarNameEnumMap = {
  AvatarName.cat: 'cat',
  AvatarName.fish: 'fish',
  AvatarName.icecream: 'icecream',
  AvatarName.leaf: 'leaf',
  AvatarName.pizza: 'pizza',
  AvatarName.gentle: 'gentle',
  AvatarName.unknown: 'unknown',
};
