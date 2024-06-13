import 'package:hive/hive.dart';
import 'package:simple_note/model/trash_can.dart';

const String TrashCanBox = 'TRASHCAN_BOX';

class TrashCanMemoRepository {
  static final TrashCanMemoRepository _singleton = TrashCanMemoRepository._internal();

  factory TrashCanMemoRepository() {
    return _singleton;
  }

  TrashCanMemoRepository._internal();

  Box<TrashCanModel>? trashCanBox;

  Future openBox() async {
    trashCanBox = await Hive.openBox(TrashCanBox);
  }

  // note: CRUD
  // 미사용
  Future<List<TrashCanModel>> getAllMemoRepo() async {
    return trashCanBox!.values.toList();
  }

  // add: MemoRepository는 데이터 접근 및 저장만을 담당하도록 설계함.
  Future<void> addRepo(TrashCanModel memo) async {
    if (trashCanBox == null) {
      await openBox();
    }
    await trashCanBox!.add(memo);
  }

  // update
  Future<void> updateRepo(int index, TrashCanModel memo) async {
    await trashCanBox!.putAt(index, memo);
  }

  // delete
  Future deleteRepo(int index) async {
    trashCanBox!.deleteAt(index);
  }

  // All delete
  Future allDeleteRepo() async {
    trashCanBox!.clear();
  }
}
