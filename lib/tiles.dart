// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, dead_code, unused_element

import 'dart:convert';
import 'dart:io';

import 'package:riichi/all_tiles.dart';
import 'package:riichi/game_logic/hand_checker.dart';
import 'package:riichi/game_logic/hand_state.dart';
import 'package:riichi/game_logic/repeat.dart';
import 'package:riichi/hand.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/util/logger.dart';

class Tiles {
  late List<TileModel> roundTiles;
  late Map<String, TileModel> tileTypes = <String, TileModel>{};
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
    String tiles = File.fromUri(Uri.parse("assets/misc/all_tiles.json"))
        .readAsStringSync();

    Map<String, dynamic> data = json.decode(tiles);
    AllTiles allTiles = AllTiles.fromJson(data);
    roundTiles = <TileModel>[];

    for (TileModel tile in allTiles.tiles) {
      for (int i = 0; i < tile.totalCount; ++i) {
        tileTypes[tile.id] = tile;
        roundTiles.add(tile);
      }
    }

    for (TileModel tile in tileTypes.values) {
      print(tile.id);
    }

    //roundTiles.shuffle();
    // _createHands();
    _createHandsTest();
  }

  bool checkHand(int player) {
    Log.trace("=========== Player $player ===========");
    return doCheckHand(allHands[player]);
  }

  bool canPon(int player, int prevPlayer) {
    if (player == prevPlayer) {
      return false;
    }
    TileModel tile = discards[prevPlayer].last;

    List<TileModel> allTiles = [
      ...allHands[player],
      tile,
    ];

    allTiles.sort((TileModel tile1, TileModel tile2) =>
        tile1.getAsMask().toInt() - tile2.getAsMask().toInt());

    bool canPon = checkForPon(allTiles, tile);
    print("Can player $player pon ${tile.realName} : $canPon");

    return canPon;
  }

  static bool checkForPon(List<TileModel> tiles, TileModel tileToPon) {
    List<Repeat> repeats = HandChecker.findRepeats(tiles);
    for (TileModel tile in tiles) {
      print(tile.realName);
    }

    for (Repeat r in repeats) {
      if (r.count > 2) {
        print("Has triplet or quad ${r.tile.realName}");

        if (r.tile.realName == tileToPon.realName) {
          print("->Can pon");
          return true;
        }
      }
    }

    return false;
  }

  static void doAllRepeatsRecursive(
      HandChecker hand,
      Map<String, HandChecker> readyHands,
      Map<String, HandChecker> unReadyHands) {
    if (hand.repeatsAndSequences == 0) {
      if (hand.isReady) {
        readyHands[hand.asShortString] = hand;
      } else {
        unReadyHands[hand.asShortString] = hand;
      }
      return;
    }

    for (int i = 0; i < hand.repeatsAndSequences; ++i) {
      doAllRepeatsRecursive(
          hand.applyRepeatOrSequence(i), readyHands, unReadyHands);
    }
  }

  static bool doCheckHand(List<TileModel> tiles) {
    Groups initialGroups = HandChecker.findAllPossibleGroups(tiles);
    HandChecker initialHand = HandChecker.initial(
      tiles,
      initialGroups.repeats,
      initialGroups.sequences,
    );

    Map<String, HandChecker> readyHands = <String, HandChecker>{};
    Map<String, HandChecker> unReadyHands = <String, HandChecker>{};

    doAllRepeatsRecursive(initialHand, readyHands, unReadyHands);
    // Log.fine("=" * 33 + " Initial hand " + "=" * 33);
    initialHand.printHandFull();
    // Log.fine("=" * 33 + " Ready hands " + "=" * 34);
    for (HandChecker hand in readyHands.values) {
      hand.printHandFull();
    }

    // Log.fine("=" * 33 + " Unready hands " + "=" * 32);
    for (HandChecker hand in unReadyHands.values) {
      // hand.printHandFull();
    }

    return readyHands.isNotEmpty;
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

/*
  HandState updateHandState(int player){
  return HandState(
    canPoon : canPon(player),
    canChi : false,
    canRon : false,
    canKhan : false,
    hasYaku : false,
    canRiichi : false,
    isReady : false,
  );
  }
  */

  void takeNextTile(int player) {
    TileModel newCard = takeN(1).first;
    allHands[player].add(newCard);
    // allHands[player].sort((TileModel tile1, TileModel tile2) => tile2.getAsMask().toInt() - tile1.getAsMask().toInt());
  }

  void discard(int player, int card) {
    discards[player].add(allHands[player][card]);

    allHands[player].removeAt(card);
  }

  void _createHandsTest() {
    // Dealer starts with 13 tiles
    allHands[0].addAll(takeN(1));
    for (int i = 0; i < 4; ++i) {
      allHands[i].addAll(takeN(13));
      allHands[i].sort((TileModel tile1, TileModel tile2) =>
          tile1.getAsMask().toInt() - tile2.getAsMask().toInt());
      allHands[i] = allHands[i].reversed.toList();
    }
  }

  void _createHands() {
    for (int i = 0; i < 12; ++i) {
      allHands[i % 4].addAll(takeN(4));
    }

    for (int i = 0; i < 4; ++i) {
      allHands[i % 4].addAll(takeN(1));
    }

    allHands[0].addAll(takeN(1));

    allHands[0].sort((TileModel tile1, TileModel tile2) =>
        tile1.getAsMask().toInt() - tile2.getAsMask().toInt());
    allHands[0] = allHands[0].reversed.toList();

    for (int i = 0; i < 4; ++i) {
      allHands[i].sort((TileModel tile1, TileModel tile2) =>
          tile1.getAsMask().toInt() - tile2.getAsMask().toInt());
      allHands[i] = allHands[i].reversed.toList();
    }
  }

  List<TileModel> createHand() {
    List<TileModel> handTiles = takeN(4);
    return handTiles;
  }
}
