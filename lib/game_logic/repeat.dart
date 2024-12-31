import 'package:riichi/tile.dart';

class Repeat {
  final int count;
  final int startIndex;
  final TileModel tile;

  List<int> get indices =>
      <int>[for (int i = 0; i < count; ++i) startIndex + i];

  String get asString {
    return "( $count x ${tile.realName} ) ";
  }

  String get asShortString {
    return "${count}x${tile.shortName}";
  }

  Repeat({
    required this.count,
    required this.startIndex,
    required this.tile,
  });
}
