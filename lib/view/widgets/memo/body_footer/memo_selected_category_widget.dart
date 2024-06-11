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
  SampleItem? selectedItem;
  final settingsController = Get.find<SettingsController>();
  final memoController = Get.find<MemoController>();

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
            settingsController.sortedTime == SortedTime.firstTime ? sortedSelectedCategoryMemo : reversedSelectedCategoryMemo;

        return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: sameCategoryMemo.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (BuildContext context, int index) {
              MemoModel? currentContact = selectedMemoList[index];
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
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return UpdateMemoPage(index: sortedIndex, sortedCard: currentContact);
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.titleHeight,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // todo: 추후, 구글 로그인 이미지 넣기
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.account_box),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  iconSize: 50,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                    currentContact.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: style,
                                  ),
                                ),
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
                                  constraints: BoxConstraints(),
                                  visualDensity: VisualDensity(horizontal: -4.0),
                                  onPressed: () {
                                    memoController.updateCtr(
                                      index: sortedIndex,
                                      createdAt: currentContact.createdAt,
                                      title: currentContact.title,
                                      mainText: currentContact.mainText,
                                      selectedCategory: currentContact.selectedCategory,
                                      isFavoriteMemo: currentContact.isFavoriteMemo!,
                                      isCheckedTodo: !currentContact.isCheckedTodo!,
                                    );
                                  },
                                  icon: currentContact.isCheckedTodo == false
                                      ? const Icon(Icons.check_box_outline_blank, color: null)
                                      : const Icon(Icons.check_box, color: Colors.red),
                                ),
                                // 즐겨 찾기
                                IconButton(
                                  onPressed: () {
                                    memoController.updateCtr(
                                      index: sortedIndex,
                                      createdAt: currentContact.createdAt,
                                      title: currentContact.title,
                                      mainText: currentContact.mainText,
                                      selectedCategory: currentContact.selectedCategory,
                                      isFavoriteMemo: !currentContact.isFavoriteMemo!,
                                      isCheckedTodo: currentContact.isCheckedTodo!,
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
