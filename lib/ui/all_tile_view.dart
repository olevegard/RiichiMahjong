import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riichi/tiles.dart';

/*
class AllTileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          children: [
            for (String tile in Tiles.allTiles)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Container(
                    width: 60,
                    height: 80,
                    padding: const EdgeInsets.all(5),
                    // color: const Color(0xffff3737),
                    color: Colors.black26,
                    child: Image.file(
                      File.fromUri(
                        Uri.parse("assets/tiles/$tile.png"),
                        // Uri.parse("assets/tiles/Pin1.png"),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
*/
