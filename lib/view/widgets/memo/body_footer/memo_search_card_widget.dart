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
import 'package:substring_highlight/substring_highlight.dart';

class MemoSearchCardWidget extends StatefulWidget {
  const MemoSearchCardWidget(this.searchControllerText, {super.key});

  final String? searchControllerText;

  @override
  State<MemoSearchCardWidget> createState() => _MemoSearchCardWidgetState();
}

class _MemoSearchCardWidgetState extends State<MemoSearchCardWidget> {
  final memoController = Get.find<MemoController>();
  final settingsController = Get.find<SettingsController>();
  List<MemoModel> sortedMemoList = [];
  List<MemoModel> reverseSortedMemoList = [];
  List<MemoModel> searchList = [];
  List<MemoModel> searchAndFavoriteList = [];

  @override
  void initState() {
    super.initState();
    updateSortedLists();
  }

  void updateSortedLists() {
    sortedMemoList = List.from(memoController.memoList)..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    reverseSortedMemoList = List.from(memoController.memoList)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void updateMemoFunc(
    index,
    sortedCard, {
    final bool? isFavoriteMemo,
    final bool? isCheckedTodo,
    final File? imagePath,
  }) {
    memoController.updateCtr(
      index: settingsController.sortedTime.value == SortedTime.firstTime ? index : memoController.memoList.length - index - 1,
      createdAt: sortedCard.createdAt,
      title: sortedCard.title,
      mainText: sortedCard.mainText,
      selectedCategory: sortedCard.selectedCategory,
      isFavoriteMemo: isFavoriteMemo ?? false,
      isCheckedTodo: isCheckedTodo ?? false,
      imagePath: sortedCard.imagePath != null ? File(sortedCard.imagePath!) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (memoController.memoList.isEmpty) return const Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));

        List<MemoModel> selectedMemoList = settingsController.sortedTime.value == SortedTime.firstTime ? sortedMemoList : reverseSortedMemoList;
        List<MemoModel> favoriteMemoList = selectedMemoList.where((item) => item.isFavoriteMemo == true).toList();

        searchList = memoController.memoList.where((item) {
          return item.title.contains(widget.searchControllerText!) || item.mainText!.contains(widget.searchControllerText!);
        }).toList();

        searchAndFavoriteList = favoriteMemoList.where((item) {
          return item.title.contains(widget.searchControllerText!) || item.mainText!.contains(widget.searchControllerText!);
        }).toList();

        return SizedBox(
          // fix: height: MediaQuery.of(context).size.height - 270,
          height: MediaQuery.of(context).size.height - (kBottomNavigationBarHeight * 5),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: settingsController.isAppbarFavoriteMemo.value == true ? searchAndFavoriteList.length : searchList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (BuildContext context, int index) {
              MemoModel? currentContact = settingsController.isAppbarFavoriteMemo.value == true ? searchAndFavoriteList[index] : searchList[index];
              int sortedIndex = memoController.memoList.indexOf(currentContact);

              return Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
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
                                    color: settingsController.isThemeMode.value == false
                                        ? Colors.black.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.3),
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
                                Expanded(
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10.0),
                                      Expanded(
                                        child: SubstringHighlight(
                                          text: currentContact.title,
                                          // 검색한 내용 가져오기
                                          term: widget.searchControllerText,
                                          // non-highlight style
                                          textStyle: const TextStyle(
                                            color: Colors.grey,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // highlight style
                                          textStyleHighlight: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 24.0,
                                            color: Colors.black,
                                            backgroundColor: Colors.yellow,
                                            // decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      // note: card() 내 수정, 삭제 버튼
                                      MemoCalendarPopupButtonWidget(sortedIndex, currentContact),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        FormatDate().formatSimpleTimeKor(currentContact.createdAt),
                                        // style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                        style: TextStyle(color: Theme.of(context).colorScheme.secondary.withOpacity(0.9)),
                                      ),
                                    ),
                                    // 체크 버튼
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      visualDensity: const VisualDensity(horizontal: -4.0),
                                      icon: currentContact.isCheckedTodo == false
                                          ? const Icon(Icons.check_box_outline_blank, size: 32)
                                          : const Icon(Icons.check_box, color: Colors.red, size: 32),
                                      onPressed: () {
                                        updateMemoFunc(
                                          index,
                                          currentContact,
                                          isFavoriteMemo: currentContact.isFavoriteMemo!,
                                          isCheckedTodo: !currentContact.isCheckedTodo!,
                                          imagePath: currentContact.imagePath != null ? File(currentContact.imagePath!) : null,
                                        );
                                      },
                                    ),
                                    // 즐겨 찾기
                                    IconButton(
                                      onPressed: () {
                                        updateMemoFunc(
                                          index,
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
