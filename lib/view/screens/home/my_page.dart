import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/calendar/calendar.dart';
import 'package:simple_note/view/screens/category/category.dart';
import 'package:simple_note/view/screens/memo/add_memo.dart';
import 'package:simple_note/view/widgets/home/home_page_body_frame.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int currentIndex = 2;
  bool isTapped = false;

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
        body: HomePageBodyFrame(),
        // note: 하단 add
        floatingActionButton: buildFloatingActionButton(context),
        // note: navigation bar
        bottomNavigationBar: buildCurvedNavigationBar(),
      ),
    );
  }

  // todo: 추후, 중복 개선하기
  CurvedNavigationBar buildCurvedNavigationBar() {
    return CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 300),
        index: currentIndex,
        color: Theme.of(context).colorScheme.onPrimary,
        items: [
          // note: 캘린더
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: (){
              // setState(() {
              //   isTapped = true;
              //   currentIndex = 0;
              // });
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return CalendarPage();
              },));
            },
            iconSize: 25,
            color: isTapped && currentIndex == 0 ? Colors.cyan : Colors.grey,
          ),
          // note: 범주
          IconButton(
            icon: Icon(Icons.category),
            onPressed: (){
              // setState(() {
              //   isTapped = true;
              //   currentIndex = 1;
              // });
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return AllCategory();
              },));
            },
            iconSize: 25,
            color: isTapped && currentIndex == 1 ? Colors.cyan : Colors.grey,
          ),
          // note: 모든 메모
          IconButton(
            icon: Icon(Icons.data_array_outlined),
            onPressed: (){
              // setState(() {
              //   isTapped = true;
              //   currentIndex = 2;
              // });
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return MyPage();
              },));
            },
            iconSize: 25,
            color: isTapped && currentIndex == 2 ? Colors.cyan : Colors.grey,
          ),
          // note: 설정
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              setState(() {
                isTapped = true;
                currentIndex = 3;
              });
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //   return;
              // },));
            },
            iconSize: 25,
            color: isTapped && currentIndex == 3 ? Colors.cyan : Colors.grey,
          ),
          // note: 휴지통
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              setState(() {
                isTapped = true;
                currentIndex = 4;
              });
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //   return;
              // },));
            },
            iconSize: 25,
            color: isTapped && currentIndex == 4 ? Colors.cyan : Colors.grey,
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
