import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riichi/all_tiles.dart';
import 'package:riichi/tile.dart';

class Tiles {
  late List<TileModel> roundTiles;
  final List<List<TileModel>> allHands = <List<TileModel>>[
    <TileModel>[],
    <TileModel>[],
    <TileModel>[],
    <TileModel>[],
  ];

  final List<List<TileModel>> discards = <List<TileModel>>[
    <TileModel>[],
    <TileModel>[],
    <TileModel>[],
    <TileModel>[],
  ];

  Tiles() {
    String tiles = File.fromUri(Uri.parse("assets/misc/all_tiles.json")).readAsStringSync();

    Map<String, dynamic> data = json.decode(tiles);

    AllTiles allTiles = AllTiles.fromJson(data);
    roundTiles = allTiles.tiles;

    roundTiles.shuffle();
    _createHands();

    for (int i = 0; i < 28; ++i) {
      //discard(0, 0);
    }
  }

  TileModel getSingle() {
    List<TileModel> tiles = roundTiles..shuffle();
    return tiles.last;
  }

  List<TileModel> takeN(int count) {
    if (roundTiles.isEmpty) {
      roundTiles.addAll(discards[0]);
      roundTiles.addAll(discards[1]);
      roundTiles.addAll(discards[2]);
      roundTiles.addAll(discards[3]);
    }
    List<TileModel> tiles = roundTiles.take(count).toList();

    roundTiles.removeRange(0, count);
    return tiles;
  }

  bool get canDiscard => roundTiles.isNotEmpty;

  TileModel takeSingle() {
    TileModel tile = roundTiles.first;

    roundTiles.removeAt(0);
    return tile;
  }

  void takeNextTile(int player) {
    TileModel newCard = takeN(1).first;
    allHands[player].add(newCard);
    allHands[player].sort((TileModel tile1, TileModel tile2) => tile1.getAsMask().toInt() - tile2.getAsMask().toInt());
allHands[player] = allHands[player].reversed.toList();
  }


  void discard(int player, int card) {
    discards[player].add(allHands[player][card]);

    allHands[player].removeAt(card);
  }

  void _createHands() {
    for (int i = 0; i < 15 * 4; ++i) {
      // print("${i + 1} - ${roundTiles[i]}");
    }

    for (int i = 0; i < 12; ++i) {
      allHands[i % 4].addAll(takeN(4));
    }

    for (int i = 0; i < 4; ++i) {
      allHands[i % 4].addAll(takeN(1));
    }

    allHands[0].addAll(takeN(1));

    allHands[0].sort((TileModel tile1, TileModel tile2) => tile1.getAsMask().toInt() - tile2.getAsMask().toInt());
    allHands[0] = allHands[0].reversed.toList();

    for (int i = 0; i < 4; ++i) {
      allHands[i].sort((TileModel tile1, TileModel tile2) => tile1.getAsMask().toInt() - tile2.getAsMask().toInt());
      allHands[i] = allHands[i].reversed.toList();

      /*
      hand.sort( (TileModel tile1, TileModel tile2 ) { 
        return tile1.realName.compareTo(tile2.realName);
      } );
      */
    }
  }

  void printAll() {
    for (TileModel s in roundTiles) {
      //print(s);
    }
  }

  void printHands(List<List<TileModel>> allHands) {
    for (int i = 0; i < 4; ++i) {
      print("Player ${i + 1}  tiles: ");
      for (TileModel s in allHands[i]) {
        print("->$s");
      }
    }
  }

