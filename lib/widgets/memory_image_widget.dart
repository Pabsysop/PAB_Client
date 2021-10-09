import 'dart:typed_data';

import 'package:flutter/material.dart';

class MemoryImageWidget extends StatelessWidget {
  final Uint8List imageBytes;
  final double size;
  const MemoryImageWidget(this.imageBytes, this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(size / 2.2)),
      child: Image.memory(
        imageBytes,
        width: size,
        height: size,
        fit: BoxFit.fill,
      ),
    );
  }
}
