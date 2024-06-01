import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/widgets/category/add_category_widget.dart';
import 'package:simple_note/view/widgets/category/delete_category_widget.dart';
import 'package:simple_note/view/widgets/category/update_category_widget.dart';
import 'package:simple_note/view/widgets/public/footer_navigation_bar_widget.dart';

enum CategoriesItem { update, delete }

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // note: enum 정해지지 않은 상태이므로 ?처리.
  CategoriesItem? categoriesItem;
  TextEditingController categoryController = TextEditingController();
  String? selectedCategory;

  late List<MemoModel> classifiedMemo = [];

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  /* note: 함수 내에서 setState 호출이 WidgetsBinding.instance.addPostFrameCallback를 사용하여 현재 프레임이 끝난 후에 실행되도록 하였습니다.
  이로 인해 setState가 안전하게 호출되며, 빌드 중에 상태가 변경되는 문제를 피할 수 있습니다.
  */
  void updateClassifiedMemo() {
    if (selectedCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          classifiedMemo = Hive.box<MemoModel>(MemoBox).values.where((item) => item.selectedCategory == selectedCategory).toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: Theme.of(context).colorScheme.primary);

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showAddPopupDialog(context),
          label: const Text('범주 만들기'),
        ),
        appBar: AppBar(
            // title: Text('Simple Note', style: style),
            // centerTitle: true,
            ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // note: 모든, 미분류
              ValueListenableBuilder(
                valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
                builder: (context, Box<MemoModel> box, _) {
                  // note: 미분류 메모: unclassifiedMemo 는 해당 ValueListenableBuilder 내에서만 사용할 것이므로 변수 타입 선언
                  List<MemoModel> unclassifiedMemo = box.values.toList().where((item) => item.selectedCategory == '미분류').toList();
                  // note: 분류된 메모 - err: 기능 오류인 이유? var를 밖에 선언하고 다른 ValueListenableBuilder에서 사용하면 에러난다!
                  // classifiedMemo = box.values.where((item) => item.selectedCategory == selectedCategory).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          '범주',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                      Card(child: ListTile(title: Text('모든 (${box.values.length})', style: style))),
                      Card(child: ListTile(title: Text('미분류 (${unclassifiedMemo.length})', style: style))),
                    ],
                  );
                },
              ),

              // note: 생성한 카테고리 목록
              ValueListenableBuilder(
                valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
                builder: (context, Box<CategoryModel> box, _) {
                  if (box.values.isEmpty) {
                    return const Center(
                        child: Column(
                      children: [SizedBox(height: 200), Text('하단 버튼을 클릭하면 범주를 생성할 수 있습니다.')],
                    ));
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6, // 적절한 높이 설정
                    child: ReorderableListView(
                      shrinkWrap: true,
                      onReorder: (int oldIndex, int newIndex) async {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        // 카테고리 순서 변경
                        List<CategoryModel> newList = box.values.toList();
                        CategoryModel movedItem = newList.removeAt(oldIndex);
                        newList.insert(newIndex, movedItem);
                        await box.clear();
                        await box.addAll(newList);
                      },
                      children: [
                        for (int index = 0; index < box.values.length; index++)
                          Dismissible(
                            key: UniqueKey(), // Use UniqueKey for each Dismissible to avoid issues with duplicate keys
                            onDismissed: (direction) async {
                              // Delete the category and associated memos
                              final categoryToDelete = box.getAt(index)!;
                              await box.deleteAt(index);
                              // Delete associated memos
                              List<MemoModel> memosToDelete =
                                  Hive.box<MemoModel>(MemoBox).values.where((memo) => memo.selectedCategory == categoryToDelete.categories).toList();
                              for (MemoModel memo in memosToDelete) {
                                await memo.delete();
                              }
                            },
                            child: Card(
                              key: ValueKey(index),
                              child: ListTile(
                                onTap: () {
                                  if (selectedCategory != null) {
                                      selectedCategory = box.getAt(index)!.categories!;
                                  }
                                  updateClassifiedMemo();
                                },
                                leading: const Icon(Icons.menu),
                                title: Text(
                                    '${box.getAt(index)!.categories} (${Hive.box<MemoModel>(MemoBox).values.where((item) => item.selectedCategory == box.getAt(index)!.categories).length})',
                                    style: style),
                                trailing: Column(
                                  children: [
                                    PopupMenuButton<CategoriesItem>(
                                      initialValue: categoriesItem,
                                      itemBuilder: (BuildContext context) => <PopupMenuEntry<CategoriesItem>>[
                                        PopupMenuItem<CategoriesItem>(
                                          onTap: () => showUpdatePopupDialog(context, index, box.getAt(index)!),
                                          value: CategoriesItem.update,
                                          child: const Text('수정'),
                                        ),
                                        PopupMenuItem<CategoriesItem>(
                                          // todo: index 는 위에 범주 index 이고, 메모의 index를 가져와야 한다..
                                          onTap: () => showDeletePopupDialog(context, index),
                                          value: CategoriesItem.delete,
                                          child: const Text('삭제'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // note: public_footer/navigation_bar
        bottomNavigationBar: const FooterNavigationBarWidget(1),
      ),
    );
  }
}
