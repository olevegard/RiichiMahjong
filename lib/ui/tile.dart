import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riichi/tile.dart';

class TileWidget extends StatelessWidget {
  final TileModel tile;
  final bool isVisible;
  final double width;
  final double height;

  const TileWidget({
    super.key,
    required this.tile,
    required this.isVisible,
    required this.width,
    required this.height,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        // color: const Color(0xffff3737),
        color: Colors.black26,
        child: Image.file(
          File.fromUri(
            Uri.parse(
            tile.path.isNotEmpty ? 
            "assets/tiles/${tile.path}"
            : "assets/misc/Back.png"
            ),
          ),
        ),
      ),
    );
  }
}
