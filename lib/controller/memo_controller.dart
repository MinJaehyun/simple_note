import 'package:get/get.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/repository/local_data_source/memo_repository.dart';

class MemoController extends GetxController {
  late MemoRepository _memoRepository;

  RxList<MemoModel> memoList = <MemoModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _memoRepository = MemoRepository();
    loadMemo();
  }

  // 미사용
  void loadMemo() async {
    isLoading(true);
    try {
      var memos = await _memoRepository.getAllMemo();
      memoList(memos);
    } catch (e) {
      errorMessage('Failed to load memos: $e');
    } finally {
      isLoading(false);
    }
  }

  // 변경 전 1.
  // void addMemo() async {
  //   var memos = await _memoRepository.addMemo(createdAt: createdAt, title: title);
  //   memoList(memos);
  // }

  // 변경 전 2.
  // void addMemo(DateTime createdAt, String title, {required DateTime createdAt}) async {
  //   await _memoRepository.addMemo(createdAt: createdAt, title: title);
  //   loadMemo(); // 메모를 추가한 후 다시 로드하여 목록 업데이트
  // }

  // 변경 전 3.
  // void addMemo({
  //   required DateTime createdAt,
  //   required String title,
  //   String? mainText,
  //   String? selectedCategory,
  //   bool isFavoriteMemo = false,
  // }) async {
  //   await _memoRepository.addMemo(
  //     createdAt: createdAt,
  //     title: title,
  //     mainText: mainText,
  //     selectedCategory: selectedCategory,
  //     isFavoriteMemo: isFavoriteMemo,
  //   );
  //   loadMemo(); // 메모 추가 후 다시 로드하여 목록 업데이트
  // }

  // 변경 후 4. add
  // MemoController가 MemoRepository를 직접 호출하여 데이터 작업을 수행하도록 한다.
  void addMemo({
    required DateTime createdAt,
    required String title,
    String? mainText,
    String? selectedCategory,
    bool isFavoriteMemo = false,
  }) async {
    isLoading(true);
    try {
      final memo = MemoModel(
        createdAt: createdAt,
        title: title,
        mainText: mainText,
        selectedCategory: selectedCategory,
        isFavoriteMemo: isFavoriteMemo,
      );
      await _memoRepository.addMemo(memo);
      // 메모 추가 후 다시 로드하여 목록 업데이트
      loadMemo();
    } catch (e) {
      errorMessage('Failed to add memo: $e');
    } finally {
      isLoading(false);
    }
  }

  // update
  void updateMemo({
    required int index,
    required DateTime createdAt,
    required String title,
    String? selectedCategory,
    String? mainText,
    bool isFavoriteMemo = false,
  }) async {
    isLoading(true);
    try {
      final memo = MemoModel(
        createdAt: createdAt,
        title: title,
        mainText: mainText,
        selectedCategory: selectedCategory,
        isFavoriteMemo: isFavoriteMemo,
      );
      await _memoRepository.updateMemo(index, memo);
      loadMemo();
    } catch (e) {
      errorMessage('Failed to update memo: $e');
    } finally {
      isLoading(false);
    }
  }

  // delete
  void deleteMemo({required int index}) async {
    isLoading(true);

    try {
      await _memoRepository.delete(index);
      loadMemo(); // 메모 삭제 후 다시 로드하여 목록 업데이트
    } catch (e) {
      errorMessage('Failed to delete memo: $e');
    } finally {
      isLoading(false);
    }
  }

}
