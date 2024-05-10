import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/memo/add_memo.dart';
import 'package:simple_note/view/widgets/home/drawer.dart';
import 'package:simple_note/view/widgets/home/home_page_body_frame.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int currentIndex = 0;
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // note: Appbar
        appBar: buildAppBar(),
        // note: home page body frame
        body: HomePageBodyFrame(),
        // note: 하단 add
        floatingActionButton: buildFloatingActionButton(context),
        // note: Drawer 만들기
        drawer: DrawerWidget(),
        // note: navigation bar
        bottomNavigationBar: buildCurvedNavigationBar(),
      ),
    );
  }

  CurvedNavigationBar buildCurvedNavigationBar() {
    return CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 300),
        index: currentIndex,
        color: Colors.black,
        items: [
          // note: 캘린더
          Icon(
            Icons.calendar_month,
            size: 25,
            color: isTapped && currentIndex == 0 ? Colors.yellow : Colors.grey,
          ),
          // note: 범주
          Icon(
            Icons.category,
            size: 25,
            color: isTapped && currentIndex == 1 ? Colors.yellow : Colors.grey,
          ),
          // note: 모든 메모
          Icon(
            Icons.data_array_outlined,
            size: 25,
            color: isTapped && currentIndex == 2 ? Colors.yellow :  Colors.grey,
          ),
          // note: 설정
          Icon(
            Icons.settings,
            size: 25,
            color: isTapped && currentIndex == 3 ? Colors.yellow :  Colors.grey,
          ),
          // note: 휴지통
          Icon(
            Icons.delete,
            size: 25,
            color: isTapped && currentIndex == 4 ? Colors.yellow :  Colors.grey,
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
            isTapped = true;
          });
        },
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
