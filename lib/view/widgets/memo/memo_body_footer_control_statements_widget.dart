import 'package:flutter/material.dart';
import 'package:simple_note/view/widgets/memo/body_footer/memo_card_widget.dart';
import 'package:simple_note/view/widgets/memo/body_footer/memo_search_card_widget.dart';
import 'package:simple_note/view/widgets/memo/body_footer/memo_selected_category_widget.dart';

class MemoBodyFooterControlStatementsWidget extends StatefulWidget {
  const MemoBodyFooterControlStatementsWidget(this.selectedCategory, this.searchControllerText, {super.key});

  final String? selectedCategory;
  final String? searchControllerText;

  @override
  State<MemoBodyFooterControlStatementsWidget> createState() => _MemoBodyFooterControlStatementsWidgetState();
}

class _MemoBodyFooterControlStatementsWidgetState extends State<MemoBodyFooterControlStatementsWidget> {
  @override
  Widget build(BuildContext context) {
    // note: 3가지 조건: 검색, 범주 선택, 범주 미선택
    if (widget.searchControllerText != null) {
      // 검색어 있으면 검색한 내용 나타내기
      return MemoSearchCardWidget(widget.searchControllerText!);
    } else if (widget.selectedCategory != null) {
      // 범주 있으면(미분류와 선택한 범주에 해당) 범주에 해당하는 내용 나타내기
      return MemoSelectedCategoryWidget(widget.selectedCategory);
    } else {
      // 범주 미선택 및 검색 미선택이므로 모든 메모 나타내기
      return const MemoCardWidget();
    }
  }
}
