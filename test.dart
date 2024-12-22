// ignore_for_file: avoid_print

import 'package:riichi/tile.dart';
import 'package:riichi/tiles.dart';

void main() {
  List<TileModel> allTiles = <TileModel>[];

  for (int i = 0; i < 4; ++i) {
    allTiles.add(TileModel.dragon(dragonColor: DragonColor.red));
    allTiles.add(TileModel.dragon(dragonColor: DragonColor.green));
    allTiles.add(TileModel.dragon(dragonColor: DragonColor.white));
    allTiles.add(TileModel.wind(windDirection: WindDirection.east));
    allTiles.add(TileModel.wind(windDirection: WindDirection.west));
    allTiles.add(TileModel.wind(windDirection: WindDirection.north));
    allTiles.add(TileModel.wind(windDirection: WindDirection.south));

    for (int j = 1; j <= 9; ++j) {
      allTiles.add(TileModel.suited(suit: Suit.characters, number: j, isDora: j == 5 && i == 0));
      allTiles.add(TileModel.suited(suit: Suit.circles, number: j, isDora: j == 5 && i == 0));
      allTiles.add(TileModel.suited(suit: Suit.bamboo, number: j, isDora: j == 5 && i == 0));
    }
  }

  allTiles.shuffle();
  List<TileModel> tiles = [];
  // tiles = allTiles.sublist(0, 13);

  // tiles.sort((TileModel tile1, TileModel tile2) => tile2.getAsMask().toInt() - tile1.getAsMask().toInt());

  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 1,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 1,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 1,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 2,
  ));
tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 2,
  ));



tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 2,
  ));



  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 3,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 3,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 3,
  ));

  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 3,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 4,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 5,
  ));

  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 9,
  ));

/*
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 8,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 8,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 9,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 9,
  ));
  tiles.add(TileModel.suited(
    suit: Suit.characters,
    number: 9,
  ));
  */

  // tiles.add(TileModel.dragon(dragonColor: DragonColor.red));

  for (int i = 0; i < tiles.length; ++i) {
    print("${i + 0} ${tiles[i].realName}");
  }

  Tiles.doCheckHand(tiles);
}
