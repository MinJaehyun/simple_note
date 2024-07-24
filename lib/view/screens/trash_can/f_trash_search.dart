import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/controller/trash_can_memo_controller.dart';
import 'package:simple_note/view/screens/public/w_grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:simple_note/view/screens/trash_can/s_trash_can.dart';
import 'package:simple_note/view/screens/trash_can/s_update_trash_can_memo.dart';
import 'package:substring_highlight/substring_highlight.dart';

enum SampleItem { updateMemo, deleteMemo, restoreMemo }

class TrashSearch extends StatefulWidget {
  const TrashSearch(this.searchControllerText, {super.key});

  final String searchControllerText;

  @override
  State<TrashSearch> createState() => _TrashSearchState();
}

class _TrashSearchState extends State<TrashSearch> {
  SampleItem? selectedItem;
  late String _dropdownValue;
  late List<TrashCanModel> boxSearchTitleAndMainText;
  final trashCanMemoController = Get.find<TrashCanMemoController>();
  late final settingsController = Get.find<SettingsController>();
  final memoController = Get.find<MemoController>();

  File? pickedImage;

  @override
  void initState() {
    _dropdownValue = '미분류';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (trashCanMemoController.trashCanMemoList.isEmpty) return const Center(child: Text('휴지통에 검색한 제목이나 내용이 없습니다'));

        boxSearchTitleAndMainText = trashCanMemoController.trashCanMemoList.where((item) {
          return item.title.contains(widget.searchControllerText) || item.mainText!.contains(widget.searchControllerText);
        }).toList();

        return SizedBox(
          // fix: height: MediaQuery.of(context).size.height - 270,
          height: MediaQuery.of(context).size.height - (kBottomNavigationBarHeight * 5),
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
                            height: 200,
                            decoration: currentContact.imagePath != null
                            // 이미지 있는 경우: 이미지만 처리
                                ? BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(currentContact.imagePath!)),
                                fit: BoxFit.cover,
                              ),
                            )
                            // 이미지 없는 경우: 그라데이션 처리
                                : BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: settingsController.isThemeMode.value == false
                                    ? [Colors.white.withOpacity(0.5), Colors.transparent]
                                    : [Colors.black.withOpacity(0.5), Colors.transparent],
                              ),
                            ),
                          ),
                          if (currentContact.imagePath != null)
                          // 이미지 있는 경우: 전체 블러 효과
                            Positioned(
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.white12.withOpacity(1), Colors.transparent],
                                  ),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                  child: Container(
                                    // 상단 투명 조정
                                    color: settingsController.isThemeMode.value == false
                                        ? Colors.black.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.3),
                                  ),
                                ),
                              ),
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
                                                  // todo: 다른 점
                                                  builder: (context) => UpdateTrashCanMemoPage(index: index, currentContact: currentContact),
                                                ),
                                              );
                                            },
                                            value: SampleItem.updateMemo,
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text('수정'),
                                                SizedBox(width: 8),
                                                Icon(Icons.create_outlined),
                                              ],
                                            ),
                                          ),

                                          PopupMenuItem<SampleItem>(
                                            value: SampleItem.restoreMemo,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("메모를 복원 하시겠습니까?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          memoController.addCtr(
                                                            createdAt: currentContact.createdAt,
                                                            title: currentContact.title,
                                                            mainText: currentContact.mainText,
                                                            selectedCategory: _dropdownValue,
                                                            isFavoriteMemo: false,
                                                            imagePath: File(currentContact.imagePath!),
                                                          );
                                                          trashCanMemoController.deleteCtr(index: index);
                                                          Navigator.pop(context);
                                                          Get.offAll(const TrashCanPage());
                                                        },
                                                        child: const Text('복원'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text('취소'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text('복원', style: TextStyle(color: Colors.green)),
                                                SizedBox(width: 8),
                                                Icon(Icons.restore_from_trash_outlined, color: Colors.green)
                                              ],
                                            ),
                                          ),

                                          PopupMenuItem<SampleItem>(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("메모를 완전히 삭제 하시겠습니까?"),
                                                    actions: [
                                                      TextButton.icon(
                                                        onPressed: () {
                                                          trashCanMemoController.deleteCtr(index: index);
                                                          Navigator.pop(context);
                                                          Get.offAll(const TrashCanPage());
                                                        },
                                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                                        label: const Text('완전히 삭제', style: TextStyle(color: Colors.red)),
                                                      ),
                                                      TextButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close), label: const Text('취소')),
                                                    ],
                                                    elevation: 24.0,
                                                  );
                                                },
                                              );
                                            },
                                            value: SampleItem.deleteMemo,
                                            child: const Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text('완전히 삭제', style: TextStyle(color: Colors.red)),
                                                Icon(Icons.delete_outline, color: Colors.red),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        FormatDate().formatSimpleTimeKor(currentContact.createdAt),
                                        // style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                        style: TextStyle(color: Theme.of(context).colorScheme.secondary.withOpacity(0.9)),
                                      ),
                                    ),
                                    const IconButton(
                                      onPressed: null,
                                      // 비어있는 아이콘 버튼
                                      icon: SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
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
