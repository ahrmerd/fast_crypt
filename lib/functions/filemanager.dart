import 'dart:io';
import 'dart:math';

import 'package:fast_crypt/screens/dialogues/create_folder_dialogue.dart';
import 'package:fast_crypt/screens/dialogues/select_storage_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<List<Directory>> getStorageList() async {
  if (Platform.isAndroid) {
    List<Directory> storages = (await getExternalStorageDirectories())!;
    storages = storages.map((Directory e) {
      final List<String> splitedPath = e.path.split("/");
      return Directory(splitedPath
          .sublist(0, splitedPath.indexWhere((element) => element == "Android"))
          .join("/"));
    }).toList();
    return storages;
  } else {
    final Directory dir = await getApplicationDocumentsDirectory();
    // Gives the home directory.
    final Directory home = dir.parent;

    // you may provide root directory.
    // final Directory root = dir.parent.parent.parent;
    return [home];
  }
}

void selectStorage(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: SelectStorageDialogue(),
    ),
  );
}

void initiateCreateFolder(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController folderName = TextEditingController();
      return CreateFolderDialogue(folderName: folderName);
    },
  );
}

Future<void> createFolder(String currentPath, String name) async {
  await Directory(currentPath + Platform.pathSeparator + name).create();
}

Future<List<FileSystemEntity>> entitiesList(String path) async {
  final List<FileSystemEntity> list = await Directory(path).list().toList();
  final dirs = list.whereType<Directory>().toList();
  // sorting folder list by name.
  dirs.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

  // making list of only flies.
  final files = list.whereType<File>().toList();
  // sorting files list by name.
  files.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

  // first folders will go to list (if available) then files will go to list.
  return [...dirs, ...files];
}

String fileEntityBasename(FileSystemEntity entity) {
  if (entity is Directory) {
    return entity.path.split(Platform.pathSeparator).last;
  } else if (entity is File) {
    return entity.path.split(Platform.pathSeparator).last;
  } else {
    print(
        "Please provide a Object of type File, Directory or FileSystemEntity");
    return "";
  }
}

String formatBytes(int bytes, [int precision = 2]) {
  if (bytes != 0) {
    final double base = log(bytes) / log(1024);
    final suffix = const ['B', 'KB', 'MB', 'GB', 'TB'][base.floor()];
    final size = pow(1024, base - base.floor());
    return '${size.toStringAsFixed(precision)} $suffix';
  } else {
    return "0B";
  }
}

List<File> getAllFiles(List<FileSystemEntity> entities) {
  List<File> files = [];
  for (var entity in entities) {
    if (entity is File) {
      files.add(entity);
    } else if (entity is Directory) {
      final subEntites = entity.listSync();
      final subFiles = getAllFiles(subEntites);
      files.addAll(subFiles);
    }
  }
  return files;
}
