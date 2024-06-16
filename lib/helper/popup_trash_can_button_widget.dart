import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/trash_can_memo_controller.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:simple_note/view/screens/trash_can/crud/update_trash_can_memo_page.dart';
import 'package:simple_note/view/screens/trash_can/trash_can_page.dart';

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

  @override
  void initState() {
    super.initState();
    _dropdownValue = '미분류';
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
                return UpdateTrashCanMemoPage(index: widget.index, currentContact: widget.currentContact);
              },
            ));
          },
          value: SampleItem.updateMemo,
          child: const Text('수정'),
        ),
        PopupMenuItem<SampleItem>(
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
                        );
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
          value: SampleItem.restoreMemo,
          child: const Text('복원'),
        ),
        PopupMenuItem<SampleItem>(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("메모를 완전히 삭제 하시겠습니까?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          // 완전히 삭제
                          trashCanMemoController.deleteCtr(index: widget.index);
                          Navigator.pop(context);
                          Get.offAll(const TrashCanPage());
                        },
                        child: const Text('완전히 삭제')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('취소')),
                  ],
                  elevation: 24.0,
                );
              },
            );
          },
          value: SampleItem.deleteMemo,
          child: const Text('완전히 삭제'),
        ),
      ],
    );
  }
}
