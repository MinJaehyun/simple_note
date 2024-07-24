import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/memo/w_memo_header/w_memo_header.dart';
import 'package:simple_note/view/screens/memo/w_memo/w_memo_footer_control_statements.dart';

class MemoContent extends StatefulWidget {
  const MemoContent({super.key});

  @override
  State<MemoContent> createState() => _MemoContentState();
}

class _MemoContentState extends State<MemoContent> {
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
          // body_top: 범주
          MemoHeader(
            selectedCategory,
            searchControllerText,
            selectedCategoryFunc,
            searchControllerTextFunc,
          ),

          // 하단 메모장
          SizedBox(
            // 240720: testing...
            // height: 500,
            // height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight*5,
            child: SingleChildScrollView(
              child: MemoFooterControlStatements(selectedCategory, searchControllerText),
            ),
          ),
        ],
      ),
    );
  }
}
