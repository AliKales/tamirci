import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
final class MImagePage {
  final String? path;
  final Uint8List? bytes;

  const MImagePage({this.path, this.bytes});
}

class ImagePageView extends StatelessWidget {
  const ImagePageView({super.key, required this.m});

  final MImagePage m;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Image.file(File(m.path ?? "")),
    );
  }
}
