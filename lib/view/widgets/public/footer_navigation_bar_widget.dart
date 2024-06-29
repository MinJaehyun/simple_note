import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/view/screens/calendar/calendar_page.dart';
import 'package:simple_note/view/screens/category/category_page.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:simple_note/view/screens/settings/settings_page.dart';
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
      animationDuration: const Duration(milliseconds: 100),
      index: currentIndex,
      color: Theme.of(context).colorScheme.onPrimary,
      items: [
        // note: 캘린더
        Semantics(
          label: '달력',
          child: ExcludeSemantics(
            child: IconButton(
              tooltip: '달력',
              icon: const Icon(Icons.calendar_month),
              onPressed: () {
                setState(() {
                  setTappedAndIndex(0);
                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const CalendarPage();
                  },
                ));
              },
              iconSize: 25,
              color: currentIndex == 0 ? Colors.cyan : Colors.grey,
            ),
          ),
        ),
        // note: 범주
        Semantics(
          label: '범주',
          child: ExcludeSemantics(
            child: IconButton(
              tooltip: '범주',
              icon: const Icon(Icons.category),
              onPressed: () {
                setState(() {
                  setTappedAndIndex(1);
                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const CategoryPage();
                  },
                ));
              },
              iconSize: 25,
              color: currentIndex == 1 ? Colors.cyan : Colors.grey,
            ),
          ),
        ),

        // note: 모든 메모
        Semantics(
          label: '메모장',
          child: ExcludeSemantics(
            child: IconButton(
              tooltip: '메모장',
              icon: const Icon(Icons.edit_note),
              onPressed: () {
                setState(() {
                  setTappedAndIndex(2);
                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const MemoPage();
                  },
                ));
              },
              iconSize: 25,
              color: currentIndex == 2 ? Colors.cyan : Colors.grey,
            ),
          ),
        ),
        // note: 휴지통
        Semantics(
          label: '휴지통',
          // fix: ExcludeSemantics 설정하여, IconButton 내에 tooltip 설명 제외하기
          child: ExcludeSemantics(
            child: IconButton(
              tooltip: '휴지통',
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  isTapped = true;
                  currentIndex = 3;
                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const TrashCanPage();
                  },
                ));
              },
              iconSize: 25,
              color: currentIndex == 3 ? Colors.cyan : Colors.grey,
            ),
          ),
        ),
        // note: 설정
        Semantics(
          label: '설정',
          child: ExcludeSemantics(
            child: IconButton(
              tooltip: '설정',
              icon: const Icon(Icons.settings),
              onPressed: () {
                setState(() {
                  isTapped = true;
                  currentIndex = 4;
                });
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const Settings();
                  },
                ));
              },
              iconSize: 25,
              color: currentIndex == 4 ? Colors.cyan : Colors.grey,
            ),
          ),
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
