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
  SampleItem? selectedItem;
  late List<MemoModel> boxSearchTitleAndMainText;
  final settingsController = Get.find<SettingsController>();
  final memoController = Get.find<MemoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
              // note: MemoModel? currentContact = box.getAt(index);
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
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return UpdateMemoPage(index: index, sortedCard: sortedCard);
                        }),
                      );
                    },
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
                                  // todo: 추후, 구글 로그인 이미지 넣기
                                  const Icon(Icons.account_box, size: 50, color: Colors.grey),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    // todo: 아래 부분만 다르므로, 이를 위젯으로 처리하면 리펙토링 가능할 듯
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
                                  // 아이콘 버튼 내부의 패딩 제거
                                  constraints: BoxConstraints(),
                                  // 기본 제약조건 제거
                                  visualDensity: VisualDensity(horizontal: -4.0),
                                  icon: sortedCard.isCheckedTodo == false
                                      ? Icon(Icons.check_box_outline_blank)
                                      : Icon(Icons.check_box, color: Colors.red),
                                  onPressed: () {
                                    memoController.updateCtr(
                                      index: settingsController.sortedTime == SortedTime.firstTime ? index : memoController.memoList.length - index - 1,
                                      createdAt: sortedCard.createdAt,
                                      title: sortedCard.title,
                                      mainText: sortedCard.mainText,
                                      selectedCategory: sortedCard.selectedCategory,
                                      isFavoriteMemo: sortedCard.isFavoriteMemo!,
                                      isCheckedTodo: !sortedCard.isCheckedTodo!,
                                    );
                                  },
                                ),
                                // 즐겨 찾기
                                IconButton(
                                  onPressed: () {
                                    memoController.updateCtr(
                                      index: settingsController.sortedTime == SortedTime.firstTime
                                          ? selectedIndices[index]
                                          : selectedIndices.length - 1 - index,
                                      createdAt: sortedCard.createdAt,
                                      title: sortedCard.title,
                                      mainText: sortedCard.mainText,
                                      selectedCategory: sortedCard.selectedCategory,
                                      isFavoriteMemo: !sortedCard.isFavoriteMemo!,
                                      isCheckedTodo: sortedCard.isCheckedTodo!,
                                    );
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
