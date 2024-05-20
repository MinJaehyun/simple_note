import 'package:flutter/material.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/controller/hive_helper_trash_can.dart';
import 'package:simple_note/model/trash_can.dart';


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
            HiveHelperTrashCan().updateMemo(
              index: widget.index,
              createdAt: widget.currentContact.createdAt,
              title: widget.currentContact.title,
              mainText: widget.currentContact.mainText,
              // note: 휴지통에 저장되면서 범주는 '미분류'로 지정되야 한다.
              selectedCategory: _dropdownValue,
            );
          },
          value: SampleItem.updateMemo,
          child: Text('수정'),
        ),
        PopupMenuItem<SampleItem>(
          onTap: () {
            // 복원한다: 메모장에 넣고, 휴지통에서 지운다.
            HiveHelperMemo().addMemo(
              createdAt: widget.currentContact.createdAt,
              title: widget.currentContact.title,
              mainText: widget.currentContact.mainText,
              selectedCategory: _dropdownValue,
            );
            HiveHelperTrashCan().delete(widget.index);
          },
          value: SampleItem.restoreMemo,
          child: Text('복원'),
        ),
        PopupMenuItem<SampleItem>(
          onTap: () {
            // 휴지통에서 완전히 삭제
            HiveHelperTrashCan().delete(widget.index);
          },
          value: SampleItem.deleteMemo,
          child: Text('완전히 삭제'),
        ),
      ],
    );
  }
}
