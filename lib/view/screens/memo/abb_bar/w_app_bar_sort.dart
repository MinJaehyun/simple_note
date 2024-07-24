import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/view/screens/public/w_banner_ad.dart';
import 'package:simple_note/controller/settings_controller.dart';

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
  final memoController = Get.find<MemoController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const BannerAdWidget(),
      actions: [
        Semantics(
          child: Obx(
            () => IconButton(
              visualDensity: const VisualDensity(horizontal: -4),
              icon: settingsController.isAppbarFavoriteMemo.value == true ? const Icon(Icons.star, color: Colors.red, size: 32) : const Icon(Icons.star_border_sharp, size: 32),
              onPressed: () {
                settingsController.updateAppbarFavoriteMemo();
              },
            ),
          ),
        ),
        Semantics(
          label: '정렬',
          child: ExcludeSemantics(
            child: IconButton(
              visualDensity: const VisualDensity(horizontal: -4),
              icon: const Icon(Icons.low_priority, size: 32),
              onPressed: () {
                popupSort(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  // 메모: 상단 정렬 버튼
  Future popupSort(context) {
    return Get.dialog(
      AlertDialog(
        elevation: 24.0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('     정렬 선택'),
            Divider(),
          ],
        ),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('작성일 오름차순'),
                leading: Radio<SortedTime>(
                  value: SortedTime.firstTime,
                  groupValue: settingsController.sortedTime.value,
                  onChanged: (SortedTime? value) {
                    settingsController.updateSortedName(value!);
                  },
                ),
                onTap: () {
                  settingsController.updateSortedName(SortedTime.firstTime);
                },
              ),
              ListTile(
                title: const Text('작성일 내림차순(최신순)'),
                leading: Radio<SortedTime>(
                  value: SortedTime.lastTime,
                  groupValue: settingsController.sortedTime.value,
                  onChanged: (SortedTime? value) {
                    settingsController.updateSortedName(value!);
                  },
                ),
                onTap: () {
                  settingsController.updateSortedName(SortedTime.lastTime);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('닫기'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
