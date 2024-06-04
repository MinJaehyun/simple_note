import 'package:hive/hive.dart';
import 'package:simple_note/model/memo.dart';

const String MemoBox = 'MEMO_BOX';

class MemoRepository {
  static final MemoRepository _singleton = MemoRepository._internal();

  factory MemoRepository() {
    return _singleton;
  }

  MemoRepository._internal();

  Box<MemoModel>? memoBox;

  Future openBox() async {
    memoBox = await Hive.openBox<MemoModel>(MemoBox);
  }

  // note: CRUD ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

  // 미사용
  Future<List<MemoModel>> getAllMemo() async {
    return memoBox!.values.toList();
  }

  // todo: 추후, 즐찾 페이지에 사용하기
  // Future<List<MemoModel>> readFavoriteMemo ({bool? isFavorite}) async {
  //   if (isFavorite == null) {
  //     return memoBox!.values.toList();
  //   } else {
  //     return memoBox!.values.where((memo) => memo.isFavorite == isFavorite).toList();
  //   }
  // }

  // 변경 전
  // Future addMemo({
  //   required DateTime createdAt,
  //   required String title,
  //   String? mainText,
  //   String? selectedCategory,
  //   bool isFavoriteMemo = false,
  // }) async {
  //   if (memoBox == null) {
  //     await openBox();
  //   }
  //   final memo = MemoModel(
  //     createdAt: createdAt,
  //     title: title,
  //     mainText: mainText,
  //     selectedCategory: selectedCategory,
  //     isFavoriteMemo: isFavoriteMemo,
  //   );
  //   return memoBox!.add(memo);
  // }

  // 변경 후
  // MemoRepository는 데이터 접근 및 저장만을 담당하도록 설계함.
  Future<void> addMemo(MemoModel memo) async {
    if (memoBox == null) {
      await openBox();
    }
    await memoBox!.add(memo);
  }

  // 변경 전: updataeMemo
  // Future updateMemo({
  //   required int index,
  //   required DateTime createdAt,
  //   required String title,
  //   String? selectedCategory,
  //   String? mainText,
  //   bool isFavoriteMemo = false,
  // }) async {
  //   if (memoBox == null) {
  //     await openBox();
  //   }
  //   memoBox!.putAt(
  //     index,
  //     MemoModel(
  //       createdAt: createdAt,
  //       title: title,
  //       mainText: mainText,
  //       selectedCategory: selectedCategory,
  //       isFavoriteMemo: isFavoriteMemo,
  //     ),
  //   );
  // }

  // ========================================================
  // 변경 후
  // Future updateMemo({
  //   required int index,
  //   required DateTime createdAt,
  //   required String title,
  //   String? selectedCategory,
  //   String? mainText,
  //   bool isFavoriteMemo = false,
  // }) async {
  //   if (memoBox == null) {
  //     await openBox();
  //   }
  //   memoBox!.putAt(
  //     index,
  //     MemoModel(
  //       createdAt: createdAt,
  //       title: title,
  //       mainText: mainText,
  //       selectedCategory: selectedCategory,
  //       isFavoriteMemo: isFavoriteMemo,
  //     ),
  //   );
  // }

  // 변경 후
  Future<void> updateMemo(int index, MemoModel memo) async {
    await memoBox!.putAt(index, memo);
  }

  // delete
  Future delete(int index) async {
    await memoBox!.deleteAt(index);
  }
}
