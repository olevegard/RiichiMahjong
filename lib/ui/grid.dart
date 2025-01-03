import 'package:flutter/material.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/tiles.dart';
import 'package:riichi/ui/discarded_tiles_row.dart';
import 'package:riichi/ui/hand.dart';

class Grid extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  Tiles tiles = Tiles();

  Grid({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  List<List<TileModel>> allHands = [];
  List<List<TileModel>> allDiscards = [];

  int activePlayer = 0;

  String asFormattedDecimal(num n) {
    String s = n.toInt().toRadixString(2).padRight(32, "0");

    StringBuffer sb = StringBuffer();
    for (int i = 0; i < 28; i += 4) {
      sb.write(s.substring(i, i + 4));
      sb.write("-");
    }

    return sb.toString().substring(0, 34);
  }

  @override
  void initState() {
    super.initState();
    allHands = widget.tiles.allHands;
    allDiscards = widget.tiles.discards;
  }

  void discard(int player, int tile) {
    if (player != activePlayer || !widget.tiles.canDiscard) {
      return;
    }

    print("Player $player discarded $tile ${widget.tiles.allHands[player][tile].realName}");

    widget.tiles.discard(player, tile);

    int prevPlayer = activePlayer;
    activePlayer++;

    if (activePlayer > 3) {
      activePlayer = 0;
    }

    bool canAnyonePon = false;
    for (int i = 0; i < 4; ++i) {
      if (i == prevPlayer) {
        continue;
      }

      if (widget.tiles.canPon(i, prevPlayer)) {
        canAnyonePon = true;
      }
    }

    if (!canAnyonePon) {
      widget.tiles.takeNextTile(activePlayer);
    }

    setState(() {
      allDiscards[prevPlayer] = widget.tiles.discards[prevPlayer];
      allHands[player] = widget.tiles.allHands[player];
    });
  }

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    checked = false;

    double tileAreaWidth = 15 * (PlayerPlayfield.tileWidth + 4) + 8;
    double tileAreaHeight = PlayerPlayfield.tileHeight + 16;
    double playAreaSize = PlayerPlayfield.width - (PlayerPlayfield.width - tileAreaWidth);

    asFormattedDecimal(12312311234);
    return Container(
      width: widget.screenWidth,
      height: widget.screenHeight,
      color: Colors.white,
      child: Stack(
        children: [
          HandWithTilesWrapper(
            quarterTurns: 0,
            tilesVisible: true,
            activePlayer: activePlayer == 0,
            alignment: Alignment.bottomCenter,
            onTileTapped: (int i) {
              discard(0, i);
            },
            tiles: allHands[0],
            width: tileAreaWidth,
            height: tileAreaHeight,
          ),

          HandWithTilesWrapper(
            quarterTurns: 3,
            tilesVisible: true,
            // tilesVisible: false,
            activePlayer: activePlayer == 1,
            alignment: Alignment.centerRight,
            onTileTapped: (int i) {
              discard(1, i);
            },
            tiles: allHands[1],
            width: tileAreaWidth,
            height: tileAreaHeight,
            // width: screenWidth - (PlayerPlayfield.sidePadding * 2),
            // height: PlayerPlayfield.tileHeight + 2,
          ),
          HandWithTilesWrapper(
            tilesVisible: true,
            // tilesVisible: false,
            quarterTurns: 2,
            activePlayer: activePlayer == 2,
            alignment: Alignment.topCenter,
            onTileTapped: (int i) {
              discard(2, i);
            },
            tiles: allHands[2],
            width: tileAreaWidth,
            height: tileAreaHeight,
          ),

          HandWithTilesWrapper(
            quarterTurns: 1,
            activePlayer: activePlayer == 3,
            tilesVisible: true,
            // tilesVisible: false,
            alignment: Alignment.centerLeft,
            onTileTapped: (int i) {
              discard(3, i);
            },
            tiles: allHands[3],

            width: tileAreaWidth,
            height: tileAreaHeight,
          ),

          // Playfield
          Align(
            alignment: Alignment.center,
            child: Container(
              color: Colors.red.withOpacity(0.2),
              width: playAreaSize,
              height: playAreaSize,
              // width: screenWidth - (tileAreaHeight  * 2)  - 4,
              // height: screenWidth - (tileAreaHeight * 2) - 4,
              child: Stack(
                children: [
                  PlayerPlayfield(
                    discardedTiles: allDiscards[0],
                    quarterTurns: 0,
                    alignment: Alignment.bottomRight,
                    // tileHeight: tileHeight,
                    // width: screenWidth,
                  ),
                  PlayerPlayfield(
                    discardedTiles: allDiscards[1],
                    quarterTurns: 3,
                    alignment: Alignment.topRight,
                    // tileHeight: tileHeight,
                    // width: screenWidth,
                  ),
                  PlayerPlayfield(
                    discardedTiles: allDiscards[2],
                    quarterTurns: 2,
                    alignment: Alignment.topLeft,
                    // tileHeight: tileHeight,
                    // width: screenWidth,
                  ),
                  PlayerPlayfield(
                    discardedTiles: allDiscards[3],
                    quarterTurns: 1,
                    alignment: Alignment.bottomLeft,
                    // tileHeight: tileHeight,
                    // width: screenWidth,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: playAreaSize - (PlayerPlayfield.playFieldWidth + 32),
                        height: playAreaSize - (PlayerPlayfield.playFieldWidth + 32),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                MaterialButton(
                                  minWidth: 0,
                                  child: Text("Pon"),
                                  onPressed: null, //() {},
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  child: Text("Chi"),
                                  onPressed: () {},
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  child: Text("Kong"),
                                  onPressed: () {},
                                ),
                                MaterialButton(
                                  minWidth: 0,
                                  child: Text("RON"),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
