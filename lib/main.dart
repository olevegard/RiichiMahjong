import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/tiles.dart';
import 'package:riichi/ui/discarded_tiles_row.dart';
import 'package:riichi/ui/grid.dart';

void main() {
  TileModel t;
  List<TileModel> tiles = <TileModel>[];

  for (int i = 0; i < 4; ++i) {
    tiles.add(TileModel.dragon(dragonColor: DragonColor.red));
    tiles.add(TileModel.dragon(dragonColor: DragonColor.green));
    tiles.add(TileModel.dragon(dragonColor: DragonColor.white));
    tiles.add(TileModel.wind(windDirection: WindDirection.east));
    tiles.add(TileModel.wind(windDirection: WindDirection.west));
    tiles.add(TileModel.wind(windDirection: WindDirection.north));
    tiles.add(TileModel.wind(windDirection: WindDirection.south));

    for (int j = 1; j <= 9; ++j) {
      tiles.add(TileModel.suited(suit: Suit.characters, number: j, isDora: j == 5 && i == 0));
      tiles.add(TileModel.suited(suit: Suit.circles, number: j, isDora: j == 5 && i == 0));
      tiles.add(TileModel.suited(suit: Suit.bamboo, number: j, isDora: j == 5 && i == 0));
    }
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
