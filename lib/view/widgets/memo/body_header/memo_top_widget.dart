import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/view/widgets/memo/memo_body_footer_control_statements_widget.dart';

class MemoTopWidget extends StatefulWidget {
  const MemoTopWidget(this.sortedTime, {super.key});

  final SortedTime? sortedTime;

  @override
  State<MemoTopWidget> createState() => _MemoTopWidgetState();
}

class _MemoTopWidgetState extends State<MemoTopWidget> {
  late String searchedTitle;
  String? searchedMainText;
  String? selectedCategory;
  String? searchControllerText;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: Theme.of(context).colorScheme.primary);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          // body_top: 범주 및 검색창
          ValueListenableBuilder(
            valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
            builder: (context, Box<CategoryModel> box, _) {
              return SingleChildScrollView(
                child: Container(
                  height: 148,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // 상단: 모든, 미분류, 검색창
                        Row(
                          children: [
                            // 상단1~2: 모든, 미분류 박스
                            Expanded(
                              child: Row(
                                children: [
                                  Card(
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedCategory = null;
                                          searchControllerText = null;
                                          searchController.clear();
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
                            // 상단3: 검색창
                            SizedBox(
                              width: 220,
                              child: Form(
                                child: TextFormField(
                                  autofocus: false,
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                        width: 1,
                                      ),
                                    ),
                                    prefixIcon: GestureDetector(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.search,
                                        size: 24,
                                      ),
                                    ),
                                    prefixIconColor: Colors.grey,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          searchController.clear();
                                          searchControllerText = null;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 24,
                                      ),
                                    ),
                                    suffixIconColor: Colors.grey,
                                    hintText: '검색',
                                    contentPadding: const EdgeInsets.all(12),
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

                        // 상단: 생성한 카테고리
                        Container(
                          child: Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 0);
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
                                        searchController.clear();
                                        selectedCategory = categoryContact!.categories;
                                      });
                                    },
                                    child: Text('${categoryContact?.categories}'),
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
              );
            },
          ),

          // 하단 메모장
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 500,
              child: SingleChildScrollView(
                child: MemoBodyFooterControlStatementsWidget(selectedCategory, searchControllerText, widget.sortedTime),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
