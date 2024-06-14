import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_note/controller/category_controller.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/repository/local_data_source/category_repository.dart';
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
  final categoryController = Get.find<CategoryController>();

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
                child: SizedBox(
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
                                  child: searchControllerText != null ? const Icon(Icons.close, size: 24) : const Icon(Icons.transit_enterexit),
                                ),
                                suffixIconColor: Colors.grey,
                                hintText: '검색',
                                contentPadding: const EdgeInsets.all(12),
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              cursorColor: Colors.grey,
                              onChanged: (value) {
                                setState(() {
                                  // 변경 전: 자음 한개씩 가져오는게 아닌, 전체를 가져오도록 변경
                                  // searchController.text = value;
                                  // 변경 후
                                  searchControllerText = searchController.text;
                                });
                              },
                              onTap: () {},
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // 상단2: 모든, 미분류, 생성한 범주
                        SizedBox(
                          width: 363,
                          height: 56,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.grey,
                                      width: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
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
                                    side: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
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
                                // note: [] 내에서 ...box 사용하여 ListView 대신 반복하는 방법: SingleChildScrollView 내에 ListView 사용 시 충돌함!
                                // note: 변경 전
                                // ...box.values.map(
                                   ...categoryController.categoryList.map(
                                  (categoryContact) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      color: selectedCategory == categoryContact.categories ? Colors.red : null,
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
                              ],
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
          SizedBox(
            height: 500,
            child: SingleChildScrollView(
              child: MemoBodyFooterControlStatementsWidget(selectedCategory, searchControllerText),
            ),
          ),
        ],
      ),
    );
  }
}
