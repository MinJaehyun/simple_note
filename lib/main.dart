import 'package:flutter/material.dart';
import 'package:simple_note/view/HomePageBodyFrame.dart';
import 'package:simple_note/view/drawer_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyPage(),
    );
  }
}

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
        floatingActionButton: buildFloatingActionButton(),
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

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {},
      label: const Text('Add'),
      icon: const Icon(Icons.add),
    );
  }

}

