import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/settings_controller.dart';

//ignore: must_be_immutable
class AppBarSortWidget extends StatefulWidget implements PreferredSizeWidget {
  AppBarSortWidget({super.key});

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
    return AppBar(
      title: Text('Simple Note', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      centerTitle: true,
      actions: [
        IconButton(
          visualDensity: const VisualDensity(horizontal: -4),
          icon: const Icon(Icons.sort),
          onPressed: () {
            popupSort(context);
          }
        ),
      ],
    );
  }

  // 메모: 상단 정렬 버튼
  Future popupSort(context) {
    return Get.dialog(
      AlertDialog(
        title: Column(
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
                    // settingsController.updateSortedName(value!);
                    setState(() {
                      settingsController.updateSortedName(value!);
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('작성일 오름차순'),
                leading: Radio<SortedTime>(
                  value: SortedTime.firstTime,
                  groupValue: settingsController.sortedTime.value,
                  onChanged: (SortedTime? value) {
                    // settingsController.updateSortedName(value!);
                    setState(() {
                      settingsController.updateSortedName(value!);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('적용')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
        ],
        elevation: 24.0,
      ),
    );
  }
}
