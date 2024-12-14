import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riichi/all_tiles.dart';
import 'package:riichi/hand.dart';
import 'package:riichi/hand_display.dart';
import 'package:riichi/hands.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/tiles.dart';
import 'package:riichi/ui/discarded_tiles_row.dart';
import 'package:riichi/ui/grid.dart';
import 'package:riichi/ui/hand.dart';

void main() {
  TileModel t;
  List<TileModel> tiles = <TileModel> [
  ];

  for (int i = 0 ; i < 4 ; ++i) {
  tiles.add(TileModel.dragon( dragonColor: DragonColor.Red));
  tiles.add(TileModel.dragon( dragonColor: DragonColor.Green));
  tiles.add(TileModel.dragon( dragonColor: DragonColor.White));
  tiles.add(TileModel.wind( windDirection: WindDirection.East));
  tiles.add(TileModel.wind( windDirection: WindDirection.West));
  tiles.add(TileModel.wind( windDirection: WindDirection.North));
  tiles.add(TileModel.wind( windDirection: WindDirection.South));

  for (int j = 1 ; j <= 9 ; ++j) {
  tiles.add(TileModel.suited( suit: Suit.Characters, number: j, isDora: j == 5 && i == 0));
  tiles.add(TileModel.suited( suit: Suit.Circles, number: j, isDora: j == 5 && i == 0));
  tiles.add(TileModel.suited( suit: Suit.Bamboo, number: j, isDora: j == 5 && i == 0));
    
  }

  }

  Tiles allTiles = Tiles();

  for (TileModel tm in allTiles.roundTiles) {
      print(tm.path);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Tiles alltiles = Tiles();
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<TileModel>> allHandTiles = <List<TileModel>>[];
  List<List<TileModel>> discardedTiles = <List<TileModel>>[];

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.of(context).size;
    double size = min(windowSize.width, windowSize.height);

    File f = File.fromUri(Uri.parse("assets/misc/hands.json"));

    // print(f.readAsStringSync());
    Map<String, dynamic> jsonHands = json.decode(f.readAsStringSync()) as Map<String, dynamic>;
    /*
    Hands hands = Hands.fromJson(jsonHands);

    for (Hand hand in hands.hands) {
      print(hand.name);
    }
    */
    return Material(
      child: Row(
        children: [
          Grid(
            screenWidth: PlayerPlayfield.width,
            screenHeight: PlayerPlayfield.width,
            // tileHeight: 85,
            // sidePadding: 75,
          ),
          /*
          Container(
            color: Colors.transparent,
            width: 500,
            height: PlayerPlayfield.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ListView(
                children: [
                  for (Hand hand in hands.hands)
                    HandDisplay(
                      hand: hand,
                    ),
                ],
              ),
            ),
          ),
          */
        ],
      ),
    );

/*
    print(size);

    double smallTileFactor = 12;
    double smallTileWidth = 3 * smallTileFactor;
    double smallTileHeight = 4 * smallTileFactor;

    double playFieldWidth = smallTileWidth * 8;
    double playFieldHeight = smallTileHeight * 4;

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Top row of tiles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 80,
                color: Colors.red,
              ),
              RotatedBox(
                quarterTurns: 2,
                child: HandWithTiles(
                  tiles: allHandTiles[0],
                  onTileTapped: (int tileIndex) {
                    discard(0, tileIndex);
                  },
                ),
              ),
              Container(
                width: 80,
                height: 80,
                color: Colors.red,
              ),
            ],
          ),

          // Middle row containg right and left playeers tiles, and the entire playfield
          Expanded(
            child: Row(
              children: [
                // Left row of tiles
                RotatedBox(
                  quarterTurns: 1,
                  child: HandWithTiles(
                    tiles: allHandTiles[1],
                    onTileTapped: (int tileIndex) {
                      discard(1, tileIndex);
                    },
                  ),
                ),
                // Playfield
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top
                      DiscardedTilesRow(
                        quarterTurns: 2,
                        discardedTiles: discardedTiles[0],
                        tileWidth: smallTileWidth,
                        tileHeight: smallTileHeight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left
                          DiscardedTilesRow(
                            quarterTurns: 1,
                            discardedTiles: discardedTiles[1],
                            tileWidth: smallTileWidth,
                            tileHeight: smallTileHeight,
                          ),
                          // Right
                          DiscardedTilesRow(
                            quarterTurns: 3,
                            discardedTiles: discardedTiles[2],
                            tileWidth: smallTileWidth,
                            tileHeight: smallTileHeight,
                          ),
                        ],
                      ),
                      // Bottom
                      DiscardedTilesRow(
                        quarterTurns: 0,
                        discardedTiles: discardedTiles[3],
                        tileWidth: smallTileWidth,
                        tileHeight: smallTileHeight,
                      ),
                    ],
                  ),
                ),
                // Right row of tiles
                RotatedBox(
                  quarterTurns: 3,
                  child: HandWithTiles(
                    tiles: allHandTiles[2],
                    onTileTapped: (int tileIndex) {
                      discard(2, tileIndex);
                    },
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 80,
                height: 80,
                color: Colors.red,
              ),
              HandWithTiles(
                  tiles: allHandTiles[3],
                  onTileTapped: (int tileIndex) {
                    discard(3, tileIndex);
                  }),
              Container(
                width: 80,
                height: 80,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
    */
  }

  void discard(int playerIndex, int tileIndex) {
  /*
    if (!widget.alltiles.canDiscard) {
      return;
    }
    */

    widget.alltiles.discard(playerIndex, tileIndex);

    setState(() {
      allHandTiles = widget.alltiles.allHands;
      discardedTiles = widget.alltiles.discards;
    });
  }

  @override
  void initState() {
    super.initState();
    allHandTiles = widget.alltiles.allHands;
    discardedTiles = widget.alltiles.discards;
  }
}
