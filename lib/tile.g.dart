// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileModel _$TileModelFromJson(Map<String, dynamic> json) => TileModel(
      type: $enumDecode(_$TypeEnumMap, json['type']),
      dragonColor:
          $enumDecodeNullable(_$DragonColorEnumMap, json['dragon_color']),
      windDirection:
          $enumDecodeNullable(_$WindDirectionEnumMap, json['wind_direction']),
      suit: $enumDecodeNullable(_$SuitEnumMap, json['suit']),
      number: (json['number'] as num?)?.toInt() ?? 0,
      isDora: json['is_dora'] as bool? ?? false,
    );

Map<String, dynamic> _$TileModelToJson(TileModel instance) => <String, dynamic>{
      'type': _$TypeEnumMap[instance.type]!,
      'dragon_color': _$DragonColorEnumMap[instance.dragonColor],
      'wind_direction': _$WindDirectionEnumMap[instance.windDirection],
      'suit': _$SuitEnumMap[instance.suit],
      'number': instance.number,
      'is_dora': instance.isDora,
    };

const _$TypeEnumMap = {
  Type.dragon: 'dragon',
  Type.suited: 'suited',
  Type.wind: 'wind',
};

const _$DragonColorEnumMap = {
  DragonColor.green: 'green',
  DragonColor.red: 'red',
  DragonColor.white: 'white',
};

const _$WindDirectionEnumMap = {
  WindDirection.east: 'east',
  WindDirection.south: 'south',
  WindDirection.north: 'north',
  WindDirection.west: 'west',
};

const _$SuitEnumMap = {
  Suit.bamboo: 'bamboo',
  Suit.characters: 'characters',
  Suit.circles: 'circles',
};
