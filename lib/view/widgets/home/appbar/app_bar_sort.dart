import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/home/my_page.dart';


class AppBarSort extends StatefulWidget implements PreferredSizeWidget {
  AppBarSort(this.sortedTime, this.changeFunc, {super.key});
  final SortedTime sortedTime;
  final Function(dynamic) changeFunc;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // 사이즈 조절: Size get preferredSize => const Size.fromHeight(70);

  @override
  State<AppBarSort> createState() => _AppBarSortState();
}

class _AppBarSortState extends State<AppBarSort> {
  Future popupSort(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('정렬을 선택해 주세요'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text('최신순'),
                    leading: Radio<SortedTime>(
                      value: SortedTime.firstTime,
                      groupValue: widget.sortedTime,
                      onChanged: (SortedTime? value) {
                        // setState(() {
                        //   widget.sortedTime = value!;
                        // });
                        setState((){
                          widget.changeFunc(value);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('오래된 시간부터'),
                    leading: Radio<SortedTime>(
                      value: SortedTime.lastTime,
                      groupValue: widget.sortedTime,
                      onChanged: (SortedTime? value) {
                        // setState(() {
                        //   widget.sortedTime = value!;
                        // });
                        setState((){
                          widget.changeFunc(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, widget.sortedTime); // 정렬 값을 반환
                    },
                    child: Text('적용')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 취소 시 반환 값 없음
                    },
                    child: Text('취소')),
              ],
              elevation: 24.0,
              // backgroundColor: Colors.white,
            );
          },
        );
      },
    );
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    print('2 : ${widget.sortedTime}');
    return AppBar(
      title: Text('Simple Note', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.sort),
          onPressed: () {
            // 1. 팝업창 띄우기
            // 2. 정렬 종류 나열하기
            // 3. 클릭한 정렬로 메모장 나열하기
            popupSort(context);
            // 4. 정렬된 시간 순서대로 메모 나열하기
            print('3: ${widget.sortedTime}'); // 3: SortedTime.firstTime
          },
        ),
      ],
    );
  }
}
