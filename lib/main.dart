import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/helper/hive_helper.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/widgets/HomePageBodyFrame.dart';
import 'package:simple_note/view/screens/add_screen.dart';
import 'package:simple_note/view/widgets/drawer_widget.dart';

void main() async {
  // note: hive 설정
  await Hive.initFlutter();
  Hive.registerAdapter(MemoModelAdapter());
  await HiveHelper().openBox();

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
    List<MemoModel> memoData = [];

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
          return AddScreen();
        },),);
      },
      label: const Text('Add'),
      icon: const Icon(Icons.add),
    );
  }

}

