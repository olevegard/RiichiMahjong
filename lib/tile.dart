import 'dart:ffi';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'tile.g.dart';

enum Type {
  Dragon,
  Suited,
  Wind,
}

enum DragonColor {
  Green,
  Red,
  White,
}

enum WindDirection {
  East,
  South,
  North,
  West,
}

enum Suit {
  Bamboo,
  Characters,
  Circles,
}

@JsonSerializable()
class TileModel {
  final Type type;
  final DragonColor? dragonColor;
  final WindDirection? windDirection;
  final Suit? suit;
  @JsonKey(defaultValue: 0)
  final int number;
  @JsonKey(defaultValue: false)
  final bool isDora;

  TileModel({
    required this.type,
    required this.dragonColor,
    required this.windDirection,
    required this.suit,
    required this.number,
    required this.isDora,
  });

  TileModel.dragon({
    required this.dragonColor,
  })  : type = Type.Dragon,
        windDirection = null,
        suit = null,
        number = 0,
        isDora = false;

  TileModel.wind({
    required this.windDirection,
  })  : type = Type.Wind,
        dragonColor = null,
        suit = null,
        number = 0,
        isDora = false;

  TileModel.suited({
    required this.suit,
    required this.number,
    required this.isDora,
  })  : type = Type.Suited,
        windDirection = null,
        dragonColor = null;

  num getAsMask() {
    //  Drg r, g, w, Wnd E, S, N W Suit B ch Ci dora 0 1 2 3 4 5 6 7 8 9 green
    //   1  1  0   0  0  0  0  0 0  0   0  0  0  0   0 1 2 3 4 5 6 7 8 9  0
    //   1  0  1   0  0  0  0  0 0  0   0  0  0  0                        1
    //   0  0  0   0  0  0  0  0 0  0   1  0  0  0    0 0 1 0 0 0 0 0 0 0 01

    //   0011 0000 0000 0000 0123 4567 890

    //   0000  0000 0010  0000 1000 0000 01

    //  Drgw WESN WSBM S123 4567 89d
    //  1100 0000 0000 0000 0000 000

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

//   num num1 = pow(2, 15);
//   num num2 = pow(2, 14);
//   num num3 = pow(2, 13);
//   num num4 = pow(2, 12);
//
//   num num5 = pow(2, 11);
//   num num6 = pow(2, 10);
//   num num7 = pow(2, 9);
//   num num8 = pow(2, 8);
//
//   num num9 = pow(2, 7);
//   num dora = pow(2, 4);

    // Dragons - 0001 0000
    // Red 0001 1000
    // Green 0001 0100
    // Blue 0001 0010
    switch (type) {
      case Type.Dragon:
        // 0001 1000
        switch (dragonColor) {
          case DragonColor.Green:
            return greenDragon;
          // 0001 1000
          // mask |= 8;
          case DragonColor.Red:
            return redDragon;
          // 0001 0100
          case DragonColor.White:
            return whiteDragon;
          case null:
            return 0;
        }
      case Type.Wind:
        switch (windDirection) {
          case WindDirection.East:
            return east;
          case WindDirection.South:
            return south;
          case WindDirection.North:
            return north;
          case WindDirection.West:
            return west;
          case null:
            return 0;
        }
      case Type.Suited:
        num numberAsMask = pow(2, (16 - number));
        if (isDora) {
          numberAsMask += pow(2, 4);
        }
        switch (suit) {
          case Suit.Bamboo:
            // 1 == 2 ^ 15
            // 2 == 2 ^ 14
            // ...
            // 9 == 2 ^ 7

            return bamboo + numberAsMask;
          case Suit.Characters:
            return characters + numberAsMask;
          // TODO: Handle this case.
          case Suit.Circles:
            return circles + numberAsMask;
          // TODO: Handle this case.

          case null:
            return 0;
        }
    }
  }

  bool get isTerminal => type == Type.Suited && (number == 1 || number == 2);

  bool get isHonorTile => type == Type.Dragon || type == Type.Wind;

  bool get isHonorOrTerminal => isHonorTile || isTerminal;

  bool get isSuited => type == Type.Suited;
  String get suitNameOrEmpty => type == Type.Suited && suit != null ? suit.toString() : "";
  bool get isDragon => type == Type.Dragon;
  bool get isGreen {
    switch (type) {
      case Type.Dragon:
        return dragonColor == DragonColor.Green;
      case Type.Suited:
        if (suit != Suit.Bamboo) {
          return false;
        }

        if (isDora) {
          return false;
        }

        return number == 2 || number == 3 || number == 4 || number == 6 || number == 8;
      case Type.Wind:
        return false;
    }

    if (type != Type.Dragon && type != Type.Suited) {
      return false;
    }

    if (type == Type.Dragon && type != Type.Suited) {
      return false;
    }
    // (type == (Type.Dragon && dragonColor == DragonColor.Green);
    return false;
  }

  String get realName {
    switch (type) {
      case Type.Dragon:
        switch (dragonColor) {
          case DragonColor.Green:
            return "Hatsu";
          case DragonColor.Red:
            return "Chun";
          case DragonColor.White:
            return "Haku";
          case null:
            return "";
        }

      case Type.Suited:
        switch (suit) {
          case Suit.Bamboo:
            return "Sou$number";
          case Suit.Characters:
            return "Man$number";
          case Suit.Circles:
            return "Pin$number";
          case null:
            return "";
        }
      case Type.Wind:
        switch (windDirection) {
          case WindDirection.East:
            return "Ton";
          case WindDirection.South:
            return "Nan";
          case WindDirection.North:
            return "Pei";
          case WindDirection.West:
            return "Shaa";
          case null:
            return "";
        }
    }
  }

  String get path {
    switch (type) {
      case Type.Dragon:
        return "dragon_$realName.png";
      case Type.Wind:
        return "wind_$realName.png";
      case Type.Suited:
        return "suit_$realName${isDora ? "_Dora" : ""}.png";
    }
  }

  factory TileModel.fromJson(Map<String, dynamic> json) => _$TileModelFromJson(json);

  Map<String, dynamic> toJson() => _$TileModelToJson(this);
}
