import 'package:flutter/material.dart';
import 'package:simple_note/view/widgets/memo/body_footer/memo_card_widget.dart';
import 'package:simple_note/view/widgets/memo/body_footer/memo_search_card_widget.dart';
import 'package:simple_note/view/widgets/memo/body_footer/memo_selected_category_widget.dart';

class MemoBodyFooterControlStatementsWidget extends StatefulWidget {
  const MemoBodyFooterControlStatementsWidget(this.selectedCategory, this.searchControllerText, this.sortedTime, {super.key});

  final String? selectedCategory;
  final String? searchControllerText;
  final sortedTime;

  @override
  State<MemoBodyFooterControlStatementsWidget> createState() => _MemoBodyFooterControlStatementsWidgetState();
}

class _MemoBodyFooterControlStatementsWidgetState extends State<MemoBodyFooterControlStatementsWidget> {
  @override
  Widget build(BuildContext context) {
    // note: 아래는 변경 전 코드: 임시로 놔두기..
    // if (widget.selectedCategory == null && widget.searchControllerText == null) {
    //   // 범주 == null 이고, 검색어 == null 이면, 모든 메모 나타내기
    //   return HomeBodyCardWidget(widget.sortedTime);
    // }
    // else if (widget.searchControllerText != null) {
    //   // 범주 있으면서(미분류와 선택한 범주에 해당), 검색어 있으면, 검색한 내용 나타내기
    //   return HomeSearchWidget(widget.searchControllerText!, widget.sortedTime);
    // } else if (widget.selectedCategory != null) {
    //   // 범주 있는 위젯()
    //   return HomeSelectedCategoryWidget(widget.selectedCategory, widget.sortedTime);
    // }
    // else if (widget.searchControllerText != null) {
    //   // 검색내용 있으면 검색 위젯 나타내기
    //   return HomeSearchWidget(widget.searchControllerText!, widget.sortedTime);
    // }
    // else {
    //   // 기본적으로 모든 카테고리 누르고 검색 내용 없으면 메모 나타내기
    //   return HomeBodyCardWidget(widget.sortedTime);
    // }

    // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    // note: 3가지 조건으로 리펙토링: 검색, 범주 선택, 범주 미선택
    if (widget.searchControllerText != null) {
      // 검색어 있으면 검색한 내용 나타내기
      return MemoSearchCardWidget(widget.searchControllerText!, widget.sortedTime);
    } else if (widget.selectedCategory != null) {
      // 범주 있으면(미분류와 선택한 범주에 해당) 범주에 해당하는 내용 나타내기
      return MemoSelectedCategoryWidget(widget.selectedCategory, widget.sortedTime);
    } else {
      // 범주 미선택 및 검색 미선택이므로 모든 메모 나타내기
      return MemoCardWidget(widget.sortedTime);
    }
  }
}
