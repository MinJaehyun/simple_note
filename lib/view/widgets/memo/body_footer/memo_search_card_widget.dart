import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/update_memo_page.dart';
import 'package:simple_note/view/widgets/public/memo_calendar_popup_button_widget.dart';
import 'package:substring_highlight/substring_highlight.dart';

enum SampleItem { updateMemo, deleteMemo }

class MemoSearchCardWidget extends StatefulWidget {
  const MemoSearchCardWidget(this.searchControllerText, this.sortedTime, {super.key});

  final String? searchControllerText;
  final SortedTime? sortedTime;

  @override
  State<MemoSearchCardWidget> createState() => _MemoSearchCardWidgetState();
}

class _MemoSearchCardWidgetState extends State<MemoSearchCardWidget> {
  SampleItem? selectedItem;
  late List<MemoModel> boxSearchTitleAndMainText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
      builder: (context, Box<MemoModel> box, _) {
        if (box.values.isEmpty) return const Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));
        boxSearchTitleAndMainText = box.values.where((item) {
          return item.title.contains(widget.searchControllerText!) || item.mainText!.contains(widget.searchControllerText!);
        }).toList();

        return Container(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: boxSearchTitleAndMainText.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1/1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (BuildContext context, int index) {
              // note: MemoModel? currentContact = box.getAt(index);
              MemoModel currentContact = boxSearchTitleAndMainText[index];
              MemoModel? reversedCurrentContact = boxSearchTitleAndMainText[boxSearchTitleAndMainText.length - 1 - index];
              MemoModel? sortedCard = widget.sortedTime == SortedTime.firstTime ? currentContact : reversedCurrentContact;

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
                          return UpdateMemoPage(index: index, currentContact: sortedCard);
                        }),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10.0),
                            SubstringHighlight(
                              text: sortedCard.title,
                              // 검색한 내용 가져오기
                              term: widget.searchControllerText,
                              // non-highlight style
                              textStyle: const TextStyle(color: Colors.grey),
                              // highlight style
                              textStyleHighlight: const TextStyle(
                                fontSize: 24.0,
                                color: Colors.black,
                                backgroundColor: Colors.yellow,
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(height: 100),
                            Text(FormatDate().formatDefaultDateKor(sortedCard.createdAt), style: TextStyle(color: Colors.grey.withOpacity(0.9))),
                          ],
                        ),
                        // note: card() 내 수정, 삭제 버튼
                        trailing: MemoCalendarPopupButtonWidget(index, sortedCard),
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
