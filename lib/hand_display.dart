import 'package:flutter/material.dart';
import 'package:riichi/hand.dart';
import 'package:riichi/ui/hand.dart';

class HandDisplay extends StatelessWidget {
  final Hand hand;

  const HandDisplay({
    super.key,
    required this.hand,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hand.name),
        Text(hand.description),
        Text("${hand.hanOpen} open, ${hand.hanClosed} closed"),
        HandWithTiles(
          width: 10 * 3,
          height: 10 * 4,
          onTileTapped: (int i) {},
          tiles: hand.tiles,
        ),
      ],
    );
  }
}
