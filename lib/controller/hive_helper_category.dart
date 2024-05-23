import 'dart:async';

import 'package:hive/hive.dart';
import 'package:simple_note/model/category.dart';

const String CategoryBox = 'CATEGORY_BOX';

class HiveHelperCategory {
  static final HiveHelperCategory _singleton = HiveHelperCategory._internal();
  factory HiveHelperCategory() {
    return _singleton;
  }
  HiveHelperCategory._internal();

  Box<CategoryModel>? categoriesBox;

  Future openBox() async {
    categoriesBox = await Hive.openBox(CategoryBox);
  }

  // note: CRUD
  Future create(String data) async {
    /** 만약 값이 없으면 해당 데이터를 추가하고, 있으면 해당 데이터를 추가하지 않는다 **/
    var containedCategories = categoriesBox!.values.where((item) => item.categories == data);
    if(containedCategories.isEmpty) {
      categoriesBox?.add(CategoryModel(data));
    }
    return;
  }

  Future update({required int index, required String data}) async {
    var containedCategories = categoriesBox!.values.where((item) => item.categories == data);
    if(containedCategories.isEmpty) {
      categoriesBox!.putAt(index, CategoryModel(data));
    }
  }

  Future read() async {
    return categoriesBox!.values.toList();
  }

  Future delete(int index) async {
    categoriesBox!.deleteAt(index);
  }

}