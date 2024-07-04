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

class MemoCardWidget extends StatefulWidget {
  const MemoCardWidget({super.key});

  @override
  State<MemoCardWidget> createState() => _MemoCardWidgetState();
}

class _MemoCardWidgetState extends State<MemoCardWidget> {
  final settingsController = Get.find<SettingsController>();
  final memoController = Get.find<MemoController>();
  List<MemoModel> reverseSortedMemoList = [];
  List<MemoModel> sortedMemoList = [];

  @override
  void initState() {
    super.initState();
    updateSortedLists();
  }

  void updateSortedLists() {
    sortedMemoList = List.from(memoController.memoList)..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    reverseSortedMemoList = List.from(memoController.memoList)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold);
    return Obx(
      () {
        if (memoController.memoList.isEmpty) {
          return const Column(
            children: [SizedBox(height: 200), Text('메모를 생성해 주세요')],
          );
        }
        // note: 상단 함수를 실행해야, 리로드 된다
        updateSortedLists();
        // note: 주의: 아래 설정은 build 이하에 작성하면 error 발생한다.
        // note: 선택된 정렬에 따라 올바른 리스트를 선택합니다.
        List<MemoModel> selectedMemoList = settingsController.sortedTime.value == SortedTime.firstTime ? sortedMemoList : reverseSortedMemoList;
        List<MemoModel> favoriteMemoList = selectedMemoList.where((item) => item.isFavoriteMemo == true).toList();

        return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            // note: *** 앱바 클릭 상태 유무에 따라, 즐겨찾기 또는 전체 메모의 개수만큼 내려준다 ***
            itemCount: settingsController.isAppbarFavoriteMemo.value == true ? favoriteMemoList.length : selectedMemoList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (BuildContext context, int index) {
              MemoModel? currentContact = settingsController.isAppbarFavoriteMemo.value == true ? favoriteMemoList[index] : selectedMemoList[index];
              int sortedIndex = memoController.memoList.indexOf(currentContact);

              return Card(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey, width: 0.1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: CustomPaint(
                  painter: GridPainter(),
                  child: InkWell(
                    onTap: () => Get.to(UpdateMemoPage(index: sortedIndex, sortedCard: currentContact)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),

                      // note: Stack() 내에 Container() 와 ListTile()는 동일 depth에 존재한다
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
                                    Expanded(
                                      child: Text(currentContact.title, overflow: TextOverflow.ellipsis, style: style),
                                    ),
                                    // note: card() 내 수정, 삭제 버튼
                                    MemoCalendarPopupButtonWidget(sortedIndex, currentContact),
                                  ],
                                ),
                                const SizedBox(height: 80.0),
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        FormatDate().formatSimpleTimeKor(currentContact.createdAt),
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
                                        _updateMemoFunc(
                                          currentContact,
                                          isFavoriteMemo: currentContact.isFavoriteMemo!,
                                          isCheckedTodo: !currentContact.isCheckedTodo!,
                                          imagePath: currentContact.imagePath != null ? File(currentContact.imagePath!) : null,
                                        );
                                      },
                                    ),
                                    // 즐겨 찾기
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: currentContact.isFavoriteMemo == false
                                          ? const Icon(Icons.star_border_sharp, color: null, size: 32)
                                          : const Icon(Icons.star, color: Colors.red, size: 32),
                                      onPressed: () {
                                        _updateMemoFunc(
                                          currentContact,
                                          isFavoriteMemo: !currentContact.isFavoriteMemo!,
                                          isCheckedTodo: currentContact.isCheckedTodo!,
                                          imagePath: currentContact.imagePath != null ? File(currentContact.imagePath!) : null,
                                        );
                                      },
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

  // *** note: 두 상태가 변경될 때 memoController.updateCtr 메서드를 함께 호출하여, 동시에 상태를 업데이트하도록 할 수 있습니다. 이를 위해서는 _updateMemo 메서드를 개선함 ***
  void _updateMemoFunc(
    currentContact, {
    final bool? isFavoriteMemo,
    final bool? isCheckedTodo,
    final File? imagePath,
  }) {
    memoController.updateCtr(
        index: memoController.memoList.indexOf(currentContact),
        createdAt: currentContact.createdAt,
        title: currentContact.title,
        mainText: currentContact.mainText,
        selectedCategory: currentContact.selectedCategory,
        isFavoriteMemo: isFavoriteMemo ?? false,
        isCheckedTodo: isCheckedTodo ?? false,
        imagePath: currentContact.imagePath != null ? File(currentContact.imagePath) : null,
    );
  }
}
