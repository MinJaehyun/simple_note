import 'package:hive/hive.dart';
import 'package:simple_note/model/category.dart';

const String CategoryBox = 'CATEGORY_BOX';

class CategoryRepository {
  static final CategoryRepository _singleton = CategoryRepository._internal();

  factory CategoryRepository() {
    return _singleton;
  }

  CategoryRepository._internal();

  Box<CategoryModel>? categoriesBox;

  Future openBox() async {
    categoriesBox = await Hive.openBox<CategoryModel>(CategoryBox);
  }

  // get
  Future<List<CategoryModel>> getAllCategories() async {
    return categoriesBox!.values.toList();
  }

  // add
  Future<void> addRepo(CategoryModel category) async {
    if (categoriesBox == null) {
      await openBox();
    }
    // await categoriesBox!.add(category);
    List<CategoryModel> containedCategories = categoriesBox!.values.where((item) => item.categories == category).toList();
    if (containedCategories.isEmpty) {
      categoriesBox?.add((category));
    }
    return;
  }

  // update
  Future<void> updateRepo(int index, CategoryModel category) async {
    await categoriesBox!.putAt(index, category);
  }

  // delete
  Future deleteRepo(int index) async {
    await categoriesBox!.deleteAt(index);
  }
}
