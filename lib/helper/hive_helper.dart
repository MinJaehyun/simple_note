import 'package:hive/hive.dart';
import 'package:simple_note/model/memo.dart';


const String MemoBox = 'Memo_Box';

class HiveHelper {
  static final HiveHelper _singleton = HiveHelper._internal();
  factory HiveHelper() {
    return _singleton;
  }
  HiveHelper._internal();

  Box<MemoModel>? memoBox;

  Future openBox() async {
    memoBox = await Hive.openBox(MemoBox);
  }

  // note: 이하 CRUD 및 필요한 api 만들기
  Future create(MemoModel memo) async {
    return memoBox!.add(memo);
  }

  Future read() async {
    return memoBox!.values.toList();
  }

  Future update(int index, MemoModel updateMomo) async {
    memoBox!.putAt(index, updateMomo);
  }

  Future delete(int index) async {
    memoBox!.delete(index);
  }
}