import 'package:flutter_test/flutter_test.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/tiles.dart';

void main() {
  test('Counter increments smoke test', () async {
    expect(0, 1);

    Tiles tiles = Tiles();

    for (TileModel t in tiles.allHands[0]) {
      print(t.realName);
    }
    print("");

    // checkHand(0);
  });
}
