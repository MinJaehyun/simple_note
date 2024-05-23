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
  // note: null 또는 String 이 들어오므로 dynamic 처리. late dynamic
  // late var classifiedMemo;

  // var test;

  late String _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = '미분류';
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              // note: 모든, 미분류
              ValueListenableBuilder(
                valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
                builder: (context, Box<MemoModel> box, _) {
                  // note: 미분류 메모
                  var unclassifiedMemo = box.values.toList().where((item) => item.selectedCategory == '미분류');
                  // print('unclassifiedMemo ${unclassifiedMemo.last.selectedCategory}');
                  // note: 분류된 메모 - err : 아래 기능 오류..
                  var classifiedMemo = box.values.where((item) => item.selectedCategory == selectedCategory);
                  // print('classifiedMemo: ${classifiedMemo}');

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
                              selectedCategory = currentContact!.categories;

                              // print('currentContact: ${currentContact.categories}'); // 생성된 카테고리 인스턴스 2개
                              // print('selectedCategory: $selectedCategory'); // qwewq, test

                              return Card(
                                child: ListTile(
                                  title: Text('${currentContact.categories.toString()} (${classifiedMemo.length})', style: style),
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

  Future<void> deletePopupDialog(BuildContext context, int index, classifiedMemo) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("범주를 삭제 하시겠습니까?"),
          content: Text("이 범주의 모든 내용은 '미분류'로 이동됩니다."),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('삭제'),
              onPressed: () {
                // todo: error: 범주 삭제 시 관련 메모 모두 삭제 실패
                // for (var memo in classifiedMemo)
                //   HiveHelperMemo().updateMemo(
                //     index: index,
                //     createdAt: memo.createdAt,
                //     title: memo.title,
                //     mainText: memo.mainText,
                //     selectedCategory: _dropdownValue,
                //   );
                // setState(() {});

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
