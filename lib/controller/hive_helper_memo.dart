import 'package:hive/hive.dart';
import 'package:simple_note/model/memo.dart';

const String MemoBox = 'MEMO_BOX';

class HiveHelperMemo {
  static final HiveHelperMemo _singleton = HiveHelperMemo._internal();

  factory HiveHelperMemo() {
    return _singleton;
  }

  HiveHelperMemo._internal();

  Box<MemoModel>? memoBox;

  Future openBox() async {
    memoBox = await Hive.openBox<MemoModel>(MemoBox);
  }

  // note: CRUD
  Future read() async {
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

  // todo: mainText 수정하기 - 필수 요소 아니므로 required 제거하기
  // todo: 추후: 시작과 끝나는 시간 속성 넣기 DateTime startTime, DateTime endTime :
  Future addMemo({
    required DateTime createdAt,
    required String title,
    String? mainText,
    String? selectedCategory,
    bool isFavoriteMemo = false,
  }) async {
    if (memoBox == null) {
      await openBox();
    }
    final memo = MemoModel(
      createdAt: createdAt,
      title: title,
      mainText: mainText,
      selectedCategory: selectedCategory,
      isFavoriteMemo: isFavoriteMemo,
    );
    return memoBox!.add(memo);
  }

  Future updateMemo({
    required int index,
    required DateTime createdAt,
    required String title,
    String? selectedCategory,
    String? mainText,
    bool isFavoriteMemo = false,
  }) async {
    if (memoBox == null) {
      await openBox();
    }
    memoBox!.putAt(
      index,
      MemoModel(
        createdAt: createdAt,
        title: title,
        mainText: mainText,
        selectedCategory: selectedCategory,
        isFavoriteMemo: isFavoriteMemo,
      ),
    );
  }

  Future delete(int index) async {
    if (memoBox == null) {
      await openBox();
    }
    memoBox!.deleteAt(index);
  }
}
