import 'package:flutter/material.dart';
import 'package:simple_note/screens/memo/memo/w_memo_card.dart';
import 'package:simple_note/screens/memo/memo/w_memo_search_card.dart';
import 'package:simple_note/screens/memo/memo/w_memo_selected_category.dart';

class MemoFooterControlStatements extends StatefulWidget {
  const MemoFooterControlStatements(this.selectedCategory, this.searchControllerText, {super.key});

  final String? selectedCategory;
  final String? searchControllerText;

  @override
  State<MemoFooterControlStatements> createState() => _MemoFooterControlStatementsState();
}

class _MemoFooterControlStatementsState extends State<MemoFooterControlStatements> {
  @override
  Widget build(BuildContext context) {
    // note: 3가지 조건: 검색, 범주 선택, 범주 미선택
    // 범주 미선택 및 검색 미선택이므로 모든 메모 나타내기
    if(widget.selectedCategory == "모든"){
      return const MemoCardWidget();
    }
    // 범주 있으면(미분류와 선택한 범주에 해당) 범주에 해당하는 내용 나타내기
    else if (widget.selectedCategory != null && widget.searchControllerText == null) {
      return MemoSelectedCategoryWidget(widget.selectedCategory);
    }
    // 검색어 있으면 검색한 내용 나타내기
    // else if (widget.searchControllerText != null) {
    else {
      return MemoSearchCardWidget(widget.searchControllerText!);
    }
  }
}
