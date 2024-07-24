import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/public_memo/s_update_memo.dart';
import 'package:simple_note/view/widgets/public/w_memo_calendar_popup_button.dart';

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

  void updateMemo(
    sortedIndex,
    currentContact, {
    final bool? isFavoriteMemo,
    final bool? isCheckedTodo,
    final File? imagePath,
  }) {
    memoController.updateCtr(
      index: sortedIndex,
      createdAt: currentContact.createdAt,
      title: currentContact.title,
      mainText: currentContact.mainText,
      selectedCategory: currentContact.selectedCategory,
      isFavoriteMemo: isFavoriteMemo ?? false,
      isCheckedTodo: isCheckedTodo ?? false,
      // imagePath: File(currentContact.imagePath!),
      imagePath: currentContact.imagePath != null ? File(currentContact.imagePath) : null,
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
          // fix: height: MediaQuery.of(context).size.height - 270,
          height: MediaQuery.of(context).size.height - (kBottomNavigationBarHeight * 5),
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
                            height: 200,
                            decoration: currentContact.imagePath != null
                                // 이미지 있는 경우: 이미지만 처리
                                ? BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(currentContact.imagePath!)),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                // 이미지 없는 경우: 그라데이션 처리
                                : BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: settingsController.isThemeMode.value == false
                                          ? [Colors.white.withOpacity(0.5), Colors.transparent]
                                          : [Colors.black.withOpacity(0.5), Colors.transparent],
                                    ),
                                  ),
                          ),
                          if (currentContact.imagePath != null)
                            // 이미지 있는 경우: 전체 블러 효과
                            Positioned(
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.white12.withOpacity(1), Colors.transparent],
                                  ),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                  child: Container(
                                    // 상단 투명 조정
                                    color:
                                        settingsController.isThemeMode.value == false ? Colors.black.withOpacity(0.3) : Colors.white.withOpacity(0.3),
                                  ),
                                ),
                              ),
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
                                const Spacer(),
                                Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        FormatDate().formatSimpleTimeKor(currentContact.createdAt),
                                        style: TextStyle(color: Theme.of(context).colorScheme.secondary.withOpacity(0.9)),
                                      ),
                                    ),
                                    // 체크 todolist
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      visualDensity: const VisualDensity(horizontal: -4.0),
                                      onPressed: () {
                                        updateMemo(
                                          sortedIndex,
                                          currentContact,
                                          isFavoriteMemo: currentContact.isFavoriteMemo!,
                                          isCheckedTodo: !currentContact.isCheckedTodo!,
                                          imagePath: currentContact.imagePath != null ? File(currentContact.imagePath!) : null,
                                        );
                                      },
                                      icon: currentContact.isCheckedTodo == false
                                          ? const Icon(Icons.check_box_outline_blank, color: null, size: 32)
                                          : const Icon(Icons.check_box, color: Colors.red, size: 32),
                                    ),
                                    // 즐겨 찾기
                                    IconButton(
                                      onPressed: () {
                                        updateMemo(
                                          sortedIndex,
                                          currentContact,
                                          isFavoriteMemo: !currentContact.isFavoriteMemo!,
                                          isCheckedTodo: currentContact.isCheckedTodo!,
                                          imagePath: currentContact.imagePath != null ? File(currentContact.imagePath!) : null,
                                        );
                                      },
                                      icon: currentContact.isFavoriteMemo == false
                                          ? const Icon(Icons.star_border_sharp, color: null, size: 32)
                                          : const Icon(Icons.star, color: Colors.red, size: 32),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15.0),
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
