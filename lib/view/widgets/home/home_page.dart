import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/widgets/home/home_search.dart';
import 'package:simple_note/view/widgets/home/home_selected_category.dart';
import 'package:simple_note/view/widgets/home/home_body_card.dart';
import 'package:simple_note/controller/hive_helper_category.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;
  var searchedTitle;
  var searchedMainText;
  String? searchControllerText;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: Theme.of(context).colorScheme.primary);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
            builder: (context, Box<CategoryModel> box, _) {
              // if (box.values.isEmpty) return Center(child: Text('범주를 생성해 주세요'));
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 148,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // 상단: 모든, 미분류, 검색창
                            Container(
                              child: Row(
                                children: [
                                  // 상단1~2 모든, 미분류 박스
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Card(
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                setState(() {
                                                  selectedCategory = null;
                                                  searchControllerText = null;
                                                  searchController.clear();
                                                });
                                              });
                                            },
                                            child: Text('모든', style: style),
                                          ),
                                        ),
                                        Card(
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                selectedCategory = '미분류';
                                                searchControllerText = null;
                                                searchController.clear();
                                              });
                                            },
                                            child: Text('미분류', style: style),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // 상단3 검색창
                                  Container(
                                    width: 220,
                                    child: Form(
                                      child: TextFormField(
                                        controller: searchController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          prefixIcon: GestureDetector(
                                            onTap: () {},
                                            child: Icon(
                                              Icons.search,
                                              size: 24,
                                            ),
                                          ),
                                          prefixIconColor: Colors.grey,
                                          suffixIcon: GestureDetector(
                                            onTap: (){},
                                            child: Icon(
                                              Icons.close,
                                              size: 24,
                                            ),
                                          ),
                                          suffixIconColor: Colors.grey,
                                          hintText: '검색',
                                          contentPadding: EdgeInsets.all(12),
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        cursorColor: Colors.grey,
                                        onChanged: (value) {
                                          setState(() {
                                            searchController.text = value;
                                            searchControllerText = searchController.text;
                                          });
                                        },
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 상단: 생성한 카테고리
                            Container(
                              child: Expanded(
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: 0);
                                  },
                                  itemCount: box.values.length,
                                  itemBuilder: (context, index) {
                                    CategoryModel? categoryContact = box.getAt(index);
                                    return Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            searchControllerText = null;
                                            selectedCategory = categoryContact!.categories;
                                            searchController.clear();
                                          });
                                        },
                                        // note: categoryContact?.categories 에만 모든 범주가 담겨있다
                                        child: Text('${categoryContact?.categories}'),
                                        // child: Text('${categoryContact?.categories}', style: textStyle.titleMedium),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // note: 하단 body - 메모장
          ValueListenableBuilder(
            valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
            builder: (context, Box<MemoModel> box, _) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // todo: 분기 처리하는 과정 좀 더 고민하기 (한줄 이라도 없으면 효율 증가, 조건 많은 순으로 정렬하여 처리 )
                        // note: 모든 카테고리 누르고 입력 내용 없으면 모든 메모 나타내기
                        if (selectedCategory == null && searchControllerText == null) HomeBodyCardWidget(),
                        // note: 범주 있으면서, 검색내용 있으면, 아래 검색한 내용 나타내기(HomeSearchWidget)
                        if (selectedCategory != null && searchControllerText != null) HomeSearchWidget(searchControllerText!),
                        // note: 미분류 위젯
                        if (selectedCategory != null) HomeSelectedCategoryWidget(selectedCategory),
                        // note:
                        if (searchControllerText != null) HomeSearchWidget(searchControllerText!),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
