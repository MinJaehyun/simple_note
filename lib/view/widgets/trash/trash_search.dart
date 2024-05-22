import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_trash_can.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:simple_note/view/screens/trash_can/crud/update_trash_can_memo_page.dart';
import 'package:substring_highlight/substring_highlight.dart';

enum SampleItem { updateMemo, deleteMemo }

class TrashSearch extends StatefulWidget {
  const TrashSearch(this.searchControllerText, {super.key});
  final String searchControllerText;

  @override
  State<TrashSearch> createState() => _TrashSearchState();
}

class _TrashSearchState extends State<TrashSearch> {
  SampleItem? selectedItem;
  late List<TrashCanModel> boxSearchTitleAndMainText;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<TrashCanModel>(TrashCanBox).listenable(),
      builder: (context, Box<TrashCanModel> box, _) {
        if (box.values.isEmpty) return Center(child: Text('휴지통에 검색한 제목이나 내용이 없습니다'));

        boxSearchTitleAndMainText = box.values.where((item) {
          return item.title.contains(widget.searchControllerText) || item.mainText!.contains(widget.searchControllerText);
        }).toList();

        return Container(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: boxSearchTitleAndMainText.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
              mainAxisSpacing: 10, //수평 Padding
              crossAxisSpacing: 10, //수직 Padding
            ),
            itemBuilder: (BuildContext context, int index) {
              TrashCanModel currentContact = boxSearchTitleAndMainText[index];

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return UpdateTrashCanMemoPage(index: index, currentContact: currentContact);
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 13),
                          SubstringHighlight(
                            // text: sortedCard.title,
                            text: currentContact.title,
                            // 검색한 내용 가져오기
                            term: widget.searchControllerText,
                            // non-highlight style
                            textStyle: TextStyle(color: Colors.grey),
                            // highlight style
                            textStyleHighlight: TextStyle(
                              fontSize: 24.0,
                              color: Colors.black,
                              backgroundColor: Colors.yellow,
                            ),
                          ),
                          SizedBox(height: 100),
                          Text(
                            FormatDate().formatDefaultDateKor(currentContact.createdAt),
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      // note: card() 내 수정, 삭제 버튼
                      trailing: Column(
                        children: [
                          PopupMenuButton<SampleItem>(
                            initialValue: selectedItem,
                            onSelected: (SampleItem item) {
                              setState(() {
                                selectedItem = item;
                              });
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                              PopupMenuItem<SampleItem>(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UpdateTrashCanMemoPage(index: index, currentContact: currentContact),
                                    ),
                                  );
                                },
                                value: SampleItem.updateMemo,
                                child: Text('수정'),
                              ),
                              PopupMenuItem<SampleItem>(
                                onTap: () => HiveHelperTrashCan().delete(index),
                                value: SampleItem.deleteMemo,
                                child: Text('삭제'),
                              ),
                            ],
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
