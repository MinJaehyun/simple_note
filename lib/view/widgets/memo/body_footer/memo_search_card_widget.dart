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

enum SampleItem { updateMemo, deleteMemo }

class MemoSearchCardWidget extends StatefulWidget {
  const MemoSearchCardWidget(this.searchControllerText, {super.key});

  final String? searchControllerText;

  @override
  State<MemoSearchCardWidget> createState() => _MemoSearchCardWidgetState();
}

class _MemoSearchCardWidgetState extends State<MemoSearchCardWidget> {
  final memoController = Get.find<MemoController>();
  final settingsController = Get.find<SettingsController>();
  List<MemoModel> boxSearchTitleAndMainText = [];
  SampleItem? selectedItem;

  void updateMemoFunc(
    index,
    sortedCard, {
    final bool? isFavoriteMemo,
    final bool? isCheckedTodo,
  }) {
    memoController.updateCtr(
      index: settingsController.sortedTime == SortedTime.firstTime ? index : memoController.memoList.length - index - 1,
      createdAt: sortedCard.createdAt,
      title: sortedCard.title,
      mainText: sortedCard.mainText,
      selectedCategory: sortedCard.selectedCategory,
      isFavoriteMemo: isFavoriteMemo ?? false,
      isCheckedTodo: isCheckedTodo ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (memoController.memoList.isEmpty) return const Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));
        boxSearchTitleAndMainText = memoController.memoList.where((item) {
          return item.title.contains(widget.searchControllerText!) || item.mainText!.contains(widget.searchControllerText!);
        }).toList();

        // note: 검색한 제목이나 내용의 원조 모든 메모에 인덱스를 가져오는 방법
        List<MemoModel> memoList = memoController.memoList;
        List<int> selectedIndices = [];
        for (int i = 0; i < memoList.length; i++) {
          if (memoList[i].title.contains(widget.searchControllerText!) || memoList[i].mainText!.contains(widget.searchControllerText!)) {
            selectedIndices.add(i);
          }
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: boxSearchTitleAndMainText.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (BuildContext context, int index) {
              MemoModel currentContact = boxSearchTitleAndMainText[index];
              MemoModel? reversedCurrentContact = boxSearchTitleAndMainText[boxSearchTitleAndMainText.length - 1 - index];
              MemoModel? sortedCard = settingsController.sortedTime == SortedTime.firstTime ? currentContact : reversedCurrentContact;

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
                    onTap: () => Get.to(UpdateMemoPage(index: index, sortedCard: sortedCard)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
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
                                      text: sortedCard.title,
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
                                  MemoCalendarPopupButtonWidget(index, sortedCard),
                                ],
                              ),
                            ),
                            const SizedBox(height: 80),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    FormatDate().formatSimpleTimeKor(sortedCard.createdAt),
                                    style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                  ),
                                ),
                                // 체크 버튼
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  visualDensity: const VisualDensity(horizontal: -4.0),
                                  icon: sortedCard.isCheckedTodo == false
                                      ? const Icon(Icons.check_box_outline_blank)
                                      : const Icon(Icons.check_box, color: Colors.red),
                                  onPressed: () {
                                    updateMemoFunc(index, sortedCard,
                                        isFavoriteMemo: sortedCard.isFavoriteMemo!, isCheckedTodo: !sortedCard.isCheckedTodo!);
                                  },
                                ),
                                // 즐겨 찾기
                                IconButton(
                                  onPressed: () {
                                    updateMemoFunc(index, sortedCard,
                                        isFavoriteMemo: !sortedCard.isFavoriteMemo!, isCheckedTodo: sortedCard.isCheckedTodo!);
                                  },
                                  icon: currentContact.isFavoriteMemo == false
                                      ? const Icon(Icons.star_border_sharp, color: null)
                                      : const Icon(Icons.star, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
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
