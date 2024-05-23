import 'package:flutter/material.dart';
import 'package:simple_note/controller/hive_helper_category.dart';

Future<void> addCategoryWidget(BuildContext context) {
  final TextEditingController categoryController = TextEditingController();
  String? category;
  // note: 순서: 범주 생성 시, 이전 범주값(String = '')은 지운다.
  // note: categoryController.clear() 처리하면 null값이 찍히는게 아니라 아예 값이 없다 - 이 의미는 String 값이 ''이므로 console에 아무값도 찍히지 않느다.
  // note: 문자열 길이가 0임을 확인 - isEmpty
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text('새로운 범주 추가'),
        content: TextField(
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
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                HiveHelperCategory().create(category!);
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
    },
  );
}
