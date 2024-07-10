import 'package:flutter/material.dart';
import 'package:simple_note/view/widgets/memo/body_header/memo_top_widget.dart';
import 'package:simple_note/view/widgets/memo/memo_body_footer_control_statements_widget.dart';

class MemoBody extends StatefulWidget {
  const MemoBody({super.key});

  @override
  State<MemoBody> createState() => _MemoBodyState();
}

class _MemoBodyState extends State<MemoBody> {
  String? selectedCategory;
  String? searchControllerText;

  void selectedCategoryFunc(String? category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void searchControllerTextFunc(String? text) {
    setState(() {
      searchControllerText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // body_top: 검색창 및 범주
          MemoTopWidget(
            selectedCategory,
            searchControllerText,
            selectedCategoryFunc,
            searchControllerTextFunc,
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
