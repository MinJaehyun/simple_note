import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
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

  // late var unclassifiedMemo;
  // late List<MemoModel> classifiedMemo;
  late List<MemoModel> classifiedMemo = [];

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  /** note: 함수 내에서 setState 호출이 WidgetsBinding.instance.addPostFrameCallback를 사용하여 현재 프레임이 끝난 후에 실행되도록 하였습니다.
  이로 인해 setState가 안전하게 호출되며, 빌드 중에 상태가 변경되는 문제를 피할 수 있습니다.
  **/
  void updateClassifiedMemo() {
    if (selectedCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          classifiedMemo = Hive.box<MemoModel>(MemoBox)
              .values
              .where((item) => item.selectedCategory == selectedCategory)
              .toList();
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
          onPressed: () => addPopupDialog(context),
          label: const Text('범주 만들기'),
        ),
        appBar: AppBar(title: Text('Simple Note', style: style), centerTitle: true),
        // note: body
        body: SingleChildScrollView(
          child: Column(
            children: [
              // note: 모든, 미분류
              ValueListenableBuilder(
                valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
                builder: (context, Box<MemoModel> box, _) {
                  // note: 미분류 메모
                  var unclassifiedMemo = box.values.toList().where((item) => item.selectedCategory == '미분류');
                  // note: 분류된 메모 - err: 기능 오류
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
                  if (box.values.isEmpty)
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: 200),
                          Text('하단 버튼을 클릭하면 범주를 생성할 수 있습니다.'),
                        ],
                      ),
                    );
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
                          title: Text('${currentContact.categories} (${Hive.box<MemoModel>(MemoBox).values.where((item) => item.selectedCategory == categoryTitle).length})', style: style),
                          trailing: Column(
                            children: [
                              PopupMenuButton<CategoriesItem>(
                                initialValue: categoriesItem,
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<CategoriesItem>>[
                                  PopupMenuItem<CategoriesItem>(
                                    onTap: () => updatePopupDialog(context, index, currentContact),
                                    value: CategoriesItem.update,
                                    child: Text('수정'),
                                  ),
                                  PopupMenuItem<CategoriesItem>(
                                    // todo: index 는 위에 범주 index 이고, 메모의 index를 가져와야 한다..
                                    onTap: () => deletePopupDialog(context, index, classifiedMemo),
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
            ],
          ),
        ),
        // note: public_footer/navigation_bar
        bottomNavigationBar: FooterNavigationBarWidget(1),
      ),
    );
  }

  // todo: add_category 분리하기
  Future<void> addPopupDialog(BuildContext context) {
    // note: 순서: 범주 생성 시, 이전 범주값(String = '')은 지운다.
    // note: categoryController.clear() 처리하면 null값이 찍히는게 아니라 아예 값이 없다 - 이 의미는 String 값이 ''이므로 console에 아무값도 찍히지 않느다.
    // note: 문자열 길이가 0임을 확인 - isEmpty
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
              if (!value.isEmpty) {
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
                  categoryController.text = '';
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
          title: Text('중복된 범주로 변경할 수 없습니다'),
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
                HiveHelperCategory().update(index: index, data: category!);
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

  Future<void> deletePopupDialog(BuildContext context, int index, List<MemoModel> classifiedMemo) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("범주를 삭제 하시겠습니까?"),
          content: Text("이 범주의 모든 내용은 '미분류'로 이동 됩니다."),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('삭제'),
              onPressed: () {
                var box = Hive.box<MemoModel>(MemoBox);
                List<MemoModel> memosToUpdate = box.values.where((memo) => memo.selectedCategory == selectedCategory).toList();

                // 각 메모의 범주를 '미분류'로 업데이트
                for (var memo in memosToUpdate) {
                  var memoIndex = box.values.toList().indexOf(memo);
                  box.putAt(memoIndex, MemoModel(createdAt: memo.createdAt, title: memo.title, mainText: memo.mainText, selectedCategory: '미분류'));
                }

                // 카테고리 삭제
                HiveHelperCategory().delete(index);
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
