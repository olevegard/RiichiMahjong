// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, dead_code

import 'dart:convert';
import 'dart:io';

import 'package:riichi/all_tiles.dart';
import 'package:riichi/hand.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/util.dart';

class Groups {
  final List<Repeat> repeats;
  final List<Sequence> sequences;

  Groups(this.repeats, this.sequences);

  void printAll() {
    print("Singles");
    for (Repeat r in repeats) {
      if (r.count == 1) {
        print("${r.indices}  ${r.tile.realName}");
      }
    }

    print("Pairs");
    for (Repeat r in repeats) {
      if (r.count == 2) {
        print("${r.indices}  ${r.tile.realName}");
      }
    }

    print("Triplets + quads");
    for (Repeat r in repeats) {
      if (r.count > 2) {
        print("${r.indices}  ${r.tile.realName}");
      }
    }

    print("Sequences");
    for (Sequence seq in sequences) {
      print("${seq.indices} ${seq.suit.toString().substring(5)} ${seq.startNumber}");
    }
  }
}

class HandData {
  List<Repeat> possibleRepeats = <Repeat>[];
  List<Sequence> possibleSequences = <Sequence>[];

  List<Repeat> appliedRepeats = <Repeat>[];
  List<Sequence> appliedSequences = <Sequence>[];

  List<TileModel> tiles = <TileModel>[];

  HandData.appliedRepeat(
    this.tiles,
    this.possibleRepeats,
    this.appliedRepeats,
    List<Sequence> initialPossibleSequences,
    List<Sequence> initialAppliedSequences,
  ) {
    possibleSequences.addAll(initialPossibleSequences);
    appliedSequences.addAll(initialAppliedSequences);
  }

  HandData.appliedSequence(
    this.tiles,
    this.possibleSequences,
    this.appliedSequences,
    List<Repeat> initialPossibleRepeats,
    List<Repeat> initialAppliedRepeats,
  ) {
    possibleRepeats.addAll(initialPossibleRepeats);
    appliedRepeats.addAll(initialAppliedRepeats);
  }

  HandData.initial(
    List<TileModel> initialTiles,
    List<Repeat> initialRepeats,
    List<Sequence> initialSequences,
  ) {
    tiles.addAll(initialTiles);
    possibleRepeats.addAll(initialRepeats);
    possibleSequences.addAll(initialSequences);
  }

  HandData.deepCopy(
    HandData other,
  ) {
    tiles.addAll(other.tiles);
    possibleRepeats.addAll(other.possibleRepeats);
    possibleSequences.addAll(other.possibleSequences);

    appliedRepeats.addAll(other.appliedRepeats);
    appliedSequences.addAll(other.appliedSequences);
  }

/*
HandData.apply(
    this.tiles,
    this.initialRepeats,
    List<Sequence> initialSequences,
  ) {
    tiles.addAll(initialTiles);
    possibleRepeats.addAll(initialRepeats);
    possibleSequences.addAll(initialSequences);
  }
  */

  int get repeatsWithMoreThanOne {
    int count = 0;
    for (Repeat r in possibleRepeats) {
      if (r.count > 1) {
        ++count;
      }
    }

    return count;
  }

  int get repeatsAndSequences {
    int count = 0;
    for (Repeat r in possibleRepeats) {
      if (r.count > 1) {
        ++count;
      }
    }

    return count + possibleSequences.length;
  }

  bool get isReady => tiles.length == 0;

  HandData applyRepeatOrSequence(int index) {
    int countRepeat = repeatsWithMoreThanOne;

    if (index < countRepeat) {
      return applyRepeat(index);
    }
    if (index < (countRepeat + possibleSequences.length)) {
      return applySequence(index - countRepeat);
    }

    throw "Index out of range";
  }

