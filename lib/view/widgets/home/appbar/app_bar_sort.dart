import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/home/my_page.dart';

//ignore: must_be_immutable
class AppBarSort extends StatefulWidget implements PreferredSizeWidget {
  AppBarSort(this.sortedTime, this.changeFunc, {super.key});
  // final 지정하면 한 번만 값을 변경하는데, 그래서 지정하지 않음
  SortedTime sortedTime;
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
                        setState(() {
                          widget.sortedTime = value!;
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
                        setState(() {
                          widget.sortedTime = value!;
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
                      Navigator.pop(context);
                    },
                    child: Text('취소')),
              ],
              elevation: 24.0,
            );
          },
        );
      },
    );
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Text('Simple Note', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.sort),
          onPressed: () {
            popupSort(context);
          },
        ),
      ],
    );
  }
}
