import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:simple_note/view/screens/trash_can/trash_can_page.dart';

//ignore: must_be_immutable
class AppBarSortWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarSortWidget(this.index, {super.key});

  final int index;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // 사이즈 조절: Size get preferredSize => const Size.fromHeight(70);

  @override
  State<AppBarSortWidget> createState() => _AppBarSortWidgetState();
}

class _AppBarSortWidgetState extends State<AppBarSortWidget> {
  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    // TextStyle style = TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary);

    return AppBar(
      // title: Text('Simple Note', style: style),
      actions: [
        IconButton(
            visualDensity: const VisualDensity(horizontal: -4),
            icon: const Icon(Icons.sort),
            onPressed: () {
              popupSort(context);
            }),
      ],
    );
  }

  // 메모: 상단 정렬 버튼
  Future popupSort(context) {
    return Get.dialog(
      ValueListenableBuilder(
        valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
        builder: (context, Box<MemoModel> box, _) {
          return AlertDialog(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('정렬 선택'),
                Divider(),
              ],
            ),
            content: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('작성일 내림차순(최신순)'),
                    leading: Radio<SortedTime>(
                      value: SortedTime.lastTime,
                      groupValue: settingsController.sortedTime.value,
                      onChanged: (SortedTime? value) {
                        settingsController.updateSortedName(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('작성일 오름차순'),
                    leading: Radio<SortedTime>(
                      value: SortedTime.firstTime,
                      groupValue: settingsController.sortedTime.value,
                      onChanged: (SortedTime? value) {
                        settingsController.updateSortedName(value!);
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    // note: 화면 즉시 재구성하기 위해 페이지 전체를 리로드
                    // note: 아래 적용되지 않을 때가 있으므로 위에 pushReplacement 사용한다
                    // Get.off(MemoPage()); // (= pushReplacement)
                    Navigator.pop(context);

                    // todo: MemoPage() 인지, TrashCanPage() 인지 구별해서 설정해야 한다. 방법은 ?
                    if(widget.index == 2) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                        return const MemoPage();
                      }));
                    } else if(widget.index == 3) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                        return const TrashCanPage();
                      }));
                    }
                  },
                  child: const Text('적용')),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
            ],
            elevation: 24.0,
          );
        },
      ),
    );
  }
}
