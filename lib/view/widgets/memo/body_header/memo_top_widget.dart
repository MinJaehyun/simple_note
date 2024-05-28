import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/view/widgets/memo/memo_body_footer_control_statements_widget.dart';

class MemoTopWidget extends StatefulWidget {
  const MemoTopWidget({super.key});

  @override
  State<MemoTopWidget> createState() => _MemoTopWidgetState();
}

class _MemoTopWidgetState extends State<MemoTopWidget> {
  late String searchedTitle;
  String? searchedMainText;
  String? selectedCategory;
  String? searchControllerText;
  TextEditingController searchController = TextEditingController();
  final settingsController = Get.find<SettingsController>();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          // body_top: 검색창 및 범주
          ValueListenableBuilder(
            valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
            builder: (context, Box<CategoryModel> box, _) {
              return SingleChildScrollView(
                child: Container(
                  height: 155,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // 상단1: 검색창
                        SizedBox(
                          width: double.infinity,
                          child: Form(
                            child: TextFormField(
                              autofocus: false,
                              controller: searchController,
                              decoration: InputDecoration(
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
                                  child: searchControllerText != null ? Icon(Icons.close, size: 24) : Icon(Icons.transit_enterexit),
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
                        SizedBox(height: 15),
                        // 상단2: 모든, 미분류, 생성한 범주
                        Row(
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // note: 선택한 범주가 '모든(null)' 이면 빨강 박스로
                              color: selectedCategory == null ? Colors.red : null,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = null;
                                    searchControllerText = null;
                                    searchController.clear();
                                  });
                                },
                                child: Text(
                                  '모든',
                                  // note: 선택한 범주가 '모든(null)' 이면 ...
                                  style: TextStyle(color: selectedCategory == null ? Colors.white : null),
                                ),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color: selectedCategory == '미분류' ? Colors.red : null,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = '미분류';
                                    searchControllerText = null;
                                    searchController.clear();
                                  });
                                },
                                child: Text(
                                  '미분류',
                                  style: TextStyle(color: selectedCategory == '미분류' ? Colors.white : null),
                                ),
                              ),
                            ),
                            // 상단: 생성한 카테고리
                            SizedBox(
                              width: 230,
                              height: 60,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) {
                                  return const SizedBox();
                                },
                                itemCount: box.values.length,
                                itemBuilder: (context, index) {
                                  CategoryModel? categoryContact = box.getAt(index);
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    color: selectedCategory == categoryContact!.categories ? Colors.red : null,
                                    clipBehavior: Clip.antiAlias,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          searchControllerText = null;
                                          searchController.clear();
                                          selectedCategory = categoryContact.categories;
                                        });
                                      },
                                      child: Text(
                                        '${categoryContact.categories}',
                                        style: TextStyle(color: selectedCategory == categoryContact.categories ? Colors.white : null),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
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
                child: MemoBodyFooterControlStatementsWidget(selectedCategory, searchControllerText, settingsController.sortedTime.value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
