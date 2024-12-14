// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hands.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hands _$HandsFromJson(Map<String, dynamic> json) => Hands(
      hands: (json['hands'] as List<dynamic>)
          .map((e) => Hand.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HandsToJson(Hands instance) => <String, dynamic>{
      'hands': instance.hands.map((e) => e.toJson()).toList(),
    };
