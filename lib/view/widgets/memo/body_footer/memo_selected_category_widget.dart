import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/update_memo_page.dart';
import 'package:simple_note/view/widgets/public/memo_calendar_popup_button_widget.dart';

enum SampleItem { updateMemo, deleteMemo }

// note: 메모 상단에 사용자가 선택한 범주를 내려받고 있다
class MemoSelectedCategoryWidget extends StatefulWidget {
  const MemoSelectedCategoryWidget(this.selectedCategory, {super.key});

  final String? selectedCategory;

  @override
  State<MemoSelectedCategoryWidget> createState() => _MemoSelectedCategoryWidgetState();
}

class _MemoSelectedCategoryWidgetState extends State<MemoSelectedCategoryWidget> {
  final memoController = Get.find<MemoController>();
  final settingsController = Get.find<SettingsController>();

  void updateMemo(sortedIndex, currentContact, {
    final bool? isFavoriteMemo,
    final bool? isCheckedTodo,
  }) {
    memoController.updateCtr(
      index: sortedIndex,
      createdAt: currentContact.createdAt,
      title: currentContact.title,
      mainText: currentContact.mainText,
      selectedCategory: currentContact.selectedCategory,
      isFavoriteMemo: isFavoriteMemo ?? false,
      isCheckedTodo: isCheckedTodo ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary);

    return Obx(
      () {
        if (memoController.memoList.isEmpty) return const Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));
        // note: 메모 상단에 사용자가 선택한 범주와 메모장에 범주가 같은 것만 나타내기
        List<MemoModel> sameCategoryMemo = memoController.memoList.where((item) {
          return item.selectedCategory == widget.selectedCategory;
        }).toList();

        // note: 선택한 범주'만' 정렬하여 나타내기
        List<MemoModel> sortedSelectedCategoryMemo = List.from(sameCategoryMemo)..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        List<MemoModel> reversedSelectedCategoryMemo = List.from(sameCategoryMemo)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        List<MemoModel> selectedMemoList =
            settingsController.sortedTime.value == SortedTime.firstTime ? sortedSelectedCategoryMemo : reversedSelectedCategoryMemo;
        List<MemoModel> favoriteMemoList = selectedMemoList.where((item) {
          return item.isFavoriteMemo == true;
        }).toList();

        return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: settingsController.isAppbarFavoriteMemo.value == true ? favoriteMemoList.length : sameCategoryMemo.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (BuildContext context, int index) {
              // MemoModel? currentContact = selectedMemoList[index];
              MemoModel? currentContact = settingsController.isAppbarFavoriteMemo.value == true ? favoriteMemoList[index] : selectedMemoList[index];
              int sortedIndex = memoController.memoList.indexOf(currentContact);

              return Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: CustomPaint(
                  painter: GridPainter(),
                  child: InkWell(
                    onTap: () => Get.to(UpdateMemoPage(index: sortedIndex, sortedCard: currentContact)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),

                      child: Stack(
                        children: [
                          Container(
                            decoration: currentContact.imagePath != null
                                ? BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(currentContact.imagePath!)),
                                fit: BoxFit.cover,
                              ),
                            )
                                : const BoxDecoration(),
                          ),
                          if (currentContact.imagePath != null)
                          // note: BackdropFilter 위젯 사용하면 흐릿한(이미지 색상 및 전체 색상) 이미지로 처리할 수 있다
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                              child: Container(color: Colors.black.withOpacity(0.2)),
                            ),
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.titleHeight,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 10.0),
                                    Expanded(child: Text(currentContact.title, overflow: TextOverflow.ellipsis, style: style)),
                                    MemoCalendarPopupButtonWidget(sortedIndex, currentContact),
                                  ],
                                ),
                                const SizedBox(height: 90.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        FormatDate().formatSimpleTimeKor(currentContact.createdAt),
                                        style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                      ),
                                    ),
                                    // 체크 todolist
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      visualDensity: const VisualDensity(horizontal: -4.0),
                                      onPressed: () {
                                        updateMemo(sortedIndex, currentContact, isFavoriteMemo: currentContact.isFavoriteMemo!, isCheckedTodo: !currentContact.isCheckedTodo!);
                                      },
                                      icon: currentContact.isCheckedTodo == false
                                          ? const Icon(Icons.check_box_outline_blank, color: null, size: 32)
                                          : const Icon(Icons.check_box, color: Colors.red, size: 32),
                                    ),
                                    // 즐겨 찾기
                                    IconButton(
                                      onPressed: () {
                                        updateMemo(sortedIndex, currentContact, isFavoriteMemo: !currentContact.isFavoriteMemo!, isCheckedTodo: currentContact.isCheckedTodo!);
                                      },
                                      icon: currentContact.isFavoriteMemo == false
                                          ? const Icon(Icons.star_border_sharp, color: null, size: 32)
                                          : const Icon(Icons.star, color: Colors.red, size: 32),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
