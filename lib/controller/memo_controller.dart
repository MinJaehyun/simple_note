import 'dart:io';

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
    loadMemoCtr();
  }

  void loadMemoCtr() async {
    isLoading(true);
    try {
      var memos = await _memoRepository.getAllMemoRepo();
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
    isLoading(true);
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
      // 메모 추가 후 다시 로드하여 목록 업데이트
      loadMemoCtr();
    } catch (e) {
      errorMessage('Failed to add memo: $e');
    } finally {
      isLoading(false);
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
    isLoading(true);
    try {
      final memo = MemoModel(
        createdAt: createdAt,
        title: title,
        mainText: mainText,
        selectedCategory: selectedCategory,
        isFavoriteMemo: isFavoriteMemo,
        isCheckedTodo: isCheckedTodo,
        imagePath: imagePath?.path,
      );
      await _memoRepository.updateRepo(index, memo);
      loadMemoCtr();
    } catch (e) {
      errorMessage('Failed to update memo: $e');
    } finally {
      isLoading(false);
    }
  }

  // delete
  void deleteCtr({required int index}) async {
    isLoading(true);
    try {
      await _memoRepository.deleteRepo(index);
      loadMemoCtr(); // 메모 삭제 후 다시 로드하여 목록 업데이트
    } catch (e) {
      errorMessage('Failed to delete memo: $e');
    } finally {
      isLoading(false);
    }
  }
}
