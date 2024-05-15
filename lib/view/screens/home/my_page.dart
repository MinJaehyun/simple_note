import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/memo/add_memo.dart';
import 'package:simple_note/view/widgets/home/appbar/app_bar_sort.dart';
import 'package:simple_note/view/widgets/home/home_page.dart';
import 'package:simple_note/view/widgets/public/navigation_bar.dart';

enum SortedTime { firstTime, lastTime }

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  SortedTime sortedTime = SortedTime.firstTime;

  void changeFunc(value) {
    setState(() {
      sortedTime = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('my sort: $sortedTime');
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // note: Appbar
        appBar: AppBarSort(sortedTime, changeFunc),
        // note: home page body frame
        body: HomePage(sortedTime),
        // note: navigation bar
        bottomNavigationBar: BuildCurvedNavigationBar(2),
        // note: 하단 add
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }

  // todo 파일로 분리해서 달력페이제와 메모페이지에서 가져와 사용할 것이다.
  // AppBar buildAppBar() {
  //   return AppBar(
  //     title: Text('Simple Note', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
  //     centerTitle: true,
  //     actions: [
  //       IconButton(
  //         onPressed: () {
  //           // todo: 정렬 고민하기..
  //         },
  //         icon: Icon(Icons.sort.dart),
  //       ),
  //     ],
  //   );
  // }

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
