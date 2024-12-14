import 'package:flutter/material.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/ui/tile.dart';

class PlayerPlayfield extends StatelessWidget {
  final List<TileModel> discardedTiles;
  // final double tileWidth;
  // final double tileHeight;

  // final double width;
  // final double height;
  final Alignment alignment;
  final int quarterTurns;

  const PlayerPlayfield({
    super.key,
    required this.discardedTiles,
    // required this.tileWidth,
    // required this.tileHeight,
    // required this.width,
    // required this.height,
    required this.alignment,
    required this.quarterTurns,
  });

  static const double sidePadding = 20;
  static const double smallTileFactor = 10;
  static const double minTileHeight = 4;
  static const double minTileWidth = 3;
  static const double smallTileWidth = minTileWidth * smallTileFactor;
  static const double smallTileHeight = minTileHeight * smallTileFactor;

  static const double bigTileFactor = 20;
  // static const double tileHeight = 85;
  static const double tileWidth = minTileWidth * bigTileFactor;
  static const double tileHeight = minTileHeight * bigTileFactor;

  static const double leftPadding = 8;
  static const double totalDiscardedTileHeight = (smallTileHeight * 6) + 14;
  static const double width = 1150;
  static const double playFieldWidth = totalDiscardedTileHeight + (smallTileWidth * 10);

  // static double playFieldWidth = width - (tileHeight * 2) - totalDiscardedTileHeight - ( leftPadding * 2);
  @override
  Widget build(BuildContext context) {
  /*
    double playFieldWidth = width;
    // playFieldWidth -= tileHeight * 2;
    playFieldWidth -= smallTileHeight * 2;
    playFieldWidth -= totalDiscardedTileHeight;
    playFieldWidth -= leftPadding * 2;
    playFieldWidth = totalDiscardedTileHeight + (smallTileWidth * 10);
    */

    return Align(
      alignment: alignment,
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Container(
              padding: const EdgeInsets.all(leftPadding),
              color: Colors.black12,
              width: playFieldWidth - leftPadding,
              height: totalDiscardedTileHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DiscardedTilesRow(
                    discardedTiles: discardedTiles,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DiscardedTilesRow extends StatelessWidget {
  final List<TileModel> discardedTiles;

  const DiscardedTilesRow({
    super.key,
    required this.discardedTiles,
  });

  static const double spacing = 2;

  // Set width so that 6 cards fit on each row
  // static const width = ((PlayerPlayfield.smallTileWidth + spacing) * 6) + 8;

  @override
  Widget build(BuildContext context) {
    double width = ((PlayerPlayfield.smallTileWidth + spacing) * 6) + 8;

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(spacing * 2),
        width: width,
        child: Column(
          children: [
            Text(
              "Discards",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (TileModel tile in discardedTiles)
                  TileWidget(
                    tile: tile,
                    width: PlayerPlayfield.smallTileWidth,
                    height: PlayerPlayfield.smallTileHeight,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
