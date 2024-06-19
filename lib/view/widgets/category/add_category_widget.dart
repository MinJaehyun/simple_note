import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/category_controller.dart';

// note: 특징: showAddPopupDialog() 함수는 공통적으로 가져오는 곳이 많으므로 분리하여 효율적으로 사용함.
Future<void> showAddPopupDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) {
      return AddCategoryWidget(context);
    },
  );
}

class AddCategoryWidget extends StatefulWidget {
  const AddCategoryWidget(this.context, {super.key});

  final BuildContext context;

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final TextEditingController _textController = TextEditingController();
  final _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('새로운 범주 추가'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          TextField(
            maxLength: 17,
            controller: _textController,
            decoration: const InputDecoration(
              hintText: '범주를 입력해 주세요',
            ),
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: () {
            var isDuplicate = false;
            for (var category in _categoryController.categoryList)
              if (category.categories! == _textController.text) {
                isDuplicate = true;
                break;
              }
            if (!isDuplicate) {
              _categoryController.addCtr(_textController.text);
              _textController.clear();
            } else {
              Get.snackbar(
                '오류',
                '이미 존재하는 범주입니다.',
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
      ],
    );
  }
}
