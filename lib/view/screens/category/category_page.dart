import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/widgets/category/add_category_widget.dart';
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
  String? category;
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
          onPressed: () => addCategoryWidget(context),
          label: const Text('범주 만들기'),
        ),
        appBar: AppBar(title: Text('Simple Note', style: style), centerTitle: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // note: 모든, 미분류
              ValueListenableBuilder(
                valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
                builder: (context, Box<MemoModel> box, _) {
                  // note: 미분류 메모: unclassifiedMemo 는 해당 ValueListenableBuilder 내에서만 사용할 것이므로 변수 타입 선언
                  var unclassifiedMemo = box.values.toList().where((item) => item.selectedCategory == '미분류');
                  // note: 분류된 메모 - err: 기능 오류인 이유? var를 밖에 선언하고 다른 ValueListenableBuilder에서 사용하면 에러난다!
                  // classifiedMemo = box.values.where((item) => item.selectedCategory == selectedCategory).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsets.all(20.0), child: Text('범주', style: style)),
                      Card(
                        child: ListTile(
                          // leading: Icon(Icons.menu),
                          title: Text('모든 (${box.values.length})', style: style),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          // leading: Icon(Icons.menu),
                          title: Text('미분류 (${unclassifiedMemo.length})', style: style),
                        ),
                      ),
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
                        children: [
                          SizedBox(height: 200),
                          Text('하단 버튼을 클릭하면 범주를 생성할 수 있습니다.'),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: box.values.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      CategoryModel? currentContact = box.getAt(index);
                      String? categoryTitle = currentContact!.categories;
                      // Update the selected category and classified memos
                      selectedCategory = categoryTitle;
                      updateClassifiedMemo();

                      return Card(
                        child: ListTile(
                          // fix
                          onTap: () {
                            setState(() {
                              selectedCategory = categoryTitle;
                            });
                            updateClassifiedMemo();
                          },
                          // fix
                          // title: Text('${currentContact.categories.toString()} (${classifiedMemo.length})', style: style),
                          title: Text(
                              '${currentContact.categories} (${Hive.box<MemoModel>(MemoBox).values.where((item) => item.selectedCategory == categoryTitle).length})',
                              style: style),
                          trailing: Column(
                            children: [
                              PopupMenuButton<CategoriesItem>(
                                initialValue: categoriesItem,
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<CategoriesItem>>[
                                  PopupMenuItem<CategoriesItem>(
                                    onTap: () => updatePopupDialog(context, index, currentContact),
                                    value: CategoriesItem.update,
                                    child: const Text('수정'),
                                  ),
                                  PopupMenuItem<CategoriesItem>(
                                    // todo: index 는 위에 범주 index 이고, 메모의 index를 가져와야 한다..
                                    onTap: () => deletePopupDialog(context, index),
                                    value: CategoriesItem.delete,
                                    child: const Text('삭제'),
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
            ],
          ),
        ),
        // note: public_footer/navigation_bar
        bottomNavigationBar: const FooterNavigationBarWidget(1),
      ),
    );
  }

  // todo: update_category 분리하기
  Future<void> updatePopupDialog(BuildContext context, int index, currentContact) {
    // note: 범주 탭할 때, selectedCategory가 적절히 업데이트되도록 하고, 단, 다이얼로그 내에서는 직접적으로 특정 범주를 참조 해야한다!
    // note: 아래 categories는 모델의 속성
    final categoryToUpdate = Hive.box<CategoryModel>(CategoryBox).getAt(index)?.categories;

    return showDialog(
      context: context,
      builder: (_) {
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
            initialValue: currentContact?.categories.toString(),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('저장'),
              onPressed: () {
                if (categoryToUpdate != null) {
                  HiveHelperCategory().update(index: index, data: category!);

                  var box = Hive.box<MemoModel>(MemoBox);
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
      },
    );
  }

  Future<void> deletePopupDialog(BuildContext context, int index) {
    // note: 범주 탭할 때, selectedCategory가 적절히 업데이트되도록 하고, 단, 다이얼로그 내에서는 직접적으로 특정 범주를 참조 해야한다!
    // note: 아래 categories는 모델의 속성
    final categoryToDelete = Hive.box<CategoryModel>(CategoryBox).getAt(index)?.categories;
    // print(categoryToDelete); // 범주에서 선택한 카테고리 출력

    return showDialog(
      context: context,
      builder: (context) {
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
                if (categoryToDelete != null) {
                  var box = Hive.box<MemoModel>(MemoBox);
                  List<MemoModel> memosToUpdate = box.values.where((memo) => memo.selectedCategory == categoryToDelete).toList();
                  // 각 메모의 범주를 '미분류'로 업데이트?
                  for (MemoModel memo in memosToUpdate) {
                    int memoIndex = box.values.toList().indexOf(memo);
                    box.putAt(memoIndex, MemoModel(createdAt: memo.createdAt, title: memo.title, mainText: memo.mainText, selectedCategory: '미분류'));
                  }
                  // 카테고리 삭제
                  HiveHelperCategory().delete(index);
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
}
