import 'dart:io';

// import 'package:fast_crypt/widgets/homepage.dart';
import 'package:fast_crypt/controllers/loading_controller.dart';
import 'package:fast_crypt/permissions.dart';
import 'package:fast_crypt/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/files_controller.dart';
import 'controllers/permissions_controller.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late final Permission _permission;
  // PermissionStatus _permissionStatus = PermissionStatus.granted;
  // @override
  // void initState() {
  //   if (Platform.isAndroid || Platform.isIOS) {
  //     _permissionStatus = PermissionStatus.denied;
  //   }
  //   _permission = Permission.manageExternalStorage;
  //   super.initState();

  //   _listenForPermissionStatus();
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(FilesController());
    Get.put(LoadingController());
    if (Platform.isAndroid) {
      Get.put(PermissionsController());
    }
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyWidget(),
      home: Platform.isAndroid ? PermissionsPage() : HomePage(),
      // home: HomePage(),
    );
  }

  // void _listenForPermissionStatus() async {
  //   final status = await _permission.status;
  //   // _permissionStatus = status;
  //   setState(() => _permissionStatus = status);
  // }

  // Color getPermissionColor() {
  //   switch (_permissionStatus) {
  //     case PermissionStatus.denied:
  //       return Colors.red;
  //     case PermissionStatus.granted:
  //       return Colors.green;
  //     case PermissionStatus.limited:
  //       return Colors.orange;
  //     default:
  //       return Colors.grey;
  //   }
  // }

  // void requestPermission() async {
  //   var status = await _permission.request();

  //   setState(() {
  //     _permissionStatus = status;
  //   });
  // }

  // Widget getPermissionPage() {
  //   switch (_permissionStatus) {
  //     case PermissionStatus.denied:
  //       return permissionPage();
  //     case PermissionStatus.granted:
  //       return HomePage();
  //     case PermissionStatus.permanentlyDenied:
  //       openAppSettings();
  //       return permissionPage();
  //     default:
  //       return permissionPage();
  //   }
  // }
}
