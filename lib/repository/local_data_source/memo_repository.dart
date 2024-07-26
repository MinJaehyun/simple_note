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

  // note: main에서 즉시 호출함
  Future openBox() async {
    memoBox = await Hive.openBox<MemoModel>(MemoBox);
  }

  // note: CRUD
  // read
  Future<List<MemoModel>> getAllMemoRepo() async {
    return memoBox!.values.toList();
  }

  // note: MemoRepository는 데이터 접근 및 저장만을 담당하도록 설계함.
  // add
  Future<void> addMemoRepo(MemoModel memo) async {
    if (memoBox == null) {
      await openBox();
    }
    try {
      await memoBox!.add(memo);
    } catch (e) {
      print(e);
    }
  }

  // update
  Future<void> updateRepo(int index, MemoModel memo) async {
    if (memoBox == null) {
      await openBox();
    }
    await memoBox!.putAt(index, memo);
  }

  // delete
  Future deleteRepo(int index) async {
    await memoBox!.deleteAt(index);
  }

  // close box: 앱 종료 시 closeBox 호출: 미사용
  Future closeBox() async {
    await memoBox?.close();
  }
}
