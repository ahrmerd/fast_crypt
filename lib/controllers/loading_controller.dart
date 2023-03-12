import 'package:get/get.dart';

class LoadingController extends GetxController {
  final current = 0.obs;
  final total = 0.obs;

  void startOperations(int totalValue) {
    total.value = totalValue;
    current.value = 0;
  }

  void progress([int value = 1]) {
    current.value += value;
  }
}
