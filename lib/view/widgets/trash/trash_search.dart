import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/trash_can_memo_controller.dart';
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
  final trashCanMemoController = Get.find<TrashCanMemoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (trashCanMemoController.trashCanMemoList.isEmpty) return const Center(child: Text('휴지통에 검색한 제목이나 내용이 없습니다'));

        boxSearchTitleAndMainText = trashCanMemoController.trashCanMemoList.where((item) {
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
                      child: Stack(
                        children: [
                          Container(
                            decoration: currentContact.imagePath != null
                                ? BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(currentContact.imagePath!)),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const BoxDecoration(),
                          ),
                          if (currentContact.imagePath != null)
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                              child: Container(color: Colors.black.withOpacity(0.2)),
                            ),
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.titleHeight,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SubstringHighlight(
                                          text: currentContact.title,
                                          // 검색한 내용 가져오기
                                          term: widget.searchControllerText,
                                          // non-highlight style
                                          textStyle: const TextStyle(
                                            color: Colors.grey,
                                            overflow: TextOverflow.ellipsis,
                                            height: 1.0,
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
                                            onTap: () => trashCanMemoController.deleteCtr(index: index),
                                            value: SampleItem.deleteMemo,
                                            child: const Text('삭제'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 80),
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        FormatDate().formatSimpleTimeKor(currentContact.createdAt),
                                        style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                      ),
                                    ),
                                    const IconButton(
                                      onPressed: null,
                                      // 비어있는 아이콘 버튼
                                      icon: SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
