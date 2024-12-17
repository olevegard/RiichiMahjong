// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, dead_code

import 'dart:convert';
import 'dart:io';

import 'package:riichi/all_tiles.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/util.dart';

enum SequenceType {
  single,
  pair,
  triplet,
  quad,
  sequence,
  none,
}

class Sequence {
  final int count;
  final TileModel tile;

  Sequence({
    required this.count,
    required this.tile,
  });
}

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
  }

  TileModel getSingle() {
    List<TileModel> tiles = roundTiles..shuffle();
    return tiles.last;
  }

  void addAllTiles() {
    for (int i = 0; i < 4; ++i) {
      roundTiles.add(TileModel.dragon(dragonColor: DragonColor.red));
      roundTiles.add(TileModel.dragon(dragonColor: DragonColor.green));
      roundTiles.add(TileModel.dragon(dragonColor: DragonColor.white));
      roundTiles.add(TileModel.wind(windDirection: WindDirection.east));
      roundTiles.add(TileModel.wind(windDirection: WindDirection.west));
      roundTiles.add(TileModel.wind(windDirection: WindDirection.north));
      roundTiles.add(TileModel.wind(windDirection: WindDirection.south));

      for (int j = 1; j <= 9; ++j) {
        roundTiles.add(TileModel.suited(suit: Suit.characters, number: j, isDora: j == 5 && i == 0));
        roundTiles.add(TileModel.suited(suit: Suit.circles, number: j, isDora: j == 5 && i == 0));
        roundTiles.add(TileModel.suited(suit: Suit.bamboo, number: j, isDora: j == 5 && i == 0));
      }
    }
  }

  void checkHand(int player) {
    print("=========== Player $player ===========");

    doCheckHand(allHands[player]);
  }

  static SequenceType getSequenceType(int first, int second) {
    switch (second - first) {
      case 0:
        return SequenceType.none;
      case 1:
        return SequenceType.single;
      case 2:
        return SequenceType.pair;
      case 3:
        return SequenceType.triplet;
      case 4:
        return SequenceType.quad;
    }

    return SequenceType.none;
  }

  static void doCheckHand(List<TileModel> tiles) {
    Map<String, int> cardCounts = <String, int>{};
    Map<String, List<TileModel>> suitedTiles = <String, List<TileModel>>{};

    bool isAllGreen = true;
    bool isAllTerminal = true;

    final List<Sequence> sequences = <Sequence>[];

    for (int i = 0; i < tiles.length; i++) {
      int j = i + 1;
      for (; j < tiles.length; j++) {
        if (tiles[i].realName == tiles[j].realName) {
          continue;
        } else {
          print("->Not Match @ $j");
          break;
        }
      }

      sequences.add(
        Sequence(
          count: j - i,
          tile: tiles[i],
        ),
      );
      print("${Tiles.getSequenceType(i, j)}");
      i = j - 1;

      if (i == tiles.length - 1) {
        print("Reached end");
        break;
      }
    }

    for (int i = 0; i < sequences.length - 2; ++i) {
      Sequence seq = sequences[i];
      Sequence seq2 = sequences[i + 1];
      Sequence seq3 = sequences[i + 2];
      print("${i.toString().padRight(2)} : ${seq.count} x ${seq.tile.realName.padRight(5)} - " +
          "${seq2.count} x ${seq2.tile.realName.padRight(5)} - " +
          "${seq3.count} x ${seq3.tile.realName.padRight(5)}");


        if (TileModel.isSequence(seq.tile, seq2.tile, seq3.tile)) {
        print("->Sequence x ${MathUtil.min3(seq.count, seq2.count, seq3.count)}!");
        }


    }

    return;
    for (int i = 0; i < tiles.length - 1; /*++i*/) {
      TileModel tile = tiles[i];

      int secondNew = tiles.length;
      int thirdNew = tiles.length;
      // Find next new number
      for (int j = i + 1; j < tiles.length; ++j) {
        print("->Comparing $i ( ${tiles[i].realName} ) and $j ( ${tiles[j].realName} )");

        if (tiles[i].realName == tiles[j].realName) {
          // print("->Match");
          continue;
        } else {
          secondNew = j;
          print("->Not Match @ $j");
        }

        thirdNew = j + 1;
        // Find second new number
        for (int k = j + 1; k < tiles.length; ++k) {
          print("->->Comparing $j ( ${tiles[j].realName} ) and $k ( ${tiles[k].realName} )");
          if (tiles[j].realName == tiles[k].realName) {
            //  print("->->Match");
            continue;
          } else {
            thirdNew = k;
            print("->->Not Match @ $k");
            break;
          }
        }
        print("->Reached end");

        break;
      }

      print("${Tiles.getSequenceType(i, secondNew)}");
      print("${Tiles.getSequenceType(secondNew, thirdNew)}");

      print("Next possible sequence ");
      print("$i ( ${tiles[i].realName} ) ");
      if (secondNew == tiles.length) {
        print("end $secondNew ( ${tiles[secondNew - 1].realName} )");
        print("past end $thirdNew");
      }

      if (thirdNew < tiles.length) {
        print("$thirdNew ( ${tiles[thirdNew].realName} )");
      }

      // print("All equal in range $i -> $secondNew");
      // print("All equal in range $secondNew -> $thirdNew");

      i += (secondNew - i);
      i += (thirdNew - secondNew);

      continue;

      if ((tiles.length - i) > 2) {
        // This will fail if there is more than 1 of the middle number.
        // Ie. 1 2 2 3
        int secondNew = 0;
        int thirdNew = 0;

        for (int j = i + 1; j < tiles.length; j++) {
          if (tiles[i].realName != tiles[j].realName) {
            secondNew = j;
            break;
          }
        }

        for (int j = secondNew + 1; j < tiles.length; j++) {
          if (tiles[secondNew].realName != tiles[j].realName) {
            thirdNew = j;
            break;
          }
        }

        print("Next possible sequence $i, $secondNew, $thirdNew");

        if (TileModel.isSequence(tile, tiles[secondNew], tiles[thirdNew])) {
          print("Found sequence : $i, $secondNew, $thirdNew");
          ++i;
          continue;
        }
        if (TileModel.isTriplet(tile, tiles[i + 1], tiles[i + 2])) {
          print("Found triplet : $i, ${i + 1}, ${i + 2}");
          ++i;
          continue;
        }
        if (TileModel.isPair(tile, tiles[i + 1])) {
          print("Found pair : $i, ${i + 1}");
          continue;
        }
      }

      if ((tiles.length - i) == 2) {
        if (TileModel.isPair(tile, tiles[i + 1])) {
          print("Found pair : $i, ${i + 1}");
        }
      }
      int newCount = 0;

      // print("Hand tile ${asFormattedDecimal(tile.getAsMask())} ( ${tile.getAsMask()} )${tile.realName}  ");
      if (cardCounts.containsKey(tile.realName)) {
        newCount = cardCounts[tile.realName]!;
      }

      if (!tile.isGreen) {
        isAllGreen = false;
      }

      if (!tile.isHonorOrTerminal) {
        isAllTerminal = false;
      }
      if (tile.isSuited) {
        if (!suitedTiles.containsKey(tile.suitNameOrEmpty)) {
          suitedTiles[tile.suitNameOrEmpty] = [tile];
        } else {
          suitedTiles[tile.suitNameOrEmpty]!.add(tile);
        }
      }

      cardCounts[tile.realName] = newCount + 1;
    }

    bool isAllPairs = true;
    cardCounts.forEach((String card, int count) {
      print("$card : $count");

      if (count != 2) {
        isAllPairs = false;
      }
    });
    print("=======================================");

    print("All pairs? $isAllPairs");
    print("All green? $isAllGreen");
    print("All honor? $isAllTerminal");
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
    }
  }

  List<TileModel> createHand() {
    List<TileModel> handTiles = takeN(4);
    return handTiles;
  }
}
