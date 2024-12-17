import 'package:flutter/material.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/tiles.dart';
import 'package:riichi/ui/discarded_tiles_row.dart';
import 'package:riichi/ui/hand.dart';

class Grid extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  Tiles tiles = Tiles();

  // final double tileHeight;
  // final double sidePadding;

  Grid({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    // required this.tileHeight,
    // required this.sidePadding,
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

    widget.tiles.discard(player, tile);
    checkHand(player);

    int prevPlayer = activePlayer;
    activePlayer++;

    if (activePlayer > 3) {
      activePlayer = 0;
    }
    widget.tiles.takeNextTile(activePlayer);

    setState(() {
      allDiscards[prevPlayer] = widget.tiles.discards[prevPlayer];
      allHands[player] = widget.tiles.allHands[player];
    });
  }

  @override
  Widget build(BuildContext context) {
    // double smallTileFactor = 12;
    // double smallTileFactor = 10;
    // double smallTileWidth = 3 * smallTileFactor;
    // double smallTileHeight = 4 * smallTileFactor;

    // double totalDiscardedTileHeight = smallTileHeight * 6;

    // double playFieldWidth = (screenWidth - (tileHeight * 2)) / 2;
    //double playFieldWidth = screenWidth;
    //playFieldWidth -= tileHeight * 2;
    //playFieldWidth -= totalDiscardedTileHeight;
    //// playFieldWidth += 6 * smallTileWidth;

    double tileAreaWidth = 14 * (PlayerPlayfield.tileWidth + 4) + 32;
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
            quarterTurns: 2,
            activePlayer: activePlayer == 0,
            alignment: Alignment.topCenter,
            onTileTapped: (int i) {
              discard(0, i);
            },
            tiles: allHands[0],
            width: tileAreaWidth,
            height: tileAreaHeight,
            // screenWidth - (PlayerPlayfield.sidePadding * 2),
          ),

          HandWithTilesWrapper(
            quarterTurns: 3,
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
            quarterTurns: 0,
            activePlayer: activePlayer == 2,
            alignment: Alignment.bottomCenter,
            onTileTapped: (int i) {
              discard(2, i);
            },
            tiles: allHands[2],

            width: tileAreaWidth,
            height: tileAreaHeight,
            // width: screenWidth - (PlayerPlayfield.sidePadding * 2),
            // height: PlayerPlayfield.tileHeight + 2,
          ),
          HandWithTilesWrapper(
            quarterTurns: 1,
            activePlayer: activePlayer == 3,
            alignment: Alignment.centerLeft,
            onTileTapped: (int i) {
              discard(3, i);
            },
            tiles: allHands[3],

            width: tileAreaWidth,
            height: tileAreaHeight,
            // width: screenWidth - (PlayerPlayfield.sidePadding * 2),
            // height: PlayerPlayfield.tileHeight + 2,
          ),

          // Playfield
          Align(
            alignment: Alignment.center,
            child: Container(
              color: Colors.transparent,
              width: playAreaSize,
              height: playAreaSize,
              // width: screenWidth - (tileAreaHeight  * 2)  - 4,
              // height: screenWidth - (tileAreaHeight * 2) - 4,
              child: Stack(
                children: [
                  PlayerPlayfield(
                    discardedTiles: allDiscards[0],
                    quarterTurns: 2,
                    alignment: Alignment.topLeft,
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
                    quarterTurns: 0,
                    alignment: Alignment.bottomRight,
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
                        width: 300,
                        height: 300,
                        color: Colors.green,
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                MaterialButton(
                                  minWidth: 0,
                                  child: Text("Pon"),
                                  onPressed: () {},
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