  HandData applyRepeat(int index) {
    List<Repeat> repeats = possibleRepeats.where((Repeat r) => r.count > 1).toList();
    Repeat r = repeats[index];

    List<TileModel> newTiles = [
      for (int i = 0; i < tiles.length; ++i)
        if (!r.indices.contains(i)) tiles[i]
    ];

    List<Repeat> newPossibleRepeats = [
      for (int i = 0; i < possibleRepeats.length; ++i)
        if (i != index) possibleRepeats[i]
    ];

    List<Repeat> newAppliedRepeats = [
      ...appliedRepeats,
      r,
    ];

    HandData newHand = HandData.appliedRepeat(
      newTiles,
      newPossibleRepeats,
      newAppliedRepeats,
      possibleSequences,
      appliedSequences,
    );

    newHand.calc();

    print(
        "-->Rep $index, ${r.count} x ${r.tile.realName} @ ${r.startIndex}\n---->From : ${asString()}\n---->To   : ${newHand.asString()}");

    return newHand;
  }

  HandData applySequence(int index) {
    // List<Repeat> repeats = possibleRepeats.where((Repeat r) => r.count > 1).toList();
    Sequence s = possibleSequences[index];

    List<TileModel> newTiles = [
      for (int i = 0; i < tiles.length; ++i)
        if (!s.indices.contains(i)) tiles[i]
    ];

    List<Sequence> newPossibleSequences = [
      for (int i = 0; i < possibleSequences.length; ++i)
        if (i != index) possibleSequences[i]
    ];

    List<Sequence> newAppliedSequences = [
      ...appliedSequences,
      s,
    ];

    HandData newHand = HandData.appliedSequence(
      newTiles,
      newPossibleSequences,
      newAppliedSequences,
      possibleRepeats,
      appliedRepeats,
    );

    newHand.calc();

    print("-->Seq $index, ${s.realName} @ ${s.indices}\n---->From : ${asString()}\n---->To   : ${newHand.asString()}");

    return newHand;
  }

  void _applySequence(int index) {
    Sequence s = possibleSequences[index];

    print("Removing sequence of ${s.realName} in ${s.indices}");

    for (int i in s.indices.reversed) {
      tiles.removeAt(i);
    }

    possibleSequences.removeAt(index);
    appliedSequences.add(s);

    calc();
  }

  String asString() {
    String str = "";
    appliedRepeats.sort((Repeat r1, Repeat r2) => (r2.tile.getAsMask() - r1.tile.getAsMask()).toInt());
    for (Repeat r in appliedRepeats) {
      str += "${r.asString} ";
    }

    for (Sequence s in appliedSequences) {
      str += "${s.asString} ";
    }

    for (TileModel t in tiles) {
      str += "${t.realName} ";
    }

    return str;
  }

  String asShortString() {
    String str = "";
    appliedRepeats.sort((Repeat r1, Repeat r2) => (r2.tile.getAsMask() - r1.tile.getAsMask()).toInt());
    for (Repeat r in appliedRepeats) {
      str += "${r.asShortString} ";
    }

    for (Sequence s in appliedSequences) {
      str += "${s.asShortString} ";
    }

    for (TileModel t in tiles) {
      str += "--${t.shortName} ";
    }

    return str.trimRight();
  }

  void printHand() {
    print(asShortString());
  }

  void printHandFull() {
    print(asString());
  }

  static void printRepeats(String heading, int n, List<Repeat> reps) {
    String s = "";
    for (Repeat r in reps) {
      if (r.count == n) {
        s += "->${r.indices}  ${r.tile.realName}\n";
      }
    }

    if (s.isEmpty) {
      return;
    }

    print("$heading groupings of $n\n${s.trimRight()}");
  }

  void printAll() {
    print("Tiles");
    String s = "";

    for (TileModel t in tiles) {
      s += "${t.realName} ";
    }

    print("->$s");

    printRepeats("possible", 1, possibleRepeats);
    printRepeats("possible", 2, possibleRepeats);
    printRepeats("possible", 3, possibleRepeats);
    printRepeats("possible", 4, possibleRepeats);

    print("Possible Sequences");
    for (Sequence seq in possibleSequences) {
      print("->${seq.indices} ${seq.suit.toString().substring(5)} ${seq.startNumber}");
    }

    printRepeats("applied", 1, appliedRepeats);
    printRepeats("applied", 2, appliedRepeats);
    printRepeats("applied", 3, appliedRepeats);
    printRepeats("applied", 4, appliedRepeats);
  }

  static Groups findAllPossibleGroups(List<TileModel> tiles) {
    List<Repeat> repeats = findRepeats(tiles);
    List<Sequence> sequences = findAllSequences(repeats);

    return Groups(repeats, sequences);
  }

