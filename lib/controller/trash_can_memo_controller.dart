import 'package:get/get.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:simple_note/repository/local_data_source/trash_can_memo_repository.dart';

class TrashCanMemoController extends GetxController {
  late TrashCanMemoRepository _trashCanMemoRepository;

  RxList<TrashCanModel> trashCanMemoList = <TrashCanModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _trashCanMemoRepository = TrashCanMemoRepository();
    loadMemo();
  }

  // 미사용
  void loadMemo() async {
    isLoading(true);
    try {
      var memos = await _trashCanMemoRepository.getAllMemo();
      trashCanMemoList(memos);
    } catch (e) {
      errorMessage('Failed to load memos: $e');
    } finally {
      isLoading(false);
    }
  }

  // add
  void addMemo({
    required DateTime createdAt,
    required String title,
    String? mainText,
    String? selectedCategory,
    bool isFavoriteMemo = false,
  }) async {
    isLoading(true);
    try {
      final memo = TrashCanModel(
        createdAt: createdAt,
        title: title,
        mainText: mainText,
        selectedCategory: selectedCategory,
        isFavoriteMemo: isFavoriteMemo,
      );
      await _trashCanMemoRepository.addMemo(memo);
      loadMemo();
    } catch (e) {
      errorMessage('Failed to add memo: $e');
    } finally {
      isLoading(false);
    }
  }

  // update
  void updateMemo({
    required index,
    required DateTime createdAt,
    required String title,
    String? selectedCategory,
    String? mainText,
    bool isFavoriteMemo = false,
  }) async {
    isLoading(true);
    try {
      final memo = TrashCanModel(
        createdAt: createdAt,
        title: title,
        mainText: mainText,
        selectedCategory: selectedCategory,
        isFavoriteMemo: isFavoriteMemo,
      );
      await _trashCanMemoRepository.updateMemo(index, memo);
      // 메모 추가 후 다시 로드하여 목록 업데이트
      loadMemo();
    } catch (e) {
      errorMessage('Failed to add memo: $e');
    } finally {
      isLoading(false);
    }
  }

  // delete
  void deleteMemo({required int index}) async {
    isLoading(true);
    try {
      await _trashCanMemoRepository.delete(index);
      loadMemo(); // 메모 삭제 후 다시 로드하여 목록 업데이트
    } catch (e) {
      errorMessage('Failed to delete memo: $e');
    } finally {
      isLoading(false);
    }
  }
}