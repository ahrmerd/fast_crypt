import 'dart:io';

import 'package:fast_crypt/functions/filemanager.dart';
import 'package:flutter/material.dart';

class SubtitleWidget extends StatelessWidget {
  final FileSystemEntity entity;
  const SubtitleWidget({
    Key? key,
    required this.entity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return Text(
              formatBytes(size),
            );
          }
          return Text(
            "${snapshot.data!.modified}".substring(0, 10),
          );
        } else {
          return const Text("");
        }
      },
    );
  }
}
