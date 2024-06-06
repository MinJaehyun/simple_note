import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/controller/trash_can_memo_controller.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/update_memo_page.dart';

enum SampleItem { updateMemo, deleteMemo }

class MemoCalendarPopupButtonWidget extends StatefulWidget {
  const MemoCalendarPopupButtonWidget(this.index, this.sortedCard, {super.key});

  final int index;
  final MemoModel sortedCard;

  @override
  State<MemoCalendarPopupButtonWidget> createState() => _MemoCalendarPopupButtonWidgetState();
}

class _MemoCalendarPopupButtonWidgetState extends State<MemoCalendarPopupButtonWidget> {
  SampleItem? selectedItem;
  late String _dropdownValue;
  final trashCanMemoController = Get.find<TrashCanMemoController>();
  final memoController = Get.find<MemoController>();

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
        setState(() => selectedItem = item);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        PopupMenuItem<SampleItem>(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UpdateMemoPage(index: widget.index, currentContact: widget.sortedCard),
              ),
            );
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
                  title: const Text("메모를 삭제 하시겠습니까?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          // 휴지통에 담기
                          trashCanMemoController.addCtr(
                            createdAt: widget.sortedCard.createdAt,
                            title: widget.sortedCard.title,
                            mainText: widget.sortedCard.mainText,
                            // note: 휴지통에 저장되면서 범주는 '미분류'로 지정되야 한다.
                            selectedCategory: _dropdownValue,
                            isFavoriteMemo: false,
                          );
                          // 일반 메모장에서 삭제하기
                          // todo: 리펙토링하기: 바로 Hive 접근 대신, CTR 접근해서 가져오기
                          memoController.deleteCtr(
                              index: widget.sortedCard == SortedTime.firstTime ? widget.index : memoController.memoList.length - widget.index - 1);
                          Navigator.pop(context);
                        },
                        child: const Text('삭제')),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
                  ],
                  elevation: 24.0,
                );
              },
            );
          },
          value: SampleItem.deleteMemo,
          child: const Text('삭제'),
        ),
      ],
    );
  }
}
