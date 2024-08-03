import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/trash_can_memo_controller.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:simple_note/screens/trash_can/s_trash_can.dart';
import 'package:simple_note/screens/trash_can/s_update_trash_can_memo.dart';

enum SampleItem { updateMemo, deleteMemo, restoreMemo }

class PopupTrashCanButtonWidget extends StatefulWidget {
  const PopupTrashCanButtonWidget(this.index, this.currentContact, {super.key});

  final int index;
  final TrashCanModel currentContact;

  @override
  State<PopupTrashCanButtonWidget> createState() => _PopupTrashCanButtonWidgetState();
}

class _PopupTrashCanButtonWidgetState extends State<PopupTrashCanButtonWidget> {
  SampleItem? selectedItem;
  late String _dropdownValue;
  final memoController = Get.find<MemoController>();
  final trashCanMemoController = Get.find<TrashCanMemoController>();

  File? pickedImage;

  @override
  void initState() {
    super.initState();
    _dropdownValue = '미분류';
    pickedImage = widget.currentContact.imagePath != null ? File(widget.currentContact.imagePath!) : null;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SampleItem>(
      initialValue: selectedItem,
      onSelected: (SampleItem item) {
        setState(() {
          selectedItem = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        PopupMenuItem<SampleItem>(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                // todo: 다른 점
                return UpdateTrashCanMemoPage(index: widget.index, currentContact: widget.currentContact);
              },
            ));
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
                        // 복원한다: 메모장에 넣고, 휴지통에서 지운다.
                        memoController.addCtr(
                          createdAt: widget.currentContact.createdAt,
                          title: widget.currentContact.title,
                          mainText: widget.currentContact.mainText,
                          // 선택한 범주를 가져오려면?
                          selectedCategory: _dropdownValue,
                          isFavoriteMemo: false,
                          imagePath: pickedImage,
                        );
                        // note: 정렬 함수 호출하여 휴지통에서 복원한 메모의 인덱스가 뒤엉키지 않게 설정함.
                        memoController.sortByCreatedAt();
                        trashCanMemoController.deleteCtr(index: widget.index);
                        Navigator.pop(context);
                        // fix: 복원 후 리로드
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
                        trashCanMemoController.deleteCtr(index: widget.index);
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
    );
  }
}
