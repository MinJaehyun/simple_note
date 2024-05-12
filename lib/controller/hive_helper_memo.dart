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
    memoBox = await Hive.openBox(MemoBox);
  }

  // note: CRUD
  Future read() async {
    return memoBox!.values.toList();
  }

  Future addMemo(String selectedCategory, {required String title, required DateTime time, required String mainText}) async {
    return memoBox!.add(MemoModel(selectedCategory, time: time, title: title, mainText: mainText));
  }

  Future updateMemo(String selectedCategory, {required index, required String title, required DateTime time, required String mainText}) async {
    memoBox!.putAt(index, MemoModel(selectedCategory, time: time, title: title, mainText: mainText));
  }

  // Future addMemo({required String title, required DateTime time, required String mainText, required String category}) async {
  //   return memoBox!.add(MemoModel(time: time, title: title, mainText: mainText, category: category));
  // }
  //
  // Future updateMemo({required index, required String title, required DateTime time, required String mainText, required String category}) async {
  //   memoBox!.putAt(index, MemoModel(time: time, title: title, mainText: mainText, category: category));
  // }

  Future delete(int index) async {
    memoBox!.deleteAt(index);
  }

  // note: 미사용
  // Future create(MemoModel memo) async {
  //   return memoBox!.add(memo);
  // }

  // note: 미사용
  // Future update(int index, MemoModel updateMomo) async {
  //   memoBox!.putAt(index, updateMomo);
  // }
}