  static List<Repeat> findRepeats(List<TileModel> tiles) {
    List<Repeat> repeats = [];
    for (int i = 0; i < tiles.length; i++) {
      int j = i + 1;
      for (; j < tiles.length; j++) {
        if (tiles[i].realName == tiles[j].realName) {
          continue;
        } else {
          break;
        }
      }

      int count = j - i;
      repeats.add(
        Repeat(
          startIndex: i,
          count: count,
          tile: tiles[i],
        ),
      );

      i = j - 1;

      if (i == tiles.length - 1) {
        break;
      }
    }

    return repeats;
  }

  static List<int> calcRepeatsByIndex(List<Repeat> repeats, int n) {
    // How many instances of each number in tiles
    List<int> repeatsByIndex = List<int>.filled(n, 0);
    int padding = 0;
    for (int i = 0; i < repeats.length; ++i) {
      for (int j = 0; j < repeats[i].count; ++j) {
        print("i $i, j $j, p $padding c ${repeats[i].count}");
        repeatsByIndex[i + j + padding] = repeats[i].count;
      }
      padding += (repeats[i].count - 1);
    }

    return repeatsByIndex;
  }

  static List<Sequence> findAllSequences(List<Repeat> repeats) {
    List<Sequence> sequences = [];
    for (int i = 0; i < repeats.length - 2; ++i) {
      Repeat seq1 = repeats[i];
      Repeat seq2 = repeats[i + 1];
      Repeat seq3 = repeats[i + 2];

      if (TileModel.isSequence(seq1.tile, seq2.tile, seq3.tile)) {
        int count = MathUtil.min3(seq1.count, seq2.count, seq3.count).toInt();

        for (int first = 0; first < seq1.count; ++first) {
          for (int mid = 0; mid < seq2.count; ++mid) {
            for (int last = 0; last < seq3.count; ++last) {
              sequences.add(
                Sequence(
                  suit: seq1.tile.suit!,
                  indices: [seq1.startIndex + first, seq2.startIndex + mid, seq3.startIndex + last],
                  startNumber: seq1.tile.number,
                  count: count,
                ),
              );
            }
          }
        }
      }
    }

    return sequences;
  }

  static List<int> findAllPossibleSequencesByIndex(List<Sequence> sequences, int n) {
    List<int> sequencesByIndex = List<int>.filled(n, 0);
    for (Sequence seq in sequences) {
      for (int index in seq.indices) {
        sequencesByIndex[index]++;
      }
      print("Seq ${seq.indices}, ${seq.count} @ ${seq.startNumber}, ${seq.startNumber + 1}, ${seq.startNumber + 2}");
    }

    return sequencesByIndex;
  }

  void removeSequence(int i) {}

  void removeRepeat(int i) {}

  // List<int> repeatByIndex = calcRepeatsByIndex(repeats, tiles.length);
  // List<int> sequencesPerIndex = findAllPossibleSequencesByIndex(sequences, tiles.length);
  void calc() {
    possibleRepeats = HandData.findRepeats(tiles);
    possibleSequences = findAllSequences(possibleRepeats);
  }
}

enum SequenceType {
  single,
  pair,
  triplet,
  quad,
  sequence,
  none,
}

class Repeat {
  final int count;
  final int startIndex;
  final TileModel tile;

  List<int> get indices => <int>[for (int i = 0; i < count; ++i) startIndex + i];

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

class Sequence {
  final int startNumber;
  final List<int> indices;
  final int count;
  final Suit suit;

  String get realName {
    switch (suit) {
      case Suit.bamboo:
        return "Sou $startNumber";
      case Suit.characters:
        return "Man $startNumber";
      case Suit.circles:
        return "Pin $startNumber";
    }
  }

  String get asShortString {
    switch (suit) {
      case Suit.bamboo:
        return "->S$startNumber";
      case Suit.characters:
        return "->M$startNumber";
      case Suit.circles:
        return "->P$startNumber";
    }
  }

  String get asString {
    String s = "";
    switch (suit) {
      case Suit.bamboo:
        s = "Sou";
      case Suit.characters:
        s = "Man";
      case Suit.circles:
        s = "Pin";
    }
    return "( $s $startNumber-${startNumber + 2} )";
  }

