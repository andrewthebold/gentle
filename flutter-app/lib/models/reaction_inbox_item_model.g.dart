// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter, non_constant_identifier_names

part of 'reaction_inbox_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReactionInboxItemModel _$_$_ReactionInboxItemModelFromJson(
    Map<String, dynamic> json) {
  return _$_ReactionInboxItemModel(
    id: json['id'] as String,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    type: _$enumDecodeNullable(_$ReactionTypeEnumMap, json['type'],
        unknownValue: ReactionType.unknown),
    linkedContentID: json['linkedContentID'] as String,
  );
}

Map<String, dynamic> _$_$_ReactionInboxItemModelToJson(
        _$_ReactionInboxItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creationDate': instance.creationDate?.toIso8601String(),
      'type': _$ReactionTypeEnumMap[instance.type],
      'linkedContentID': instance.linkedContentID,
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

const _$ReactionTypeEnumMap = {
  ReactionType.love: 'love',
  ReactionType.inspire: 'inspire',
  ReactionType.thanks: 'thanks',
  ReactionType.unknown: 'unknown',
};
