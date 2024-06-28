import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/category_controller.dart';
import 'package:simple_note/view/widgets/memo/memo_body_footer_control_statements_widget.dart';

class MemoTopWidget extends StatefulWidget {
  const MemoTopWidget({super.key});

  @override
  State<MemoTopWidget> createState() => _MemoTopWidgetState();
}

class _MemoTopWidgetState extends State<MemoTopWidget> {
  final TextEditingController _textController = TextEditingController();
  final categoryController = Get.find<CategoryController>();

  String? selectedCategory;
  String? searchControllerText;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // body_top: 검색창 및 범주
          Obx(
            () {
              return SingleChildScrollView(
                child: SizedBox(
                  height: 165,
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
                              controller: _textController,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange, width: 1),
                                ),
                                prefixIcon: GestureDetector(
                                  onTap: null,
                                  child: const Icon(Icons.search, size: 24),
                                ),
                                prefixIconColor: Colors.grey,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _textController.clear();
                                      searchControllerText = null;
                                    });
                                  },
                                  child: searchControllerText != null ? const Icon(Icons.close, size: 24) : const Icon(Icons.close, color: Colors.transparent),
                                ),
                                suffixIconColor: Colors.grey,
                                hintText: '검색',
                                contentPadding: const EdgeInsets.all(12),
                                hintStyle: const TextStyle(fontSize: 20),
                              ),
                              cursorColor: Colors.grey,
                              onChanged: (value) {
                                setState(() {
                                  // 변경 전: 자음 한개씩 가져오는게 아닌, 전체를 가져오도록 변경
                                  // _textController.text = value;
                                  searchControllerText = _textController.text;
                                });
                              },
                              onTap: null,
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
                                    side: const BorderSide(color: Colors.black, width: 0.3),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  // note: 선택한 범주가 '모든(null)' 이면 빨강 박스로
                                  color: selectedCategory == null ? Colors.red : null,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedCategory = null;
                                        searchControllerText = null;
                                        _textController.clear();
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
                                    side: const BorderSide(color: Colors.grey, width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  color: selectedCategory == '미분류' ? Colors.red : null,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedCategory = '미분류';
                                        searchControllerText = null;
                                        _textController.clear();
                                      });
                                    },
                                    child: Text(
                                      '미분류',
                                      style: TextStyle(color: selectedCategory == '미분류' ? Colors.white : null),
                                    ),
                                  ),
                                ),
                                // note: [] 내에서 ...box 사용하여 ListView 대신 반복하는 방법: SingleChildScrollView 내에 ListView 사용 시 충돌함!
                                ...categoryController.categoryList.map(
                                  (categoryContact) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(color: Colors.grey, width: 1.0),
                                        borderRadius: BorderRadius.circular(4.0),
                                      ),
                                      color: selectedCategory == categoryContact.categories ? Colors.red : null,
                                      clipBehavior: Clip.antiAlias,
                                      child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            searchControllerText = null;
                                            _textController.clear();
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
