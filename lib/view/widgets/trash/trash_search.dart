import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_trash_can.dart';
import 'package:simple_note/helper/grid_painter.dart';
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
        if (box.values.isEmpty) return const Center(child: Text('휴지통에 검색한 제목이나 내용이 없습니다'));

        boxSearchTitleAndMainText = box.values.where((item) {
          return item.title.contains(widget.searchControllerText) || item.mainText!.contains(widget.searchControllerText);
        }).toList();

        return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: boxSearchTitleAndMainText.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
              mainAxisSpacing: 0, //수평 Padding
              crossAxisSpacing: 0, //수직 Padding
            ),
            itemBuilder: (BuildContext context, int index) {
              TrashCanModel currentContact = boxSearchTitleAndMainText[index];

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
                        return UpdateTrashCanMemoPage(index: index, currentContact: currentContact);
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
                            Expanded(
                              child: Row(
                                children: [
                                  // todo: 추후, 구글 로그인 이미지 넣기
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.account_box),
                                    padding: EdgeInsets.zero,
                                    // 패딩 설정
                                    constraints: const BoxConstraints(),
                                    iconSize: 50,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SubstringHighlight(
                                      // text: sortedCard.title,
                                      text: currentContact.title,
                                      // 검색한 내용 가져오기
                                      term: widget.searchControllerText,
                                      // non-highlight style
                                      textStyle: const TextStyle(
                                        color: Colors.grey,
                                        overflow: TextOverflow.ellipsis,
                                        height: 1.0, // 여기에서 높이를 조절합니다.
                                      ),
                                      // highlight style
                                      textStyleHighlight: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                        backgroundColor: Colors.yellow,
                                      ),
                                    ),
                                  ),
                                  // note: card() 내 수정, 삭제 버튼
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
                                        child: const Text('수정'),
                                      ),
                                      PopupMenuItem<SampleItem>(
                                        onTap: () => HiveHelperTrashCan().delete(index),
                                        value: SampleItem.deleteMemo,
                                        child: const Text('삭제'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 90),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    FormatDate().formatSimpleTimeKor(currentContact.createdAt),
                                    style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                  ),
                                ),
                                const IconButton(
                                  onPressed: null,
                                  icon: SizedBox.shrink(), // 비어있는 아이콘 버튼
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
