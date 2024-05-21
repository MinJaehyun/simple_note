import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/view/screens/home/my_page.dart';

//ignore: must_be_immutable
class AppBarSort extends StatefulWidget implements PreferredSizeWidget {
  AppBarSort(this.sortedTime, this.changeFunc, {super.key});

  // note: 아래 SortedTime 은 final 지정하면 한 번만 값을 변경하여서 지정하지 않음
  SortedTime sortedTime;
  final Function(dynamic) changeFunc;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  // 사이즈 조절: Size get preferredSize => const Size.fromHeight(70);

  @override
  State<AppBarSort> createState() => _AppBarSortState();
}

class _AppBarSortState extends State<AppBarSort> {
  // 메모: 상단 정렬 버튼
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
                  ListTile(
                    title: const Text('오래된 시간부터'),
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
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, widget.sortedTime), // 정렬 값을 반환,
                    child: Text('적용')),
                TextButton(onPressed: () => Navigator.pop(context), child: Text('취소')),
              ],
              elevation: 24.0,
            );
          },
        );
      },
    );
  }

  @override
  ValueListenableBuilder<Object?> build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('darkModel').listenable(keys: ['darkMode']),
      builder: (context, box, _) {
        var darkMode = box.get('darkMode', defaultValue: false);

        return AppBar(
          title: Text('Simple Note', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          centerTitle: true,
          actions: [
            IconButton(
              visualDensity: VisualDensity(horizontal: -4),
              icon: Icon(Icons.sort),
              onPressed: () => popupSort(context),
            ),
            IconButton(
              visualDensity: VisualDensity(horizontal: -4),
              icon: darkMode ? Icon(Icons.light_mode_outlined) : Icon(Icons.dark_mode_outlined),
              onPressed: () {
                if (darkMode == false) {
                  box.put('darkMode', true);
                } else {
                  box.put('darkMode', false);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
