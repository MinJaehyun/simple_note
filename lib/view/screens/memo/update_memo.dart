import 'package:flutter/material.dart';
import 'package:simple_note/helper/hive_helper.dart';
import 'package:simple_note/model/memo.dart';

class UpdateMemo extends StatefulWidget {
  UpdateMemo({super.key, required this.currentContact, required this.index});
  final MemoModel currentContact;
  final int index;

  final formKey = GlobalKey<FormState>();

  @override
  State<UpdateMemo> createState() => _UpdateMemoState();
}

class _UpdateMemoState extends State<UpdateMemo> {
  DateTime time = DateTime.now();
  String title = '';
  String mainText = '';
  String _dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    void dropdownCallback(String? selectedValue) {
      if (selectedValue is String) {
        setState(() {
          _dropdownValue = selectedValue;
        });
      }
    }

    DropdownButton<String> DropdownButtonWidget() {
      return DropdownButton(
        value: _dropdownValue.isNotEmpty ? _dropdownValue : null,
        onChanged: dropdownCallback,
        items: [
          DropdownMenuItem(child: Text('직장'), value: 'job'),
          DropdownMenuItem(child: Text('감사일기'), value: 'thanksDairy'),
          DropdownMenuItem(child: Text('일상'), value: 'today')
        ],
        iconSize: 35,
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // note: 상단 컨테이너
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.green,
                height: 80,
                child: Row(
                  children: [
                    Expanded(child: Text('${DateTime.now()}')),
                    TextButton(
                      onPressed: () {},
                      child: DropdownButtonWidget(),
                    ),
                  ],
                ),
              ),
            ),
            // note: 중단 컨테이너
            Expanded(
              child: Form(
                key: widget.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.green,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          autofocus: true,
                          initialValue: widget.currentContact.title,
                          decoration: InputDecoration(
                            hintText: '제목을 입력해 주세요',
                          ),
                          onChanged: (value) {
                            setState(() {
                              title = value;
                            });
                          },
                        ),
                        TextFormField(
                          initialValue: widget.currentContact.mainText,
                          decoration: InputDecoration(
                            hintText: '내용을 입력해 주세요',
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          onChanged: (value) {
                            setState(() {
                              mainText = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // note: save and cancel
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HiveHelper().updateMemo(index: widget.index, title: title, time: time, mainText: mainText);
                        Navigator.of(context).pop();
                      },
                      child: Text('저장'),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('취소'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
