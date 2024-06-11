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

  // note: 아래 2개의 bool 타입은 사용중인 요소이다
  late bool _isCheckedTodo;
  late bool _isFavoriteMemo;

  @override
  Widget build(BuildContext context) {
    // fixme: 정렬은 아래처럼 하는게 아니다.. 시간 순으로 정렬하는 것이다.. 대규모 수정 예상..
    List<MemoModel> sortedMemoList = List.from(memoController.memoList)..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    List<MemoModel> reverseSortedMemoList = List.from(memoController.memoList)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    TextStyle style = TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary);

    // return ValueListenableBuilder(
    //   valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
    //   builder: (context, Box<MemoModel> box, _) {
    return Obx(() {
        if (memoController.memoList.isEmpty) {
          return Column(
            children: [
              SizedBox(height: 200),
              Text('메모를 생성해 주세요'),
            ],
          );
        }

        // note: 선택된 정렬에 따라 올바른 리스트를 선택합니다.
        List<MemoModel> selectedMemoList = settingsController.sortedTime == SortedTime.firstTime ? sortedMemoList : reverseSortedMemoList;


        return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: selectedMemoList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
              mainAxisSpacing: 0, //수평 Padding
              crossAxisSpacing: 0, //수직 Padding
            ),
            itemBuilder: (BuildContext context, int index) {
              MemoModel? currentContact = selectedMemoList[index];
              var sortedIndex = memoController.memoList.indexOf(currentContact);

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
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return UpdateMemoPage(index: sortedIndex, sortedCard: currentContact);
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
                            Row(
                              children: [
                                // todo: 추후, 구글 로그인 이미지 넣기: memoController.memoList[index]
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.account_box),
                                  padding: EdgeInsets.zero,
                                  // 패딩 설정
                                  constraints: const BoxConstraints(),
                                  iconSize: 50,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                    // memoController.memoList[index].title,
                                    currentContact.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: style,
                                  ),
                                ),
                                // card() 내 수정, 삭제 버튼
                                MemoCalendarPopupButtonWidget(sortedIndex, currentContact),

                              ],
                            ),
                            // todo: 아래 ?내용 넣기
                            const SizedBox(height: 90.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    // FormatDate().formatSimpleTimeKor(memoController.memoList[index].createdAt),
                                    FormatDate().formatSimpleTimeKor(currentContact.createdAt),
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

                                  // icon: memoController.memoList[index].isCheckedTodo == false
                                  icon: currentContact.isCheckedTodo == false
                                      ? const Icon(Icons.check_box_outline_blank)
                                      : const Icon(Icons.check_box, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _isCheckedTodo = !memoController.memoList[index].isCheckedTodo!;
                                    });
                                    memoController.updateCtr(
                                      // index: settingsController.sortedTime == SortedTime.firstTime ? index : box.values.length - index - 1,
                                      index: memoController.memoList.indexOf(currentContact),
                                      createdAt: currentContact.createdAt,
                                      title: currentContact.title,
                                      mainText: currentContact.mainText,
                                      selectedCategory: currentContact.selectedCategory,
                                      isFavoriteMemo: currentContact.isFavoriteMemo!,
                                      isCheckedTodo: !currentContact.isCheckedTodo!,
                                    );
                                  },
                                ),
                                // 즐겨 찾기
                                IconButton(
                                  padding: EdgeInsets.zero, // 아이콘 버튼 내부의 패딩 제거
                                  constraints: BoxConstraints(), // 기본 제약조건 제거
                                  // visualDensity: VisualDensity(horizontal: -4.0),
                                  // 동적 처리
                                  icon: currentContact.isFavoriteMemo == false
                                      ? const Icon(Icons.star_border_sharp, color: null)
                                      : const Icon(Icons.star, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _isFavoriteMemo = !memoController.memoList[index].isFavoriteMemo!;
                                    });
                                    memoController.updateCtr(
                                      // index: index,
                                      index: memoController.memoList.indexOf(currentContact),
                                      createdAt: currentContact.createdAt,
                                      title: currentContact.title,
                                      mainText: currentContact.mainText,
                                      selectedCategory: currentContact.selectedCategory,
                                      isFavoriteMemo: !currentContact.isFavoriteMemo!,
                                      isCheckedTodo: currentContact.isCheckedTodo!,
                                    );
                                  },
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
