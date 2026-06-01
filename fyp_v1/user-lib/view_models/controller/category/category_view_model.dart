// import 'package:get/get.dart';

// class CategoryController extends GetxController {
//   final RxString _categoryValue = ''.obs;
//   String get categoryValue => _categoryValue.value;

//   set updateCategory(String value) {
//     _categoryValue.value = value;
//   }

//   final RxString _title = ''.obs;
//   String get title => _title.value;

//   set updateTitle(String value) {
//     _title.value = value;
//   }
// }
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final RxString _categoryValue = ''.obs;
  String get categoryValue => _categoryValue.value;

  set updateCategory(String value) {
    if (_categoryValue.value == value) {
      // If the selected category is clicked again, deselect it
      _categoryValue.value = '';
    } else {
      _categoryValue.value = value; // Set new category
    }
  }

  final RxString _title = ''.obs;
  String get title => _title.value;

  set updateTitle(String value) {
    _title.value = value;
  }
}
