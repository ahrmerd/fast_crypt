import 'package:fast_crypt/controllers/permissions_controller.dart';
import 'package:fast_crypt/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsPage extends StatelessWidget {
  PermissionsPage({super.key});
  PermissionsController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.permissionStatus.value) {
        case PermissionStatus.denied:
          return permissionPage();
        case PermissionStatus.granted:
          return HomePage();
        case PermissionStatus.permanentlyDenied:
          controller.openSettings();
          return permissionPage();
        default:
          return permissionPage();
      }
    });
    //  Widget getPermissionPage() {
  }

  Widget permissionPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cryptic'),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('request permissions'),
                onTap: () {
                  controller.requestPermission();
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('open settings'),
                onTap: () {
                  openAppSettings();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
