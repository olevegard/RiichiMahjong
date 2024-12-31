import 'package:riichi/game_logic/repeat.dart';
import 'package:riichi/game_logic/sequence.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/util.dart';
import 'package:riichi/util/logger.dart';

class Groups {
  final List<Repeat> repeats;
  final List<Sequence> sequences;

  Groups(this.repeats, this.sequences);
}

class HandChecker {
  List<Repeat> possibleRepeats = <Repeat>[];
  List<Sequence> possibleSequences = <Sequence>[];

  List<Repeat> appliedRepeats = <Repeat>[];
  List<Sequence> appliedSequences = <Sequence>[];

  List<TileModel> tiles = <TileModel>[];

  HandChecker.appliedRepeat(
    this.tiles,
    this.possibleRepeats,
    this.appliedRepeats,
    List<Sequence> initialPossibleSequences,
    List<Sequence> initialAppliedSequences,
  ) {
    possibleSequences.addAll(initialPossibleSequences);
    appliedSequences.addAll(initialAppliedSequences);
  }

  HandChecker.appliedSequence(
    this.tiles,
    this.possibleSequences,
    this.appliedSequences,
    List<Repeat> initialPossibleRepeats,
    List<Repeat> initialAppliedRepeats,
  ) {
    possibleRepeats.addAll(initialPossibleRepeats);
    appliedRepeats.addAll(initialAppliedRepeats);
  }

  HandChecker.initial(
    List<TileModel> initialTiles,
    List<Repeat> initialRepeats,
    List<Sequence> initialSequences,
  ) {
    tiles.addAll(initialTiles);
    possibleRepeats.addAll(initialRepeats);
    possibleSequences.addAll(initialSequences);
  }

  bool get isReady {
    if (tiles.isNotEmpty) {
      Log.debug("Not ready : Some tile remain : ${this.asShortString}");
      return false;
    }

    int pairCount = appliedRepeats.where((Repeat r) => r.count == 2).length;
    if (pairCount != 1) {
      Log.debug(
          "Not ready : Incorrect pair count $pairCount : ${this.asShortString}");
      return false;
    }

    Log.debug("Ready : $pairCount : ${this.asShortString}");

    return true;
  }

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
    return repeatsWithMoreThanOne + possibleSequences.length;
  }

  HandChecker applyRepeatOrSequence(int index) {
    int countRepeat = repeatsWithMoreThanOne;

    if (index < countRepeat) {
      return applyRepeat(index);
    }
    if (index < (countRepeat + possibleSequences.length)) {
      return applySequence(index - countRepeat);
    }

    throw "Index out of range";
  }

  HandChecker applyRepeat(int index) {
    List<Repeat> repeats =
        possibleRepeats.where((Repeat r) => r.count > 1).toList();
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

    HandChecker newHand = HandChecker.appliedRepeat(
      newTiles,
      newPossibleRepeats,
      newAppliedRepeats,
      possibleSequences,
      appliedSequences,
    );

    newHand.calc();

    Log.debug(
        "-->Rep $index, ${r.count} x ${r.tile.realName} @ ${r.startIndex}\n---->From : ${asString}\n---->To   : ${newHand.asString}");

    return newHand;
  }

  HandChecker applySequence(int index) {
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

    HandChecker newHand = HandChecker.appliedSequence(
      newTiles,
      newPossibleSequences,
      newAppliedSequences,
      possibleRepeats,
      appliedRepeats,
    );

    newHand.calc();

    Log.debug(
        "-->Seq $index, ${s.realName} @ ${s.indices}\n---->From : ${asString}\n---->To   : ${newHand.asString}");

    return newHand;
  }

  String get asString {
    String str = "";
    appliedRepeats.sort((Repeat r1, Repeat r2) =>
        (r2.tile.getAsMask() - r1.tile.getAsMask()).toInt());
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

  String get asShortString {
    String str = "";
    appliedRepeats.sort((Repeat r1, Repeat r2) =>
        (r2.tile.getAsMask() - r1.tile.getAsMask()).toInt());
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
    Log.info(asShortString);
  }

  void printHandFull() {
    Log.info(asString);
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
                  indices: [
                    seq1.startIndex + first,
                    seq2.startIndex + mid,
                    seq3.startIndex + last
                  ],
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

  static List<int> _calcRepeatsByIndex(List<Repeat> repeats, int n) {
    // How many instances of each number in tiles
    List<int> repeatsByIndex = List<int>.filled(n, 0);
    int padding = 0;
    for (int i = 0; i < repeats.length; ++i) {
      for (int j = 0; j < repeats[i].count; ++j) {
        Log.trace("i $i, j $j, p $padding c ${repeats[i].count}");
        repeatsByIndex[i + j + padding] = repeats[i].count;
      }
      padding += (repeats[i].count - 1);
    }

    return repeatsByIndex;
  }

  static List<int> _findAllPossibleSequencesByIndex(
      List<Sequence> sequences, int n) {
    List<int> sequencesByIndex = List<int>.filled(n, 0);
    for (Sequence seq in sequences) {
      for (int index in seq.indices) {
        sequencesByIndex[index]++;
      }
      Log.trace(
          "Seq ${seq.indices}, ${seq.count} @ ${seq.startNumber}, ${seq.startNumber + 1}, ${seq.startNumber + 2}");
    }

    return sequencesByIndex;
  }

  void calc() {
    possibleRepeats = HandChecker.findRepeats(tiles);
    possibleSequences = findAllSequences(possibleRepeats);
  }
}
