import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/helper/hive_helper_category.dart';
import 'package:simple_note/model/category.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  String? category;

  Future<void> popupShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('범주 추가'),
          content: TextField(
            decoration: InputDecoration(
              hintText: '범주를 입력해 주세요'
            ),
            onChanged: (value) {
              category = value;
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
                HiveHelperCategory().create(category!);
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
          onPressed: () => popupShowDialog(context),
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
                    title: Text(currentContact!.categories),
                    leading: Icon(Icons.menu),
                    trailing: Icon(Icons.more_vert),
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
