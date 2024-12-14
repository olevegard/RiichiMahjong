// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_tiles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllTiles _$AllTilesFromJson(Map<String, dynamic> json) => AllTiles(
      tiles: (json['tiles'] as List<dynamic>)
          .map((e) => TileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllTilesToJson(AllTiles instance) => <String, dynamic>{
      'tiles': instance.tiles.map((e) => e.toJson()).toList(),
    };