  List<TileModel> createHand() {
    List<TileModel> handTiles = takeN(4);
    return handTiles;
  }

/*
  static List<TileModel> get allTiles => [
        for (List<String> tiles in Tiles._specialTiles) ...tiles,
        for (List<String> tiles in Tiles._numberTiles) ...tiles,
      ];

  static List<List<String>> get _specialTiles => [
        <String>[
          "dragon_Chun",
          "dragon_Chun",
          "dragon_Chun",
          "dragon_Chun",
        ],
        <String>[
          "dragon_Haku",
          "dragon_Haku",
          "dragon_Haku",
          "dragon_Haku",
        ],
        <String>[
          "dragon_Hatsu",
          "dragon_Hatsu",
          "dragon_Hatsu",
          "dragon_Hatsu",
        ],
        <String>[
          "wind_Nan",
          "wind_Nan",
          "wind_Nan",
          "wind_Nan",
        ],
        <String>[
          "wind_Pei",
          "wind_Pei",
          "wind_Pei",
          "wind_Pei",
        ],
        <String>[
          "wind_Shaa",
          "wind_Shaa",
          "wind_Shaa",
          "wind_Shaa",
        ],
        <String>[
          "wind_Ton",
          "wind_Ton",
          "wind_Ton",
          "wind_Ton",
        ],
      ];

  static List<List<String>> get _numberTiles => [
        <String>[
          "suit_Man1",
          "suit_Man2",
          "suit_Man3",
          "suit_Man4",
          "suit_Man5",
          "suit_Man6",
          "suit_Man7",
          "suit_Man8",
          "suit_Man9",
        ],
        <String>[
          "suit_Man1",
          "suit_Man2",
          "suit_Man3",
          "suit_Man4",
          "suit_Man5",
          "suit_Man6",
          "suit_Man7",
          "suit_Man8",
          "suit_Man9",
                  ],
        <String>[
          "suit_Man1",
          "suit_Man2",
          "suit_Man3",
          "suit_Man4",
          "suit_Man5",
          "suit_Man6",
          "suit_Man7",
          "suit_Man8",
          "suit_Man9",
        ],
        <String>[
          "suit_Man1",
          "suit_Man2",
          "suit_Man3",
          "suit_Man4",
          "suit_Man5_Dora",
          "suit_Man6",
          "suit_Man7",
          "suit_Man8",
          "suit_Man9",
        ],
        <String>[
          "suit_Pin1",
          "suit_Pin2",
          "suit_Pin3",
          "suit_Pin4",
          "suit_Pin5",
          "suit_Pin6",
          "suit_Pin7",
          "suit_Pin8",
          "suit_Pin9",
        ],
        <String>[
          "suit_Pin1",
          "suit_Pin2",
          "suit_Pin3",
          "suit_Pin4",
          "suit_Pin5",
          "suit_Pin6",
          "suit_Pin7",
          "suit_Pin8",
          "suit_Pin9",
        ],
        <String>[
          "suit_Pin1",
          "suit_Pin2",
          "suit_Pin3",
          "suit_Pin4",
          "suit_Pin5",
          "suit_Pin6",
          "suit_Pin7",
          "suit_Pin8",
          "suit_Pin9",
        ],
        <String>[
          "suit_Pin1",
          "suit_Pin2",
          "suit_Pin3",
          "suit_Pin4",
          "suit_Pin5_Dora",
          "suit_Pin6",
          "suit_Pin7",
          "suit_Pin8",
          "suit_Pin9",
        ],
        <String>[
          "suit_Sou1",
          "suit_Sou2",
          "suit_Sou3",
          "suit_Sou4",
          "suit_Sou5",
          "suit_Sou6",
          "suit_Sou7",
          "suit_Sou8",
          "suit_Sou9",
        ],
        <String>[
          "suit_Sou1",
          "suit_Sou2",
          "suit_Sou3",
          "suit_Sou4",
          "suit_Sou5",
          "suit_Sou6",
          "suit_Sou7",
          "suit_Sou8",
          "suit_Sou9",
        ],
        <String>[
          "suit_Sou1",
          "suit_Sou2",
          "suit_Sou3",
          "suit_Sou4",
          "suit_Sou5",
          "suit_Sou6",
          "suit_Sou7",
          "suit_Sou8",
          "suit_Sou9",
        ],
        <String>[
          "suit_Sou1",
          "suit_Sou2",
          "suit_Sou3",
          "suit_Sou4",
          "suit_Sou5_Dora",
          "suit_Sou6",
          "suit_Sou7",
          "suit_Sou8",
          "suit_Sou9",
        ],
      ];
      */
}
