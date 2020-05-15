// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, non_constant_identifier_names

part of 'letter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LetterModel _$_$_LetterModelFromJson(Map<String, dynamic> json) {
  return _$_LetterModel(
    id: json['id'] as String,
    published: json['published'] as bool,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    requestID: json['requestID'] as String,
    requestMessage: json['requestMessage'] as String,
    requestCreatorID: json['requestCreatorID'] as String,
    requestCreatorAvatar: _$enumDecodeNullable(
        _$AvatarNameEnumMap, json['requestCreatorAvatar'],
        unknownValue: AvatarName.unknown),
    letterSenderID: json['letterSenderID'] as String,
    letterSenderAvatar: _$enumDecodeNullable(
        _$AvatarNameEnumMap, json['letterSenderAvatar'],
        unknownValue: AvatarName.unknown),
    letterMessage: json['letterMessage'] as String,
    recipientID: json['recipientID'] as String,
    reactionTime: json['reactionTime'] == null
        ? null
        : DateTime.parse(json['reactionTime'] as String),
    reactionType: _$enumDecodeNullable(
        _$ReactionTypeEnumMap, json['reactionType'],
        unknownValue: ReactionType.unknown),
  );
}

Map<String, dynamic> _$_$_LetterModelToJson(_$_LetterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'published': instance.published,
      'creationDate': instance.creationDate?.toIso8601String(),
      'requestID': instance.requestID,
      'requestMessage': instance.requestMessage,
      'requestCreatorID': instance.requestCreatorID,
      'requestCreatorAvatar':
          _$AvatarNameEnumMap[instance.requestCreatorAvatar],
      'letterSenderID': instance.letterSenderID,
      'letterSenderAvatar': _$AvatarNameEnumMap[instance.letterSenderAvatar],
      'letterMessage': instance.letterMessage,
      'recipientID': instance.recipientID,
      'reactionTime': instance.reactionTime?.toIso8601String(),
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
