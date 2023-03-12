import 'dart:io';

import 'package:fast_crypt/common/styles.dart';
import 'package:fast_crypt/common/widgets.dart';
import 'package:fast_crypt/controllers/files_controller.dart';
import 'package:fast_crypt/functions/filemanager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectStorageDialogue extends StatelessWidget {
  final FilesController controller = Get.find();
  SelectStorageDialogue({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Directory>>(
      future: getStorageList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<FileSystemEntity> storageList = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: storageList
                    .map((e) => ListTile(
                          title: Text(
                            fileEntityBasename(e),
                          ),
                          onTap: () {
                            controller.openDirectory(e);
                            Navigator.pop(context);
                          },
                        ))
                    .toList()
                  ..add(ListTile(
                    title: TextField(
                        onSubmitted: (value) async {
                          final directory = Directory(value);
                          directory.exists().then((exists) {
                            if (exists) {
                              controller.openDirectory(directory);
                              Navigator.pop(context);
                            } else {
                              Get.snackbar("Unable to navigate",
                                  "Directory does not exist!!!",
                                  colorText: Colors.red);
                            }
                          });
                        },
                        decoration: myInputDecoration(label: 'Folder Path')),
                  ))),
          );
        }
        return const Dialog(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
