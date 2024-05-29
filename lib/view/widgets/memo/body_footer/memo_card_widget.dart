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

class MemoCardWidget extends StatefulWidget {
  const MemoCardWidget({super.key});

  @override
  State<MemoCardWidget> createState() => _MemoCardWidgetState();
}

class _MemoCardWidgetState extends State<MemoCardWidget> {
  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary);

    return ValueListenableBuilder(
      valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
      builder: (context, Box<MemoModel> box, _) {
        if (box.values.isEmpty) return const Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));

        return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: box.values.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
              mainAxisSpacing: 0, //수평 Padding
              crossAxisSpacing: 0, //수직 Padding
            ),
            itemBuilder: (BuildContext context, int index) {
              // note: 정렬 설정 - firstTime: 오래된 순서로 정렬, lastTime: 생성된 순서로 정렬.
              MemoModel? currentContact = box.getAt(index);
              MemoModel? reversedCurrentContact = box.getAt(box.values.length - 1 - index);
              MemoModel? sortedCard = settingsController.sortedTime == SortedTime.firstTime ? currentContact : reversedCurrentContact;

              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
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
                          // fix: 업데이트 할 때에는 currentContact: sortedCard 넣으면 에러
                          return UpdateMemoPage(index: index, currentContact: currentContact!);
                        }),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.titleHeight,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // todo: 추후, 구글 로그인 이미지 넣기
                                Icon(Icons.account_box, size: 50, color: Colors.grey),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                    sortedCard!.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: style,
                                  ),
                                ),
                                // todo: 메뉴바를 흐릿하게 처리하는 방법? 가로로 나타내는 방법?
                                // note: card() 내 수정, 삭제 버튼
                                MemoCalendarPopupButtonWidget(index, sortedCard),
                              ],
                            ),
                            // todo: 아래 내용 넣기
                            const SizedBox(height: 80.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    FormatDate().formatSimpleTimeKor(sortedCard.createdAt),
                                    style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                  ),
                                ),
                                // note: 배경 즐찾 처리
                                IconButton(
                                  onPressed: () {
                                    HiveHelperMemo().updateMemo(
                                      index: index,
                                      createdAt: currentContact!.createdAt,
                                      title: currentContact.title,
                                      mainText: currentContact.mainText,
                                      selectedCategory: currentContact.selectedCategory,
                                      isFavoriteMemo: !currentContact.isFavoriteMemo!,
                                    );
                                  },
                                  // note: 동적 처리 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
                                  icon: currentContact?.isFavoriteMemo == false
                                      ? Icon(Icons.star_border_sharp, color: null)
                                      : Icon(Icons.star, color: Colors.red),
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
