// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TileModel _$TileModelFromJson(Map<String, dynamic> json) => TileModel(
      type: $enumDecode(_$TypeEnumMap, json['type']),
      dragonColor:
          $enumDecodeNullable(_$DragonColorEnumMap, json['dragonColor']),
      windDirection:
          $enumDecodeNullable(_$WindDirectionEnumMap, json['windDirection']),
      suit: $enumDecodeNullable(_$SuitEnumMap, json['suit']),
      number: (json['number'] as num?)?.toInt() ?? 0,
      isDora: json['isDora'] as bool? ?? false,
    );

Map<String, dynamic> _$TileModelToJson(TileModel instance) => <String, dynamic>{
      'type': _$TypeEnumMap[instance.type]!,
      'dragonColor': _$DragonColorEnumMap[instance.dragonColor],
      'windDirection': _$WindDirectionEnumMap[instance.windDirection],
      'suit': _$SuitEnumMap[instance.suit],
      'number': instance.number,
      'isDora': instance.isDora,
    };

const _$TypeEnumMap = {
  Type.Dragon: 'Dragon',
  Type.Suited: 'Suited',
  Type.Wind: 'Wind',
};

const _$DragonColorEnumMap = {
  DragonColor.Green: 'Green',
  DragonColor.Red: 'Red',
  DragonColor.White: 'White',
};

const _$WindDirectionEnumMap = {
  WindDirection.East: 'East',
  WindDirection.South: 'South',
  WindDirection.North: 'North',
  WindDirection.West: 'West',
};

const _$SuitEnumMap = {
  Suit.Bamboo: 'Bamboo',
  Suit.Characters: 'Characters',
  Suit.Circles: 'Circles',
};
