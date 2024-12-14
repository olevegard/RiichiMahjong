// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hand _$HandFromJson(Map<String, dynamic> json) => Hand(
      name: json['name'] as String,
      description: json['description'] as String,
      hanOpen: (json['hanOpen'] as num).toInt(),
      hanClosed: (json['hanClosed'] as num).toInt(),
      tiles: (json['tiles'] as List<dynamic>)
          .map((e) => TileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HandToJson(Hand instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'hanOpen': instance.hanOpen,
      'hanClosed': instance.hanClosed,
      'tiles': instance.tiles,
    };
