import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/memo/add_memo.dart';
import 'package:simple_note/view/widgets/home/home_page.dart';
import 'package:simple_note/view/widgets/public/navigation_bar.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        // backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // note: Appbar
        appBar: buildAppBar(),
        // note: home page body frame
        body: HomePage(),
        // note: navigation bar
        bottomNavigationBar: BuildCurvedNavigationBar(2),
        // note: 하단 add
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Simple note', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      centerTitle: true,
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
