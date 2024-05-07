import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/memo/add_memo.dart';
import 'package:simple_note/view/widgets/home/drawer.dart';
import 'package:simple_note/view/widgets/home/home_page_body_frame.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // note: Appbar
        appBar: buildAppBar(),
        // note: home page body frame
        body: HomePageBodyFrame(),
        // note: 하단 add
        floatingActionButton: buildFloatingActionButton(context),
        // note: Drawer 만들기
        drawer: DrawerWidget(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.cyan,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
      ],
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
