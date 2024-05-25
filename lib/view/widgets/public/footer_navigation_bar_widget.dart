import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/route_manager.dart';
import 'package:simple_note/view/screens/calendar/calendar_page.dart';
import 'package:simple_note/view/screens/category/category_page.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:simple_note/view/screens/settings/settings.dart';
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
      animationDuration: const Duration(milliseconds: 300),
      index: currentIndex,
      color: Theme.of(context).colorScheme.onPrimary,
      items: [
        // note: 캘린더
        IconButton(
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
        // note: 범주
        IconButton(
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
        // note: 모든 메모
        IconButton(
          tooltip: '모든 메모',
          icon: const Icon(Icons.data_array_outlined),
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
        // note: 휴지통
        IconButton(
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
        // note: 설정
        IconButton(
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
            // Get.offAll(() => const Settings());

            Get.snackbar(
              '기능을 준비 중 입니다',
              '업데이트 준비 중: \n'
                  '1. 구글 로그인 및 구글 동기화, \n'
                  '2. 메모장 글꼴, 스킨 선택 기능 \n'
                  '3. 즐겨 찾기 \n'
                  '4. 태그 \n'
                  '5. 달력 내 알림 및 타임라인 \n \n'
                  '등등 많은 기능을 다듬고 있습니다. 좀 더 기다려 주세요 :) \n',
              colorText: Colors.orange,
              snackPosition: SnackPosition.BOTTOM,
              forwardAnimationCurve: Curves.elasticInOut,
              reverseAnimationCurve: Curves.easeOut,
              duration: const Duration(seconds: 6),
              mainButton: TextButton(
                onPressed: () {
                  Get.back(); // Closes the snackbar
                },
                child: const Text('Close', style: TextStyle(color: Colors.red)),
              ),
            );
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
