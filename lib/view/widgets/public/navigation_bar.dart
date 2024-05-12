import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:simple_note/view/screens/calendar/calendar.dart';
import 'package:simple_note/view/screens/category/all_category.dart';
import 'package:simple_note/view/screens/home/my_page.dart';

class BuildCurvedNavigationBar extends StatefulWidget {
  const BuildCurvedNavigationBar(this.index, {super.key});
  final int index;

  @override
  State<BuildCurvedNavigationBar> createState() => _BuildCurvedNavigationBarState();
}

class _BuildCurvedNavigationBarState extends State<BuildCurvedNavigationBar> {
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
          icon: Icon(Icons.category),
          onPressed: (){
            setState(() {
              setTappedAndIndex(1);
            });
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return AllCategory();
            },));
          },
          iconSize: 25,
          color: currentIndex == 1 ? Colors.cyan : Colors.grey,
        ),
        // note: 모든 메모
        IconButton(
          icon: Icon(Icons.data_array_outlined),
          onPressed: (){
            setState(() {
              setTappedAndIndex(2);
            });
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return MyPage();
            },));
          },
          iconSize: 25,
          color: currentIndex == 2 ? Colors.cyan : Colors.grey,
        ),
        // note: 설정
        IconButton(
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
          icon: Icon(Icons.delete),
          onPressed: (){
            setState(() {
              isTapped = true;
              currentIndex = 4;
            });
            // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
            //   return;
            // },));
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


