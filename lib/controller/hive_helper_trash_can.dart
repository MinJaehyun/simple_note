import 'package:hive/hive.dart';
import 'package:simple_note/model/trash_can.dart';

const String TrashCanBox = 'TRASHCAN_BOX';

class HiveHelperTrashCan {
  static final HiveHelperTrashCan _singleton = HiveHelperTrashCan._internal();

  factory HiveHelperTrashCan() {
    return _singleton;
  }

  HiveHelperTrashCan._internal();

  Box<TrashCanModel>? trashCanBox;

  Future openBox() async {
    trashCanBox = await Hive.openBox(TrashCanBox);
  }

  // note: CRUD
  Future read() async {
    return trashCanBox!.values.toList();
  }

  // todo: 추후: 시작과 끝나는 시간 속성 넣기 DateTime startTime, DateTime endTime :
  Future addMemo({
    required DateTime createdAt,
    required String title,
    String? mainText,
    String? selectedCategory,
    bool isFavoriteMemo = false,
  }) async {
    return trashCanBox!.add(TrashCanModel(
      createdAt: createdAt,
      title: title,
      mainText: mainText,
      selectedCategory: selectedCategory,
      isFavoriteMemo: isFavoriteMemo,
    ));
  }

  Future updateMemo({
    required index,
    required DateTime createdAt,
    required String title,
    String? selectedCategory,
    String? mainText,
    bool isFavoriteMemo = false,
  }) async {
    trashCanBox!.putAt(
      index,
      TrashCanModel(
        createdAt: createdAt,
        title: title,
        mainText: mainText,
        selectedCategory: selectedCategory,
        isFavoriteMemo: isFavoriteMemo,
      ),
    );
  }

  Future delete(int index) async {
    trashCanBox!.deleteAt(index);
  }
}
