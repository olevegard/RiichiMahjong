import 'package:json_annotation/json_annotation.dart';
import 'package:riichi/tile.dart';

part 'hand.g.dart';

@JsonSerializable()
class Hand {
  final String name;
  final String description;
  final int hanOpen;
  final int hanClosed;
  final List<TileModel> tiles;

  Hand({
    required this.name,
    required this.description,
    required this.hanOpen,
    required this.hanClosed,
    required this.tiles,
  });

  factory Hand.fromJson(Map<String, dynamic> json) => _$HandFromJson(json);

  Map<String, dynamic> toJson() => _$HandToJson(this);
}
