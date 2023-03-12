import 'dart:io';

import 'package:fast_crypt/enums/processing_status.dart';
import 'package:fast_crypt/functions/filemanager.dart';
import 'package:fast_crypt/screens/dialogues/encrypt_file_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilesController extends GetxController {
  final count = 0.obs;
  final RxList<String> provisions = <String>[].obs;
  final status = ProcessingStatus.loading.obs;
  final _path = ''.obs;
  final _title = RxString('');
  String get title => _title.value;
  String get path => _path.value;
  // List<Directory>? currentDir;
  RxList<FileSystemEntity> entities = <FileSystemEntity>[].obs;
  RxList<FileSystemEntity> selectedEntities = <FileSystemEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    // count.value = 40;
    status.value = ProcessingStatus.loading;

    try {
      if (getCurrentPath.isNotEmpty) {
        updatePath(getCurrentDirectory.path);
        // v = [getCurrentDirectory];
      } else {
        final storageList = await getStorageList();
        updatePath(storageList.first.path);
      }
      await fetchEntities();

      ever<String>(_path, (value) {
        refreshPage();
      });
      // entities.refresh();
      // update();
      // print(ent);
      status.value = ProcessingStatus.success;
    } catch (e) {
      // status.value = ProcessingStatus.error;
    }
  }

  updatePath(String path) {
    _path.value = path;
    _title.value = path.split(Platform.pathSeparator).last;
  }

  /// Get current Directory.
  Directory get getCurrentDirectory => Directory(_path.value);

  /// Get current path, similar to [getCurrentDirectory].
  String get getCurrentPath => _path.value;

  // /// Set current directory path by providing string of path, similar to [openDirectory].
  // set setCurrentPath(String path) {
  //   _updatePath(path);
  // }

  /// return true if current directory is the root. false, if the current directory not on root of the stogare.
  Future<bool> isRootDirectory() async {
    final List<Directory> storageList = (await getStorageList());
    return (storageList
        .where((element) => element.path == Directory(_path.value).path)
        .isNotEmpty);
  }

  /// Jumps to the parent directory of currently opened directory if the parent is accessible.
  Future<void> goToParentDirectory() async {
    if (!(await isRootDirectory())) {
      openDirectory(Directory(_path.value).parent);
    }
  }

  /// Open directory by providing [Directory].
  void openDirectory(FileSystemEntity entity) {
    if (entity is Directory) {
      updatePath(entity.path);
      // print(entity);
    } else {
      throw ("FileSystemEntity entity is File. Please provide a Directory(folder) to be opened not File");
    }
  }

  Future<void> fetchEntities() async {
    final ent = await entitiesList(path);

    // print(ent);
    entities.clear();
    entities.addAll(ent);
    entities.refresh();
  }

  Future<void> refreshPage() async {
    status.value = ProcessingStatus.loading;
    await fetchEntities();
    status.value = ProcessingStatus.success;

    // print(entities);
  }

  Future<void> processFile(File file) async {
    status.value = ProcessingStatus.loading;
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return EncryptFileDialogue(files: [file]);
      },
    );
    refreshPage();
  }

  Future<void> processFiles(
      {required List<File> files,
      required List<FileSystemEntity> entities}) async {
    status.value = ProcessingStatus.loading;
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return EncryptFileDialogue(files: files, entities: entities);
      },
    );
    refreshPage();
  }

  void selectEntity(FileSystemEntity entity) {
    bool isSelected =
        selectedEntities.any((element) => entity.path == element.path);
    if (isSelected) {
      selectedEntities.removeWhere((element) => element.path == entity.path);
    } else {
      selectedEntities.add(entity);
    }
    // selectedEntities.refresh();
    entities.refresh();
  }

  void processEntities() {
    List<File> files = getAllFiles(selectedEntities);
    processFiles(files: files, entities: selectedEntities);
  }

  void clearSelection() {
    selectedEntities.clear();
    entities.refresh();
  }
}
