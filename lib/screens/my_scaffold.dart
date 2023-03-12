import 'package:fast_crypt/controllers/files_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyScaffold extends StatelessWidget {
  MyScaffold({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final FilesController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: child,
      onWillPop: () async {
        if (await controller.isRootDirectory()) {
          return true;
        } else {
          controller.goToParentDirectory();
          return false;
        }
      },
    );
  }
}
