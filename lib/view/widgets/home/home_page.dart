import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/view/screens/home/my_page.dart';
import 'package:simple_note/view/widgets/home/control_statements.dart';
import 'package:simple_note/controller/hive_helper_category.dart';

class HomePage extends StatefulWidget {
  HomePage(this.sortedTime, {super.key});

  final SortedTime? sortedTime;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          // 상단: 범주 및 검색창
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
                        Container(
                          child: Row(
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
                              Container(
                                width: 220,
                                child: Form(
                                  child: TextFormField(
                                    autofocus: false,
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
                                          color: Colors.orange,
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
                                        onTap: () {
                                          setState(() {
                                            searchController.clear();
                                            searchControllerText = null;
                                          });
                                        },
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
                child: ControlStatements(selectedCategory, searchControllerText, widget.sortedTime),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
