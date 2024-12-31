import 'package:flutter/material.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/ui/discarded_tiles_row.dart';
import 'package:riichi/ui/tile.dart';

typedef TileTappedCallback = void Function(int tileIndex);

class HandWithTilesWrapper extends StatelessWidget {
  final double width;
  final double height;
  final TileTappedCallback onTileTapped;
  final List<TileModel> tiles;
  final Alignment alignment;
  final int quarterTurns;
  final bool activePlayer;
  final bool tilesVisible;

  const HandWithTilesWrapper({
    super.key,
    required this.tiles,
    required this.onTileTapped,
    required this.width,
    required this.height,
    required this.alignment,
    required this.quarterTurns,
    required this.activePlayer,
    required this.tilesVisible,
  });

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      child: Align(
        alignment: alignment,
        child: RotatedBox(
          quarterTurns: quarterTurns,
          child: Container(
            alignment: Alignment.center,
            color: activePlayer
                ? Colors.green
                : Colors.green.withValues(alpha: 0.3),
            width: width,
            height: height * 1,
            child: HandWithTiles(
              tiles: tiles,
              isVisible: tilesVisible,
              onTileTapped: onTileTapped,
            ),
          ),
        ),
      ),
    );
  }
}

class HandWithTiles extends StatelessWidget {
  final TileTappedCallback onTileTapped;
  final List<TileModel> tiles;
  final double width;
  final double height;
  final bool isVisible;

  const HandWithTiles({
    super.key,
    required this.tiles,
    required this.onTileTapped,
    this.width = PlayerPlayfield.tileWidth,
    this.height = PlayerPlayfield.tileHeight,
    required this.isVisible,
  });
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      // color: Colors.black26,
      color: Colors.transparent,
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          for (int i = 0; i < tiles.length; ++i)
            Padding(
              padding: i < 13
                  ? const EdgeInsets.symmetric(
                      horizontal: 2,
                    )
                  : const EdgeInsets.only(
                      left: 16,
                    ),
              child: GestureDetector(
                  onTap: () {
                    onTileTapped(i);
                  },
                  child: TileWidget(
                    tile: tiles[i],
                    width: width,
                    height: height,
                    isVisible: isVisible,
                  )),
            ),
        ],
      ),
    );
  }
}
