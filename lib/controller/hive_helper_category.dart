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
    if(containedCategories.length == 0) {
      categoriesBox?.add(CategoryModel(data));
    }
    return;
  }

  Future update({required int index, required String data}) async {
    var containedCategories = categoriesBox!.values.where((item) => item.categories == data);
    if(containedCategories.length == 0) {
      categoriesBox!.putAt(index, CategoryModel(data));
    }
  }

  Future read() async {
    return categoriesBox!.values.toList();
  }

  Future delete(int index) async {
    categoriesBox!.deleteAt(index);
  }

  // todo: 미사용, 추후 검색 시 사용할 api
  // Future filteredCategories(String data) async {
  //   // var filteredCategories = categoriesBox!.values.where((item) => item.categories!.startsWith(data));
  // }

  // note: 미사용 - 기본 구조
  // Future create(String data) async {
  //   return categoriesBox!.add(CategoryModel(data));
  // }

  // Reorder - 대기
  // Future reorder(int oldIndex, int newIndex) async {
  //   List<CategoryModel> newList = [];
  //   newList.addAll(categoriesBox!.values);
  //
  //   final CategoryModel item = newList.removeAt(oldIndex);
  //   newList.insert(newIndex, item);
  //
  //   await categoriesBox!.clear();
  //   await categoriesBox!.addAll(newList);
  // }
}