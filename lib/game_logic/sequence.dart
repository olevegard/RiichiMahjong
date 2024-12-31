import 'package:riichi/tile.dart';

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
