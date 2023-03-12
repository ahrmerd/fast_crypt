import 'dart:io';

import 'package:fast_crypt/controllers/files_controller.dart';
import 'package:fast_crypt/functions/filemanager.dart';
import 'package:fast_crypt/screens/my_scaffold.dart';
import 'package:fast_crypt/screens/files_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final FilesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => initiateCreateFolder(context),
              icon: const Icon(Icons.create_new_folder_outlined),
            ),
            // IconButton(
            //   onPressed: () => sort(context, controller),
            //   icon: const Icon(Icons.sort_rounded),
            // ),
            IconButton(
              onPressed: () => selectStorage(context),
              icon: const Icon(Icons.sd_storage_rounded),
            )
          ],
          title: Obx(
            () {
              return Text(controller.path);
            },
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              // controller.increase();
              await controller.goToParentDirectory();
            },
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: FilesUI(),
          // child: FilesUI(controller: controller),
        ),
      ),
    );
  }
}
