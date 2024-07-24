import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/category_controller.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/model/memo.dart';

Future<void> showDeletePopupDialog(BuildContext context, int index) {
  return showDialog(
    context: context,
    builder: (context) {
      return DeleteCategoryWidget(context, index);
    },
  );
}

class DeleteCategoryWidget extends StatefulWidget {
  const DeleteCategoryWidget(this.context, this.index, {super.key});

  final BuildContext context;
  final int index;

  @override
  State<DeleteCategoryWidget> createState() => _DeleteCategoryWidgetState();
}

class _DeleteCategoryWidgetState extends State<DeleteCategoryWidget> {
  final _categoryController = Get.find<CategoryController>();
  final _memoController = Get.find<MemoController>();
  late String? categoryToDelete;

  @override
  void initState() {
    super.initState();
    categoryToDelete = _categoryController.categoryList[widget.index].categories;
  }

  void _deleteCategoryAndMoveMemos() {
    if (categoryToDelete == null) return;

    List<MemoModel> memosToUpdate = _memoController.memoList.where((memo) => memo.selectedCategory == categoryToDelete).toList();
    for (MemoModel memo in memosToUpdate) {
      int memoIndex = _memoController.memoList.toList().indexOf(memo);
      _memoController.updateCtr(
        index: memoIndex,
        createdAt: memo.createdAt,
        title: memo.title,
        mainText: memo.mainText,
        selectedCategory: '미분류',
        isFavoriteMemo: memo.isFavoriteMemo ?? false,
        isCheckedTodo: memo.isCheckedTodo ?? false,
        imagePath: File(memo.imagePath!),
      );
    }
    _categoryController.deleteCtr(index: widget.index);
  }

  @override
  Widget build(BuildContext context) {
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
            _deleteCategoryAndMoveMemos();
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
