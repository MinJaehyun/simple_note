import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/update_memo_page.dart';
import 'package:simple_note/view/widgets/public/memo_calendar_popup_button_widget.dart';

enum SampleItem { updateMemo, deleteMemo }

class MemoSelectedCategoryWidget extends StatefulWidget {
  const MemoSelectedCategoryWidget(this.selectedCategory, {super.key});

  final String? selectedCategory;

  @override
  State<MemoSelectedCategoryWidget> createState() => _MemoSelectedCategoryWidgetState();
}

class _MemoSelectedCategoryWidgetState extends State<MemoSelectedCategoryWidget> {
  SampleItem? selectedItem;
  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary);

    return ValueListenableBuilder(
      valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
      builder: (context, Box<MemoModel> box, _) {
        if (box.values.isEmpty) return const Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));

        List<MemoModel> memo = box.values.where((item) {
          return item.selectedCategory == widget.selectedCategory;
        }).toList();

        // note: 선택한 카테고리의 원조 모든 메모에 인덱스를 가져오는 방법
        List<MemoModel> memoList = box.values.toList();
        List<int> selectedIndices = [];
        for (int i = 0; i < memoList.length; i++) {
          if (memoList[i].selectedCategory == widget.selectedCategory) {
            selectedIndices.add(i);
          }
        }

        // note: 위 내용을 개선하면 아래와 같다
        // memoList.asMap().forEach((index, item) {
        //   if (item.selectedCategory == widget.selectedCategory) {
        //     selectedIndices.add(index);
        //   }
        // });
        // note: 현재 문제점: 프로젝트에 치중하다보니, 알고리즘을 손 놓게 됐는데, 위에 코드는 기본 알고리즘 풀이 능력되면 쉽게 풀 수 있으므로, 알고리즘도 같이 진행하도록 한다!

        return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: memo.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (BuildContext context, int index) {
              MemoModel? currentContact = memo[index];
              MemoModel? reversedCurrentContact = memo[memo.length - 1 - index];
              MemoModel? sortedCard = settingsController.sortedTime == SortedTime.firstTime ? currentContact : reversedCurrentContact;

              // print(box.values.length);

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
                        return UpdateMemoPage(index: index, currentContact: sortedCard);
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
                                  onPressed: (){

                                  },
                                  icon: Icon(Icons.account_box),
                                  padding: EdgeInsets.zero, // 패딩 설정
                                  constraints: BoxConstraints(),
                                  iconSize: 50,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                    sortedCard.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: style,
                                  ),
                                ),
                                // todo: 아래 2번째 인자가 다르다
                                MemoCalendarPopupButtonWidget(index, currentContact),
                              ],
                            ),
                            const SizedBox(height: 90.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    FormatDate().formatSimpleTimeKor(sortedCard.createdAt),
                                    style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    HiveHelperMemo().updateMemo(
                                      index: selectedIndices[index],
                                      createdAt: currentContact.createdAt,
                                      title: currentContact.title,
                                      mainText: currentContact.mainText,
                                      selectedCategory: currentContact.selectedCategory,
                                      isFavoriteMemo: !currentContact.isFavoriteMemo!,
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
