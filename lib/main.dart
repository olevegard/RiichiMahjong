import 'package:flutter/material.dart';
import 'package:riichi/tile.dart';
import 'package:riichi/ui/discarded_tiles_row.dart';
import 'package:riichi/ui/grid.dart';

void main() {
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
      tiles.add(TileModel.suited(
          suit: Suit.characters, number: j, isDora: j == 5 && i == 0));
      tiles.add(TileModel.suited(
          suit: Suit.circles, number: j, isDora: j == 5 && i == 0));
      tiles.add(TileModel.suited(
          suit: Suit.bamboo, number: j, isDora: j == 5 && i == 0));
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
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
    return Material(
      child: Container(
        width: PlayerPlayfield.width,
        height: PlayerPlayfield.width,
        child: Grid(
          screenWidth: PlayerPlayfield.width,
          screenHeight: PlayerPlayfield.width,
        ),
      ),
    );
  }
}
