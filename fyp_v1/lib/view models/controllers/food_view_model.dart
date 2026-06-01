// ignore_for_file: prefer_final_fields, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:get/get.dart';
import '../../models/additives_models.dart';

class FoodController extends GetxController {
  String _category = '';

  String get category => _category;

  set setCategory(String newVal) {
    _category = newVal;
  }

  final RxList<String> _type = <String>[].obs;

  RxList<String> get type => _type;

  set setType(String newVal) {
    _type.add(newVal);
  }

  int genrateId() {
    int min = 0;
    int max = 1000;
    final _random = Random();
    return min + Random().nextInt(max - min);
  }

  RxList<Additives> _addivitesList = <Additives>[].obs;

  RxList<Additives> get addivitesList => _addivitesList;

  set addAddivites(Additives newVal) {
    _addivitesList.add(newVal);
  }

  void clearAddittives() {
    _addivitesList.clear();
  }
}
