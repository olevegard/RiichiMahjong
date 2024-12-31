import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'tile.g.dart';

enum Type {
  dragon,
  suited,
  wind,
}

enum DragonColor {
  green,
  red,
  white,
}

enum WindDirection {
  east,
  south,
  north,
  west,
}

enum Suit {
  bamboo,
  characters,
  circles,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TileModel {
  final Type type;
  final DragonColor? dragonColor;
  final WindDirection? windDirection;
  final Suit? suit;
  @JsonKey(defaultValue: 0)
  final int number;
  @JsonKey(defaultValue: false)
  final bool isDora;

  @JsonKey(defaultValue: 4)
  final int totalCount;

  TileModel({
    required this.type,
    required this.dragonColor,
    required this.windDirection,
    required this.suit,
    required this.number,
    required this.isDora,
    required this.totalCount,
  });

  TileModel.dragon({
    required this.dragonColor,
  })  : type = Type.dragon,
        windDirection = null,
        suit = null,
        number = 0,
        totalCount = 4,
        isDora = false;

  TileModel.wind({
    required this.windDirection,
  })  : type = Type.wind,
        dragonColor = null,
        suit = null,
        number = 0,
        totalCount = 4,
        isDora = false;

  TileModel.suited({
    required this.suit,
    required this.number,
    this.isDora = false,
  })  : type = Type.suited,
        windDirection = null,
        // 4 of each except 5, which has 3 regular and 1 dora
        totalCount = number != 5
            ? 4
            : isDora
                ? 1
                : 3,
        dragonColor = null;

  static bool isPair(TileModel first, TileModel other) {
    return first.realName == other.realName;
  }

  static bool isTriplet(TileModel first, TileModel second, TileModel third) {
    return first.realName == second.realName &&
        second.realName == third.realName;
  }

  static bool isSequence(TileModel first, TileModel second, TileModel third) {
// Make sure it's actually a suit
    if (first.type != Type.suited ||
        second.type != Type.suited ||
        third.type != Type.suited) {
      return false;
    }

// Make sure it's the same suit
    if (first.suit != second.suit || second.suit != third.suit) {
      return false;
    }

    // For any 3 sequential digits, the distance between them will always be 1,2,1 ( absolute value)
    // Lowest number is 2 smaller than the largest
    // Lowest number is 1 smaller than the middle
    // Highest number is 1 larger than the middle
    int diff1 = (first.number - second.number).abs();
    int diff2 = (first.number - third.number).abs();
    int diff3 = (second.number - third.number).abs();

    if (diff1 == 2) {
      return diff2 == 1 && diff3 == 1;
    }

    if (diff2 == 2) {
      return diff1 == 1 && diff3 == 1;
    }

    if (diff3 == 2) {
      return diff1 == 1 && diff2 == 1;
    }

    return false;
  }

  static getIsPartOfSequence(TileModel first, TileModel other) {
    if (first.type != Type.suited || other.type != Type.suited) {
      return false;
    }
    if (first.suit != other.suit) {
      return false;
    }

    return ((first.number - other.number).abs()) == 1;
  }

  num getAsMask() {
    // D = Dragon
    // r = red
    // g = green
    // w = white
    // W = Wind
    // S = Suit
    //  Drgw Wesn w--- Sbcs 1234 5678 9--- d---
    //  1100 0000 0000 0000 0000 0000 0000 0000
    num dragon = pow(2, 31);

    num redDragon = dragon + pow(2, 30);
    num greenDragon = dragon + pow(2, 29);
    num whiteDragon = dragon + pow(2, 28);

    num wind = pow(2, 27);
    num east = wind + pow(2, 26);
    num south = wind + pow(2, 25);
    num north = wind + pow(2, 24);
    num west = wind + pow(2, 23);

    num suited = pow(2, 19);
    num bamboo = suited + pow(2, 18);
    num characters = suited + pow(2, 17);
    num circles = suited + pow(2, 16);

    switch (type) {
      case Type.dragon:
        switch (dragonColor) {
          case DragonColor.green:
            return greenDragon;
          case DragonColor.red:
            return redDragon;
          case DragonColor.white:
            return whiteDragon;
          case null:
            return 0;
        }
      case Type.wind:
        switch (windDirection) {
          case WindDirection.east:
            return east;
          case WindDirection.south:
            return south;
          case WindDirection.north:
            return north;
          case WindDirection.west:
            return west;
          case null:
            return 0;
        }
      case Type.suited:
        num numberAsMask = pow(2, (16 - number));
        if (isDora) {
          numberAsMask += pow(2, 4);
        }
        switch (suit) {
          case Suit.bamboo:
            // 1 == 2 ^ 15
            // 2 == 2 ^ 14
            // ...
            // 9 == 2 ^ 7

            return bamboo + numberAsMask;
          case Suit.characters:
            return characters + numberAsMask;
          case Suit.circles:
            return circles + numberAsMask;

          case null:
            return 0;
        }
    }
  }

  bool get isTerminal => type == Type.suited && (number == 1 || number == 2);

  bool get isHonorTile => type == Type.dragon || type == Type.wind;

  bool get isHonorOrTerminal => isHonorTile || isTerminal;

  bool get isSuited => type == Type.suited;
  String get suitNameOrEmpty =>
      type == Type.suited && suit != null ? suit.toString() : "";
  bool get isDragon => type == Type.dragon;
  bool get isGreen {
    switch (type) {
      case Type.dragon:
        return dragonColor == DragonColor.green;
      case Type.suited:
        if (suit != Suit.bamboo) {
          return false;
        }

        if (isDora) {
          return false;
        }

        return number == 2 || number == 3 || number == 4 || number == 6 || number == 8;
      case Type.wind:
        return false;
    }
  }

String get shortName {
    switch (type) {
      case Type.dragon:
        switch (dragonColor) {
          case DragonColor.green:
            return "Ha";
          case DragonColor.red:
            return "Ch";
          case DragonColor.white:
            return "Ha";
          case null:
            return "";
        }

      case Type.suited:
        switch (suit) {
          case Suit.bamboo:
            return "S$number";
          case Suit.characters:
            return "M$number";
          case Suit.circles:
            return "P$number";
          case null:
            return "";
        }
      case Type.wind:
        switch (windDirection) {
          case WindDirection.east:
            return "To";
          case WindDirection.south:
            return "Na";
          case WindDirection.north:
            return "Pe";
          case WindDirection.west:
            return "Sh";
          case null:
            return "";
        }
    }
  }

  String get realName {
    switch (type) {
      case Type.dragon:
        switch (dragonColor) {
          case DragonColor.green:
            return "Hatsu";
          case DragonColor.red:
            return "Chun";
          case DragonColor.white:
            return "Haku";
          case null:
            return "";
        }

      case Type.suited:
        switch (suit) {
          case Suit.bamboo:
            return "Sou$number";
          case Suit.characters:
            return "Man$number";
          case Suit.circles:
            return "Pin$number";
          case null:
            return "";
        }
      case Type.wind:
        switch (windDirection) {
          case WindDirection.east:
            return "Ton";
          case WindDirection.south:
            return "Nan";
          case WindDirection.north:
            return "Pei";
          case WindDirection.west:
            return "Shaa";
          case null:
            return "";
        }
    }
  }

  String get path {
    switch (type) {
      case Type.dragon:
        return "dragon_$realName.png";
      case Type.wind:
        return "wind_$realName.png";
      case Type.suited:
        return "suit_$realName${isDora ? "_Dora" : ""}.png";
    }
  }

  factory TileModel.fromJson(Map<String, dynamic> json) => _$TileModelFromJson(json);

  Map<String, dynamic> toJson() => _$TileModelToJson(this);
}
