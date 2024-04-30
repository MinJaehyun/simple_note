import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/add_memo/add_memo.dart';
import 'package:simple_note/view/widgets/home/drawer.dart';
import 'package:simple_note/view/widgets/home/home_page_body_frame.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> categories = ['모두', '직장', '감사 일기', '오래전 일기', '롤 마스터'];

    return SafeArea(
      child: Scaffold(
        // note: Appbar
        appBar: buildAppBar(),
        // note: home page body frame
        body: HomePageBodyFrame(categories: categories),
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
      label: const Text('memo'),
      icon: const Icon(Icons.add),
    );
  }
}
