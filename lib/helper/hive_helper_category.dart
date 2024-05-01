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
    return categoriesBox!.add(CategoryModel(categories: data));
  }

  Future read() async {
    return categoriesBox!.values.toList();
  }

  Future delete(int index) async {
    categoriesBox!.deleteAt(index);
  }

}