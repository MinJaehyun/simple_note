import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/model/category.dart';


enum CategoriesItem {update, delete}

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryController = TextEditingController();
  String? category;
  CategoriesItem? categoriesItem;

  // todo: add_category 분리하기
  Future<void> addPopupDialog(BuildContext context) {
    // note: 순서: 범주 생성 시, 이전 범주값(String = '')은 지운다.
    // note: categoryController.clear() 처리하면 null값이 찍히는게 아니라 아예 값이 없다 - 이 의미는 String 값이 ''이므로 console에 아무값도 찍히지 않느다.
    // note: 문자열 길이가 0임을 확인 - isEmpty
    categoryController.clear();
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('범주 추가'),
          content: TextField(
            controller: categoryController,
            decoration: InputDecoration(
              hintText: '범주를 입력해 주세요',
            ),
            onChanged: (value) {
              if(!value.isEmpty) {
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
              child: const Text('저장'),
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  HiveHelperCategory().create(category!);
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
      },
    );
  }

  // todo: update_category 분리하기
  Future<void> updatePopupDialog(BuildContext context, int index, currentContact) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('범주 이름 변경'),
          content: TextFormField(
            decoration: InputDecoration(
              hintText: '범주를 입력해 주세요',
            ),
            onChanged: (value) {
              category = value;
            },
            autofocus: true,
            initialValue: currentContact?.categories.toString(),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('저장'),
              onPressed: () {
                HiveHelperCategory().update(index: index, categories: category!);
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => addPopupDialog(context),
          label: const Text('범주 생성'),
          icon: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('범주'),
          backgroundColor: Colors.green,
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
          builder: (context, Box<CategoryModel> box, _) {
            if (box.values.isEmpty)
              return Center(child: Text('하단 버튼을 클릭하여 범주를 생성해 주세요'));
            return ListView.builder(
              itemCount: box.values.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                CategoryModel? currentContact = box.getAt(index);
                return Card(
                  child: ListTile(
                    title: Text(currentContact!.categories.toString()),
                    leading: Icon(Icons.menu),
                    trailing: Column(
                      children: [
                        PopupMenuButton<CategoriesItem>(
                          initialValue: categoriesItem,
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<CategoriesItem>>[
                            PopupMenuItem<CategoriesItem>(
                              onTap: () => updatePopupDialog(context, index, currentContact),
                              value: CategoriesItem.update,
                              child: Text('수정'),
                            ),
                            PopupMenuItem<CategoriesItem>(
                              onTap: () => HiveHelperCategory().delete(index),
                              value: CategoriesItem.delete,
                              child: Text('삭제'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
