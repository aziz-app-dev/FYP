import 'package:get/get.dart';

class AdditivesObs extends GetxController {
  final int id;
  final String title;
  final dynamic price;
  // final double price;
  RxBool isChecked = false.obs;

  AdditivesObs(
      {required this.id,
      required this.title,
      required this.price,
      bool checked = false}) {
    isChecked.value = checked;
  }
  void toggleChecked() {
    isChecked.value = !isChecked.value;
  }
}
