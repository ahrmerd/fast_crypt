import 'dart:io';

import 'package:fast_crypt/controllers/files_controller.dart';
import 'package:fast_crypt/functions/filemanager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateFolderDialogue extends StatelessWidget {
  CreateFolderDialogue({
    Key? key,
    required this.folderName,
  }) : super(key: key);

  final TextEditingController folderName;
  final FilesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: TextField(
                controller: folderName,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Create Folder
                  await createFolder(
                      controller.getCurrentPath, folderName.text);
                  // Open Created Folder
                  controller.updatePath(
                      "${controller.getCurrentPath}${Platform.pathSeparator}${folderName.text}");
                } catch (e) {}

                Navigator.pop(context);
              },
              child: const Text('Create Folder'),
            )
          ],
        ),
      ),
    );
  }
}