  Sequence({
    required this.startNumber,
    required this.indices,
    required this.suit,
    required this.count,
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

  static List<HandData> doAllRepeats(HandData hand) {
    return [
      for (int i = 0; i < hand.repeatsWithMoreThanOne; ++i) hand.applyRepeat(i),
    ];
  }

  static void doAllRepeatsRecursive(HandData hand, List<HandData> allHands, Map<String, HandData> found) {
    if (hand.repeatsAndSequences == 0) {
      print("Added ${hand.asString()}");
      allHands.add(hand);
      found[hand.asShortString()] = hand;
      return;
    }

    // Only one possibility left, add it here to avoid uneccessart computation
    /*
    if (hand.repeatsWithMoreThanOne == 1) {
      print("Added second ot last ${hand.asString()}");
      allHands.add(hand.applyRepeat(0));
      found[hand.asShortString()] = hand;
      return;
    }
    */

    print("New recursive loop, ${allHands.length}");
    for (int i = 0; i < hand.repeatsAndSequences; ++i) {
        doAllRepeatsRecursive(hand.applyRepeatOrSequence(i), allHands, found);
    }
  }

  static void doCheckHand(List<TileModel> tiles) {
    Groups initialGroups = HandData.findAllPossibleGroups(tiles);
    HandData initialHand = HandData.initial(
      tiles,
      initialGroups.repeats,
      initialGroups.sequences,
    );

    print("=" * 33 + " Initial hand " + "=" * 33);
    initialHand.printHandFull();
    print("=" * 80);

/*
    List<HandData> afterFirstPass = doAllRepeats(initialHand);

    for (HandData hand in afterFirstPass) {
      hand.printHand();
    }
    */

    print("Big thing");
    List<HandData> allHands = [];
    Map<String, HandData> hands = <String, HandData>{};

    doAllRepeatsRecursive(initialHand, allHands, hands);
    print("Big thing over, perm count ${allHands.length}");

    initialHand.printHandFull();
    for (HandData hand in hands.values) {
      hand.printHand();
    }

    // List<List<HandData>> allPermutations = [<HandData>[]];
    // allPermutations.add(afterFirstPass);

/*
    possibleSequences.applySequence(1);
    possibleSequences.printHand();

    possibleSequences.applyRepeat(1);
    possibleSequences.printHand();

    possibleSequences.applyRepeat(0);
    possibleSequences.printHand();
    */
    Map<String, int> cardCounts = <String, int>{};
    Map<String, List<TileModel>> suitedTiles = <String, List<TileModel>>{};

    bool isAllGreen = true;
    bool isAllTerminal = true;

    return

        /*
    int removed = 0;
    for (int i in possibleSequences.repeats[1].indices) {
      tiles.removeAt(i - removed);
      ++removed;
    }

    for (TileModel t in tiles) {
      print(t.realName);
    }
    */

        print("=========================================");

    // possibleSequences = HandData(tiles).calc;
    // initialHand.printAll();

    // final List<Repeat> repeats = <Repeat>[];

    // 1 2 3 4 5
    // T T T T P
    // T T T P T
    // T T P T T
    // T P T T T
    // P T T T T

/*
    for (int i = 0; i < repeats.length; ++i) {
      Repeat r = repeats[i];

      print("Repeat ${r.startIndex} - ${r.startIndex + r.count} x ${r.tile.realName}");
    }
    */

    // Make copies of the entire hand and do
    // 1. Find all sequences and repeats
    // 2. Remove one sequenxe ( or repeat if no sequence)
    // 3. If count of remaining tiles == 0 -> Save the removed sequences and repeats as a possible solution
    // 4. Go to 1

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

/*
// How many instances of each number in tiles
    List<int> repeatByIndex = List<int>.filled(tiles.length, 0);
    int padding = 0;
    for (int i = 0; i < repeats.length; ++i) {
      for (int j = 0; j < repeats[i].count; ++j) {
        print("i $i, j $j, p $padding c ${repeats[i].count}");
        repeatByIndex[i + j + padding] = repeats[i].count;
      }
      padding += (repeats[i].count - 1);
    }
    */
