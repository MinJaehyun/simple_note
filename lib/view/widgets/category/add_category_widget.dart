import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/category_controller.dart';

class AddCategoryWidget extends StatefulWidget {
  const AddCategoryWidget(this.context, {super.key});

  final BuildContext context;

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final TextEditingController categoryController = TextEditingController();
  String? category;
  final _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('새로운 범주 추가'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('중복으로 범주를 추가할 수 없습니다', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 10),
          TextField(
            maxLength: 17,
            controller: categoryController,
            decoration: const InputDecoration(
              hintText: '범주를 입력해 주세요',
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                category = value;
              }
            },
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
            if (categoryController.text.isNotEmpty) {
              _categoryController.addCtr(category);
              categoryController.text = '';
              // categoryController.clear(); // 위 대신 이거 사용해보기
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

// note: 특징: 소문자 함수를 위젯으로 분리하여 가져올 수 있다
Future<void> showAddPopupDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) {
      return AddCategoryWidget(context);
    },
  );
}
