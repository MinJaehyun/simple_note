import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/add_memo_page.dart';
import 'package:simple_note/view/widgets/memo/appbar/app_bar_sort_widget.dart';
import 'package:simple_note/view/widgets/memo/body_header/memo_top_widget.dart';
import 'package:simple_note/view/widgets/public/footer_navigation_bar_widget.dart';


class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

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
        appBar: AppBarSortWidget(2),
        body: MemoTopWidget(),
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
      label: const Text('메모 만들기'),
    );
  }
}
