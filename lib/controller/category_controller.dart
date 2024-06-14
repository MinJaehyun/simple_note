import 'package:get/get.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/repository/local_data_source/category_repository.dart';

class CategoryController extends GetxController {
  late CategoryRepository _categoryRepository;

  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _categoryRepository = CategoryRepository();
    loadCategories();
  }

  // get
  void loadCategories() async {
    isLoading(true);
    try {
      var categories = await _categoryRepository.getAllCategories();
      categoryList(categories);
    } catch (e) {
      errorMessage('Failed to load categories list: $e');
    } finally {
      isLoading(false);
    }
  }

  // add
  // note: addCtr 메서드에서 CategoryModel 객체를 생성하지 않고, 문자열을 그대로 addRepo 메서드에 전달함!
  void addCtr(String? category) async {
    if (category == null || category.isEmpty) {
      errorMessage('Category cannot be null or empty');
      return;
    }
    isLoading(true);
    try {
      await _categoryRepository.addRepo(CategoryModel(category));
      loadCategories();
    } catch (e) {
      errorMessage('Failed to add category: $e');
    } finally {
      isLoading(false);
    }
  }

  // 미사용: addAll
  // note: addCtr 메서드에서 CategoryModel 객체를 생성하지 않고, 문자열을 그대로 addRepo 메서드에 전달함!
  void addAllCtr(List<CategoryModel>? category) async {
    if (category == null || category.isEmpty) {
      errorMessage('Category cannot be null or empty');
      return;
    }
    isLoading(true);
    try {
      await _categoryRepository.addAllRepo(category);
    } catch (e) {
      errorMessage('Failed to add category: $e');
    } finally {
      isLoading(false);
    }
  }

  // update
  void updateCtr(int index, String? category) async {
    if (category == null || category.isEmpty) {
      errorMessage('Category cannot be null or empty');
      return;
    }
    isLoading(true);
    try {
      await _categoryRepository.updateRepo(index, CategoryModel(category));
      loadCategories();
    } catch (e) {
      errorMessage('Failed to update category: $e');
    } finally {
      isLoading(false);
    }
  }

  // delete
  void deleteCtr({required int index}) async {
    isLoading(true);
    try {
      await _categoryRepository.deleteRepo(index);
      loadCategories();
    } catch (e) {
      errorMessage('Failed to delete category: $e');
    } finally {
      isLoading(false);
    }
  }

  // 미사용: all delete
  void allDeleteCtr() async {
    isLoading(true);
    try {
      await _categoryRepository.allDeleteRepo();
    } catch(e) {
      errorMessage('Failed to All delete category: $e');
    } finally {
      isLoading(false);
    }
  }
}
