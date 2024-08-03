import 'dart:io';

import 'package:get/get.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/repository/local_data_source/memo_repository.dart';

class MemoController extends GetxController {
  late MemoRepository _memoRepository;

  RxList<MemoModel> memoList = <MemoModel>[].obs;
  RxBool _isLoading = false.obs;
  RxString _errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _memoRepository = MemoRepository();
    loadMemoCtr();
  }

  void loadMemoCtr() async {
    _isLoading(true);
    try {
      List<MemoModel> memos = await _memoRepository.getAllMemoRepo();
      // fix: memoList(memos);
      // assignAll: 기존의 리스트를 새로운 리스트로 완전히 교체
      // addAll: 기존 리스트에 새로운 요소를 추가
      // note: assignAll 사용하여 기존의 리스트인 memoList를 완전히 교체함
      memoList.assignAll(memos);
    } catch (e) {
      _errorMessage('Failed to load memos: $e');
    } finally {
      _isLoading(false);
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

  void sortByCreatedAt() {
    memoList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  // 변경 후 4. add
  // MemoController가 MemoRepository를 직접 호출하여 데이터 작업을 수행하도록 한다.
  void addCtr({
    required DateTime createdAt,
    required String title,
    String? mainText,
    String? selectedCategory,
    bool isFavoriteMemo = false,
    bool isCheckedTodo = false,
    // fix: note: Hive는 File 객체 자체를 저장할 수 없으므로 String으로 저장해야 한다
    File? imagePath,
  }) async {
    _isLoading(true);
    try {
      final memo = MemoModel(
        createdAt: createdAt,
        title: title,
        mainText: mainText,
        selectedCategory: selectedCategory,
        isFavoriteMemo: isFavoriteMemo,
        isCheckedTodo: isCheckedTodo,
        // note: String 처리하기 위한 설정
        imagePath: imagePath?.path,
      );
      await _memoRepository.addMemoRepo(memo);
      // fix: loadMemoCtr();
      // note: 메모를 추가한 후 리스트에 직접 추가하여 불필요한 데이터 로딩을 피함 (메모가 많아지면 아래 방식이 효율적)
      memoList.add(memo);
      sortByCreatedAt(); // 추가 후 정렬
    } catch (e) {
      _errorMessage('Failed to add memo: $e');
    } finally {
      _isLoading(false);
    }
  }

  // update
  void updateCtr({
    required int index,
    required DateTime createdAt,
    required String title,
    String? selectedCategory,
    String? mainText,
    bool isFavoriteMemo = false,
    bool isCheckedTodo = false,
    File? imagePath,
  }) async {
    _isLoading(true);
    try {
      final memo = MemoModel(
        createdAt: createdAt,
        title: title,
        mainText: mainText,
        selectedCategory: selectedCategory,
        isFavoriteMemo: isFavoriteMemo,
        isCheckedTodo: isCheckedTodo,
        // note: fix: imagePath: imagePath?.path,
        imagePath: imagePath != null ? imagePath.path : null,
      );
      await _memoRepository.updateRepo(index, memo);
      // fix: loadMemoCtr();
      memoList[index] = memo;
    } catch (e) {
      _errorMessage('Failed to update memo: $e');
    } finally {
      _isLoading(false);
    }
  }

  // delete
  void deleteCtr({required int index}) async {
    _isLoading(true);
    try {
      await _memoRepository.deleteRepo(index);
      // fix: loadMemoCtr();
      memoList.removeAt(index);
    } catch (e) {
      _errorMessage('Failed to delete memo: $e');
    } finally {
      _isLoading(false);
    }
  }
}
