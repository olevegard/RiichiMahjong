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

  const HandWithTilesWrapper({
    super.key,
    required this.tiles,
    required this.onTileTapped,
    required this.width,
    required this.height,
    required this.alignment,
    required this.quarterTurns,
    required this.activePlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: RotatedBox(
        quarterTurns: quarterTurns,
        child: Container(
          alignment: Alignment.center,
          color: activePlayer ? Colors.green : Colors.transparent,
          width: width,
          height: height * 1,
          child: HandWithTiles(
            tiles: tiles,
            onTileTapped: onTileTapped,
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

  const HandWithTiles({
    super.key,
    required this.tiles,
    required this.onTileTapped,
    this.width = PlayerPlayfield.tileWidth,
    this.height = PlayerPlayfield.tileHeight,
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
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: GestureDetector(
                onTap: () {
                  onTileTapped(i);
                },
                child: TileWidget(
                  tile: tiles[i],
                  width: width,
                  height: height,
                ),
              ),
            ),
          /*
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Container(
                width: 60,
                height: 80,
                padding: const EdgeInsets.all(5),
                // color: const Color(0xffff3737),
                color: Colors.black26,
                child: Imag)e.f_ile(
                  File.fromUri(
                    Uri.parse("assets/tiles/${Tiles.getSingle()}.png"),
                  ),
                ),
              ),
            ),
          ),
          */
        ],
      ),
    );
  }
}
