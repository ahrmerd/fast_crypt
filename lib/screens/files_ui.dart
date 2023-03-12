import 'dart:io';

import 'package:fast_crypt/common/colors.dart';
import 'package:fast_crypt/common/widgets.dart';
import 'package:fast_crypt/controllers/files_controller.dart';
import 'package:fast_crypt/enums/processing_status.dart';
import 'package:fast_crypt/functions/filemanager.dart';
import 'package:fast_crypt/screens/subtitle_widget.dart';
import 'package:fast_crypt/screens/utilities/error_screen.dart';
import 'package:fast_crypt/screens/utilities/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilesUI extends StatelessWidget {
  final FilesController controller = Get.find();
  FilesUI({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.printIt('hello');
    return Obx(() {
      switch (controller.status.value) {
        case ProcessingStatus.initial:
          return LoadingScreen();
        case ProcessingStatus.loading:
          return LoadingScreen();
        case ProcessingStatus.error:
          return const ErrorScreen();
        case ProcessingStatus.success:
          final entities = controller.entities;
          return Column(
            children: [
              if (controller.selectedEntities.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButton(
                      child: const Text('Encrypt Or Decrypt'),
                      onTap: () {
                        controller.processEntities();
                      },
                    ),
                    MyButton(
                      child: const Text('Clear Selection'),
                      onTap: () {
                        controller.clearSelection();
                      },
                    ),
                  ],
                ),
              Flexible(
                child: ListView.builder(
                    itemCount: entities.length,
                    itemBuilder: (context, index) {
                      FileSystemEntity entity = entities[index];
                      bool isSelected = controller.selectedEntities
                          .any((element) => entity.path == element.path);
                      return Card(
                        child: ListTile(
                          leading: entity is File
                              ? const Icon(Icons.feed_outlined)
                              : const Icon(Icons.folder),
                          title: Text(fileEntityBasename(entity)),
                          subtitle: SubtitleWidget(entity: entity),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.done,
                                  color: primaryColor,
                                )
                              : null,
                          onTap: () async {
                            if (entity is Directory) {
                              controller.openDirectory(entity);
                            } else {
                              controller.processFile(File(entity.path));
                            }
                          },
                          onLongPress: () async {
                            controller.selectEntity(entity);
                          },
                        ),
                      );
                    }),
              ),
            ],
          );
      }
    });
  }
}
