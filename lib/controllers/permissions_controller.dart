import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

class PermissionsController extends GetxController {
  Saf saf = Saf(Platform.pathSeparator);
  Rx<PermissionStatus> permissionStatus = PermissionStatus.denied.obs;
  final Permission permission = Permission.manageExternalStorage;

  Future requestPermission() async {
    permissionStatus.value = (await permission.request());
    if (permissionStatus.value != PermissionStatus.granted) {
      bool? status = await saf.getDirectoryPermission();
      if (status ?? true) {
        permissionStatus.value = PermissionStatus.granted;
      }
    }
  }

  @override
  void onInit() async {
    permissionStatus.value = (await permission.request());
    super.onInit();
  }

  Future<void> openSettings() async {
    await openAppSettings();
    requestPermission();
  }
}
