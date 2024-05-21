import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/view/widgets/home/popup_menu_button_widget.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:simple_note/view/screens/crud_memo/update_memo.dart';
import 'package:substring_highlight/substring_highlight.dart';

enum SampleItem { updateMemo, deleteMemo }

class HomeSearchWidget extends StatefulWidget {
  const HomeSearchWidget(this.searchControllerText, this.sortedTime, {super.key});

  final String? searchControllerText;
  final SortedTime? sortedTime;

  @override
  State<HomeSearchWidget> createState() => _HomeSearchWidgetState();
}

class _HomeSearchWidgetState extends State<HomeSearchWidget> {
  SampleItem? selectedItem;
  late List<MemoModel> boxSearchTitleAndMainText;
  // late String _dropdownValue;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _dropdownValue = '미분류';
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
      builder: (context, Box<MemoModel> box, _) {
        if (box.values.isEmpty) return Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));
        boxSearchTitleAndMainText = box.values.where((item) {
          return item.title.contains(widget.searchControllerText!) || item.mainText!.contains(widget.searchControllerText!);
        }).toList();

        return Container(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: boxSearchTitleAndMainText.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1/1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (BuildContext context, int index) {
              // note: MemoModel? currentContact = box.getAt(index);
              MemoModel currentContact = boxSearchTitleAndMainText[index];
              MemoModel? reversedCurrentContact = boxSearchTitleAndMainText[boxSearchTitleAndMainText.length - 1 - index];
              var sortedCard = widget.sortedTime == SortedTime.firstTime ? currentContact : reversedCurrentContact;

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return UpdateMemo(index: index, currentContact: sortedCard);
                      }),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.0),
                          SubstringHighlight(
                            text: sortedCard.title,
                            // 검색한 내용 가져오기
                            term: widget.searchControllerText,
                            // non-highlight style
                            textStyle: TextStyle(color: Colors.grey),
                            // highlight style
                            textStyleHighlight: TextStyle(
                              fontSize: 24.0,
                              color: Colors.black,
                              backgroundColor: Colors.yellow,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                          SizedBox(height: 100),
                          Text(FormatDate().formatDefaultDateKor(sortedCard.createdAt), style: TextStyle(color: Colors.grey.withOpacity(0.9))),
                        ],
                      ),
                      // note: card() 내 수정, 삭제 버튼
                      trailing: PopupMenuButtonWidget(index, sortedCard),
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
