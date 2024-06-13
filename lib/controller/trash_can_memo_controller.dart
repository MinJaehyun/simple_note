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
    loadMemoCtr();
  }

  // 미사용
  void loadMemoCtr() async {
    isLoading(true);
    try {
      var memos = await _trashCanMemoRepository.getAllMemoRepo();
      trashCanMemoList(memos);
    } catch (e) {
      errorMessage('Failed to load trash can memo list: $e');
    } finally {
      isLoading(false);
    }
  }

  // add
  void addCtr({
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
      await _trashCanMemoRepository.addRepo(memo);
      loadMemoCtr();
    } catch (e) {
      errorMessage('Failed to add trash can memo : $e');
    } finally {
      isLoading(false);
    }
  }

  // update
  void updateCtr({
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
      await _trashCanMemoRepository.updateRepo(index, memo);
      // 메모 추가 후 다시 로드하여 목록 업데이트
      loadMemoCtr();
    } catch (e) {
      errorMessage('Failed to update trash can memo : $e');
    } finally {
      isLoading(false);
    }
  }

  // delete
  void deleteCtr({required int index}) async {
    isLoading(true);
    try {
      await _trashCanMemoRepository.deleteRepo(index);
      loadMemoCtr(); // 메모 삭제 후 다시 로드하여 목록 업데이트
    } catch (e) {
      errorMessage('Failed to delete trash can memo : $e');
    } finally {
      isLoading(false);
    }
  }

  // All delete
  Future<void> allDeleteCtr() async {
    isLoading(true);
    try {
      await _trashCanMemoRepository.allDeleteRepo();
      loadMemoCtr(); // 메모 삭제 후 다시 로드하여 목록 업데이트
    } catch (e) {
      errorMessage('Failed to All delete trash can memo : $e');
    } finally {
      isLoading(false);
    }
  }

}