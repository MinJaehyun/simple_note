import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:simple_note/view/screens/calendar/calendar_page.dart';
import 'package:simple_note/view/screens/category/category_page.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:simple_note/view/screens/trash_can/trash_can_page.dart';

class FooterNavigationBarWidget extends StatefulWidget {
  const FooterNavigationBarWidget(this.index, {super.key, this.sortedTime});

  final int index;
  final SortedTime? sortedTime;

  @override
  State<FooterNavigationBarWidget> createState() => _FooterNavigationBarWidgetState();
}

class _FooterNavigationBarWidgetState extends State<FooterNavigationBarWidget> {
  late int currentIndex = 2;
  bool isTapped = true;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  void setTappedAndIndex(index) {
    currentIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      animationDuration: Duration(milliseconds: 300),
      index: currentIndex,
      color: Theme.of(context).colorScheme.onPrimary,
      items: [
        // note: 캘린더
        IconButton(
          tooltip: '달력',
          icon: Icon(Icons.calendar_month),
          onPressed: (){
            setState(() {
              setTappedAndIndex(0);
            });
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return CalendarPage();
            },));
          },
          iconSize: 25,
          color: currentIndex == 0 ? Colors.cyan : Colors.grey,
        ),
        // note: 범주
        IconButton(
          tooltip: '범주',
          icon: Icon(Icons.category),
          onPressed: (){
            setState(() {
              setTappedAndIndex(1);
            });
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return CategoryPage();
            },));
          },
          iconSize: 25,
          color: currentIndex == 1 ? Colors.cyan : Colors.grey,
        ),
        // note: 모든 메모
        IconButton(
          tooltip: '모든 메모',
          icon: Icon(Icons.data_array_outlined),
          onPressed: (){
            setState(() {
              setTappedAndIndex(2);
            });
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return MemoPage();
            },));
          },
          iconSize: 25,
          color: currentIndex == 2 ? Colors.cyan : Colors.grey,
        ),
        // note: 설정
        IconButton(
          tooltip: '설정',
          icon: Icon(Icons.settings),
          onPressed: (){
            setState(() {
              isTapped = true;
              currentIndex = 3;
            });
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
            //   return;
            // },));
          },
          iconSize: 25,
          color: currentIndex == 3 ? Colors.cyan : Colors.grey,
        ),
        // note: 휴지통
        IconButton(
          tooltip: '휴지통',
          icon: Icon(Icons.delete),
          onPressed: (){
            setState(() {
              isTapped = true;
              currentIndex = 4;
            });
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return TrashCanPage();
            },));
          },
          iconSize: 25,
          color: currentIndex == 4 ? Colors.cyan : Colors.grey,
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
}


