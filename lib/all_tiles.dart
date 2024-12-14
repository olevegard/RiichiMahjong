import 'package:json_annotation/json_annotation.dart';
import 'package:riichi/tile.dart';

part 'all_tiles.g.dart';

@JsonSerializable(explicitToJson: true)
class AllTiles {
  final List<TileModel> tiles;

  AllTiles({
    required this.tiles,
  });

   factory AllTiles.fromJson(Map<String, dynamic> json) => _$AllTilesFromJson(json);

  Map<String, dynamic> toJson() => _$AllTilesToJson(this);
}
