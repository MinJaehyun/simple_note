import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/category_controller.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/model/memo.dart';

// note: 실행되며, 위젯을 호출한다
Future<void> showUpdatePopupDialog(BuildContext context, int index, dynamic currentContact) {
  return showDialog(
    context: context,
    builder: (context) {
      return UpdatePopupDialog(index, currentContact);
    },
  );
}

// 함수가 호출되고 아래 위젯이 호출되는 구조인 이유는?
// note: showDialog는 build 메서드 내에서 호출되지 않으므로, 다이얼로그를 표시하는 전용 함수를 만들어 호출해야하기 때문이다.
class UpdatePopupDialog extends StatefulWidget {
  const UpdatePopupDialog(this.index, this.currentContact, {super.key});

  final int index;
  final dynamic currentContact;

  @override
  State<UpdatePopupDialog> createState() => _UpdatePopupDialogState();
}

class _UpdatePopupDialogState extends State<UpdatePopupDialog> {
  final _categoryController = Get.find<CategoryController>();
  final _memoController = Get.find<MemoController>();
  late String? category;
  late final categoryToUpdate;

  @override
  void initState() {
    super.initState();
    categoryToUpdate = _categoryController.categoryList[widget.index].categories;
    category = widget.currentContact?.categories.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('중복된 범주로 변경할 수 없습니다'),
      content: TextFormField(
        decoration: const InputDecoration(
          hintText: '범주를 입력해 주세요',
        ),
        onChanged: (value) {
          category = value;
        },
        autofocus: true,
        initialValue: widget.currentContact?.categories.toString(),
        maxLength: 17,
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
          onPressed: () {
            var isDuplicate = false;
            for (var categories in _categoryController.categoryList) {
              if (categories.categories! == category) {
                isDuplicate = true;
                break;
              }
            }
            if (!isDuplicate) {
              if (categoryToUpdate != null) {
                _categoryController.updateCtr(widget.index, category!);
                List<MemoModel> memosToUpdate = _memoController.memoList.where((memo) => memo.selectedCategory == categoryToUpdate).toList();

                for (MemoModel memo in memosToUpdate) {
                  int memoIndex = _memoController.memoList.indexOf(memo);
                  _memoController.updateCtr(
                    index: memoIndex,
                    createdAt: memo.createdAt,
                    title: memo.title,
                    mainText: memo.mainText,
                    selectedCategory: category,
                  );
                }
              }
            } else {
              Get.snackbar(
                '오류',
                '이미 존재하는 범주입니다.',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            }
            Navigator.of(context).pop();
          },
          child: const Text('저장'),
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
