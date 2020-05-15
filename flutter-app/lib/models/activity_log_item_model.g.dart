// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, non_constant_identifier_names

part of 'activity_log_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ActivityLogItemModel _$_$_ActivityLogItemModelFromJson(
    Map<String, dynamic> json) {
  return _$_ActivityLogItemModel(
    id: json['id'] as String,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    type: _$enumDecodeNullable(_$ActivityLogItemTypeEnumMap, json['type'],
        unknownValue: ActivityLogItemType.unknown),
    linkedContentID: json['linkedContentID'] as String,
    linkedContentCreatorID: json['linkedContentCreatorID'] as String,
    linkedContentAvatar: _$enumDecodeNullable(
        _$AvatarNameEnumMap, json['linkedContentAvatar'],
        unknownValue: AvatarName.unknown),
    linkedContentExcerpt: json['linkedContentExcerpt'] as String,
    reactionType: _$enumDecodeNullable(
        _$ReactionTypeEnumMap, json['reactionType'],
        unknownValue: ReactionType.unknown),
  );
}

Map<String, dynamic> _$_$_ActivityLogItemModelToJson(
        _$_ActivityLogItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creationDate': instance.creationDate?.toIso8601String(),
      'type': _$ActivityLogItemTypeEnumMap[instance.type],
      'linkedContentID': instance.linkedContentID,
      'linkedContentCreatorID': instance.linkedContentCreatorID,
      'linkedContentAvatar': _$AvatarNameEnumMap[instance.linkedContentAvatar],
      'linkedContentExcerpt': instance.linkedContentExcerpt,
      'reactionType': _$ReactionTypeEnumMap[instance.reactionType],
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

const _$ActivityLogItemTypeEnumMap = {
  ActivityLogItemType.sentRequest: 'sentRequest',
  ActivityLogItemType.openedMail: 'openedMail',
  ActivityLogItemType.sentReply: 'sentReply',
  ActivityLogItemType.unknown: 'unknown',
};

const _$AvatarNameEnumMap = {
  AvatarName.cat: 'cat',
  AvatarName.fish: 'fish',
  AvatarName.icecream: 'icecream',
  AvatarName.leaf: 'leaf',
  AvatarName.pizza: 'pizza',
  AvatarName.gentle: 'gentle',
  AvatarName.unknown: 'unknown',
};

const _$ReactionTypeEnumMap = {
  ReactionType.love: 'love',
  ReactionType.inspire: 'inspire',
  ReactionType.thanks: 'thanks',
  ReactionType.unknown: 'unknown',
};
