import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/crud_memo/add_memo.dart';
import 'package:simple_note/view/widgets/home/appbar/app_bar_sort.dart';
import 'package:simple_note/view/widgets/home/home_page.dart';
import 'package:simple_note/view/widgets/public/navigation_bar.dart';

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
        appBar: AppBarSort(sortedTime, changeFunc),
        body: HomePage(sortedTime),
        bottomNavigationBar: BuildCurvedNavigationBar(2),
        // note: 하단 add
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return AddMemo();
        }));
      },
      label: const Text('메모 만들기'),
    );
  }
}
