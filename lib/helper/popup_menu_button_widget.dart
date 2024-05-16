import 'package:flutter/material.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/memo/update_memo.dart';

enum SampleItem { updateMemo, deleteMemo }

class PopupMenuButtonWidget extends StatefulWidget {
  const PopupMenuButtonWidget(this.index, this.currentContact, {super.key, });

  final int index;
  final MemoModel currentContact;

  @override
  State<PopupMenuButtonWidget> createState() => _PopupMenuButtonWidgetState();
}

class _PopupMenuButtonWidgetState extends State<PopupMenuButtonWidget> {
  SampleItem? selectedItem;

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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UpdateMemo(index: widget.index, currentContact: widget.currentContact),
              ),
            );
          },
          value: SampleItem.updateMemo,
          child: Text('수정'),
        ),
        PopupMenuItem<SampleItem>(
          onTap: () => HiveHelperMemo().delete(widget.index),
          value: SampleItem.deleteMemo,
          child: Text('삭제'),
        ),
      ],
    );
  }
}
