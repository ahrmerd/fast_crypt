import 'package:fast_crypt/common/colors.dart';
import 'package:fast_crypt/common/widgets.dart';
import 'package:fast_crypt/controllers/loading_controller.dart';
import 'package:fast_crypt/screens/utilities/colorloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key}) : super(key: key);
  LoadingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ColorLoader(
            radius: 50,
            dotRadius: 10,
          ),
          const HorizontalSpace(25),
          const Text(
            'We are Working, Please wait a moment...',
            style: TextStyle(
              color: primaryDarkColor,
            ),
          ),
          // Obx(() => Text(controller.current.value.toString())),
          Obx(() {
            return (controller.current.value != 0 &&
                    controller.total.value != 0)
                ? Text(
                    '${controller.current.value} out of ${controller.total.value}',
                    style: const TextStyle(
                      color: primaryDarkColor,
                    ),
                  )
                : const Text('Loading');
          })
        ],
      ),
    );
  }
}
