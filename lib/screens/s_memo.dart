import 'package:flutter/material.dart';
import 'package:simple_note/screens/memo/abb_bar/w_app_bar_sort.dart';
import 'package:simple_note/screens/memo/f_memo_content.dart';
import 'package:simple_note/screens/public/w_footer_navigation_bar.dart';
import 'package:simple_note/screens/public_memo/s_add_memo.dart';

class MemoPage extends StatefulWidget {
  const MemoPage(String this.category, {super.key});

  final String? category;

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // note: index 2번을 넣어줘서 MemoPage를 리로드 하려한다
        appBar: const AppBarSortWidget(2),
        body: MemoContent(widget.category!),
        bottomNavigationBar: const FooterNavigationBarWidget(2),
        // note: 하단 add
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return const AddMemoPage();
        }));
      },
      label: Icon(Icons.edit_note_outlined),
    );
  }
}
