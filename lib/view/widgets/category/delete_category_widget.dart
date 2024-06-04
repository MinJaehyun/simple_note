import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/repository/local_data_source/memo_repository.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';

class DeleteCategoryWidget extends StatefulWidget {
  const DeleteCategoryWidget(this.context, this.index,{super.key});

  final BuildContext context;
  final int index;

  @override
  State<DeleteCategoryWidget> createState() => _DeleteCategoryWidgetState();
}

class _DeleteCategoryWidgetState extends State<DeleteCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    // note: 범주 탭할 때, selectedCategory가 적절히 업데이트되도록 하고, 단, 다이얼로그 내에서는 직접적으로 특정 범주를 참조 해야한다!
    // note: 아래 categories는 모델의 속성
    final categoryToDelete = Hive.box<CategoryModel>(CategoryBox).getAt(widget.index)?.categories;
    // print(categoryToDelete); // 범주에서 선택한 카테고리 출력

    return AlertDialog(
      title: const Text("범주를 삭제 하시겠습니까?"),
      content: const Text("이 범주의 모든 내용은 '미분류'로 이동 됩니다."),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('삭제'),
          onPressed: () {
            if (categoryToDelete != null) {
              Box<MemoModel> box = Hive.box<MemoModel>(MemoBox);
              List<MemoModel> memosToUpdate = box.values.where((memo) => memo.selectedCategory == categoryToDelete).toList();
              // 각 메모의 범주를 '미분류'로 업데이트?
              for (MemoModel memo in memosToUpdate) {
                int memoIndex = box.values.toList().indexOf(memo);
                box.putAt(memoIndex, MemoModel(createdAt: memo.createdAt, title: memo.title, mainText: memo.mainText, selectedCategory: '미분류'));
              }
              // 카테고리 삭제
              HiveHelperCategory().delete(widget.index);
            }
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('취소'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

Future<void> showDeletePopupDialog(BuildContext context, int index) {
  return showDialog(
    context: context,
    builder: (context) {
      return DeleteCategoryWidget(context, index);
    },
  );
}