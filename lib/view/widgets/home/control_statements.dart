import 'package:flutter/material.dart';
import 'package:simple_note/view/widgets/home/home_body_card.dart';
import 'package:simple_note/view/widgets/home/home_search.dart';
import 'package:simple_note/view/widgets/home/home_selected_category.dart';

class ControlStatements extends StatefulWidget {
  const ControlStatements(this.selectedCategory, this.searchControllerText, this.sortedTime, {super.key});

  final selectedCategory;
  final searchControllerText;
  final sortedTime;

  @override
  State<ControlStatements> createState() => _ControlStatementsState();
}

class _ControlStatementsState extends State<ControlStatements> {
  @override
  Widget build(BuildContext context) {
    if (widget.selectedCategory == null && widget.searchControllerText == null) {
      // 모든 카테고리 누르고 입력 내용 없으면 모든 메모 나타내기
      return HomeBodyCardWidget(widget.sortedTime);
    } else if (widget.selectedCategory != null && widget.searchControllerText != null) {
      // 범주 있으면서, 검색내용 있으면, 검색한 내용 나타내기
      return HomeSearchWidget(widget.searchControllerText!, widget.sortedTime);
    } else if (widget.selectedCategory != null) {
      // 미분류 위젯
      return HomeSelectedCategoryWidget(widget.selectedCategory, widget.sortedTime);
    } else if (widget.searchControllerText != null) {
      // 검색내용 있으면 검색 위젯 나타내기
      return HomeSearchWidget(widget.searchControllerText!, widget.sortedTime);
    } else {
      // 기본적으로 모든 카테고리 누르고 검색 내용 없으면 메모 나타내기
      return HomeBodyCardWidget(widget.sortedTime);
    }
  }
}
