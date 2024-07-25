import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:simple_note/screens/calendar/s_calendar.dart';
import 'package:simple_note/screens/category/s_category.dart';
import 'package:simple_note/screens/s_memo.dart';
import 'package:simple_note/screens/settings/s_settings.dart';
import 'package:simple_note/screens/trash_can/s_trash_can.dart';

// const pages = [CalendarPage(), CategoryPage(), MemoPage(), TrashCanPage(), Settings()];

class FooterNavigationBarWidget extends StatefulWidget {
  const FooterNavigationBarWidget(this.index, {super.key});

  final int index;

  @override
  State<FooterNavigationBarWidget> createState() => _FooterNavigationBarWidgetState();
}

class _FooterNavigationBarWidgetState extends State<FooterNavigationBarWidget> {
  late int currentIndex;
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
      color: Theme.of(context).colorScheme.onPrimary,
      index: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
          isTapped = true;
        });
      },
      items: [
        // note: 달력
        buildIconButton(context, tooltip: "달력", icon: const Icon(Icons.calendar_month), index: 0, route: const CalendarPage()),
        // note: 범주
        buildIconButton(context, tooltip: "범주", icon: const Icon(Icons.category), index: 1, route: const CategoryPage()),
        // note: 모든 메모
        buildIconButton(context, tooltip: "메모장", icon: const Icon(Icons.edit_note), index: 2, route: const MemoPage("모든")),
        // note: 휴지통
        buildIconButton(context, tooltip: "휴지통", icon: const Icon(Icons.delete), index: 3, route: const TrashCanPage()),
        // note: 설정
        buildIconButton(context, tooltip: "설정", icon: const Icon(Icons.settings), index: 4, route: const Settings()),
      ],
    );
  }

  IconButton buildIconButton(BuildContext context, {required String tooltip, required Widget icon, required int index, required Widget route}) {
    return IconButton(
      tooltip: tooltip,
      icon: icon,
      color: currentIndex == index ? Colors.cyan : Colors.grey,
      iconSize: 25,
      onPressed: () {
        setState(() => setTappedAndIndex(index));
        Get.off(route);
      },
    );
  }
}
