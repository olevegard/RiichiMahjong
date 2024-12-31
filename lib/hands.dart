import 'package:json_annotation/json_annotation.dart';
import 'package:riichi/hand.dart';

part 'hands.g.dart';

@JsonSerializable(explicitToJson: true)
class Hands {
  final List<Hand> hands;

  Hands({
    required this.hands,
  });

  factory Hands.fromJson(Map<String, dynamic> json) => _$HandsFromJson(json);

  Map<String, dynamic> toJson() => _$HandsToJson(this);
}
