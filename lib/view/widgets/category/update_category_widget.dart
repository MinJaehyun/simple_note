import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/repository/local_data_source/memo_repository.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';


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
  String? category;

  @override
  void initState() {
    super.initState();
    category = widget.currentContact?.categories.toString();
  }

  @override
  Widget build(BuildContext context) {
    // note: 범주 탭할 때, selectedCategory가 적절히 업데이트되도록 하고, 단, 다이얼로그 내에서는 직접적으로 특정 범주를 참조 해야한다!
    // note: 아래 categories는 모델의 속성
    final categoryToUpdate = Hive.box<CategoryModel>(CategoryBox).getAt(widget.index)?.categories;

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
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('저장'),
          onPressed: () {
            if (categoryToUpdate != null) {
              HiveHelperCategory().update(index: widget.index, data: category!);

              Box<MemoModel> box = Hive.box<MemoModel>(MemoBox);
              List<MemoModel> memosToUpdate = box.values.where((memo) => memo.selectedCategory == categoryToUpdate).toList();

              for (MemoModel memo in memosToUpdate) {
                int memoIndex = box.values.toList().indexOf(memo);
                box.putAt(
                    memoIndex, MemoModel(createdAt: memo.createdAt, title: memo.title, mainText: memo.mainText, selectedCategory: category));
              }
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

// note: 실행되며, 위에 위젯을 호출한다
Future<void> showUpdatePopupDialog(BuildContext context, int index, dynamic currentContact) {
  return showDialog(
    context: context,
    builder: (context) {
      return UpdatePopupDialog(index, currentContact);
    },
  );
}
