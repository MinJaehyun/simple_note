import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/const/colors.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/view/screens/public/w_banner_ad.dart';
import 'package:simple_note/repository/local_data_source/category_repository.dart';
import 'package:simple_note/repository/local_data_source/memo_repository.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/category/w_category/w_add_category.dart';
import 'package:simple_note/view/screens/category/w_category/w_delete_category.dart';
import 'package:simple_note/view/screens/category/w_category/w_update_category.dart';
import 'package:simple_note/view/screens/public/w_footer_navigation_bar.dart';

enum CategoriesItem { update, delete }

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final memoController = Get.find<MemoController>();
  late List<MemoModel> classifiedMemo = [];
  CategoriesItem? categoriesItem; // note: enum은 정한 상태가 아니므로 ? 처리
  String? selectedCategory;

  // note: 함수 내에서 setState가 안전하게 호출될 수 있도록 WidgetsBinding.instance.addPostFrameCallback를 사용하여 현재 프레임이 끝난 후에 실행되도록 하였습니다. 이로인해 빌드 중에 상태가 변경되는 문제를 피할 수 있습니다.
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
          label: const Text('+ 범주'),
        ),
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: BannerAdWidget(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // note: 모든, 미분류
              Obx(
                () {
                  // note: 미분류 메모: unclassifiedMemo 는 해당 ValueListenableBuilder 내에서만 사용할 것이므로 변수 타입 선언
                  List<MemoModel> unclassifiedMemo = memoController.memoList.where((item) => item.selectedCategory == '미분류').toList();

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
                      Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: getRandomNeonColor(), width: 2),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListTile(
                              title: Row(
                        children: [
                          Text('모든 ', style: style),
                          Text('(${memoController.memoList.length})', style: const TextStyle(color: Colors.redAccent)),
                        ],
                      ))),
                      Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: getRandomNeonColor(), width: 2),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListTile(
                              title: Row(
                        children: [
                          Text('미분류 ', style: style),
                          Text('(${unclassifiedMemo.length})', style: const TextStyle(color: Colors.redAccent)),
                        ],
                      ))),
                    ],
                  );
                },
              ),

              // note: 생성한 카테고리 목록
              // todo: 아래 ValueListenableBuilder의 box는 사용중이므로 추후, 리펙토링하기
              ValueListenableBuilder(
                valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
                builder: (context, Box<CategoryModel> box, _) {
                  if (box.values.isEmpty) {
                    return const Center(
                        child: Column(
                      children: [SizedBox(height: 200), Text('범주를 생성할 수 있습니다.')],
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
                            key: UniqueKey(),
                            background: Container(
                              color: Colors.red,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [Icon(Icons.cancel), SizedBox(width: 35)],
                              ),
                            ),
                            // note: 삭제 확인 dialog
                            confirmDismiss: (direction) async {
                              bool? result = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("삭제 확인"),
                                    content: const Text("정말로 삭제하시겠습니까?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text("삭제"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("취소"),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return result;
                            },
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
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: getRandomNeonColor(), width: 2),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              key: ValueKey(index),
                              child: ListTile(
                                onTap: () {
                                  if (selectedCategory != null) {
                                    selectedCategory = box.getAt(index)!.categories!;
                                  }
                                  updateClassifiedMemo();
                                },
                                leading: const Icon(Icons.import_export_sharp),
                                title: Row(
                                  children: [
                                    Text('${box.getAt(index)!.categories} ', style: style),
                                    Text(
                                        '(${Hive.box<MemoModel>(MemoBox).values.where((item) => item.selectedCategory == box.getAt(index)!.categories).length})',
                                        style: const TextStyle(color: Colors.redAccent)),
                                  ],
                                ),
                                trailing: Column(
                                  children: [
                                    PopupMenuButton<CategoriesItem>(
                                      initialValue: categoriesItem,
                                      itemBuilder: (BuildContext context) => <PopupMenuEntry<CategoriesItem>>[
                                        PopupMenuItem<CategoriesItem>(
                                          onTap: () => showUpdatePopupDialog(context, index, box.getAt(index)!),
                                          value: CategoriesItem.update,
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [Text('수정'), Icon(Icons.create_outlined)],
                                          ),
                                        ),
                                        PopupMenuItem<CategoriesItem>(
                                          onTap: () => showDeletePopupDialog(context, index),
                                          value: CategoriesItem.delete,
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('삭제', style: TextStyle(color: Colors.red)),
                                              Icon(Icons.delete_outline, color: Colors.red)
                                            ],
                                          ),
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
