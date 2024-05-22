import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/add_memo_page.dart';
import 'package:simple_note/view/widgets/memo/appbar/app_bar_sort_widget.dart';
import 'package:simple_note/view/widgets/memo/body_header/memo_top_widget.dart';
import 'package:simple_note/view/widgets/public/footer_navigation_bar_widget.dart';

enum SortedTime { firstTime, lastTime }

class MemoPage extends StatefulWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  SortedTime sortedTime = SortedTime.firstTime;

  void changeFunc(value) {
    setState(() {
      sortedTime = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBarSortWidget(sortedTime, changeFunc),
        body: MemoTopWidget(sortedTime),
        bottomNavigationBar: FooterNavigationBarWidget(2),
        // note: 하단 add
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return AddMemoPage();
        }));
      },
      label: const Text('메모 만들기'),
    );
  }
}
