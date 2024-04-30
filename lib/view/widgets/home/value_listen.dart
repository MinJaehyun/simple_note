import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/helper/hive_helper.dart';
import 'package:simple_note/model/memo.dart';

class ValueListenWidget extends StatefulWidget {
  const ValueListenWidget({super.key});

  @override
  State<ValueListenWidget> createState() => _ValueListenWidgetState();
}

class _ValueListenWidgetState extends State<ValueListenWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
      builder: (context, Box<MemoModel> box, _) {
        if (box.values.isEmpty)
          return Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));
        return GridView.builder(
          shrinkWrap: true,
          itemCount: box.values.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
            childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
            mainAxisSpacing: 10, //수평 Padding
            crossAxisSpacing: 10, //수직 Padding
          ),
          itemBuilder: (BuildContext context, int index) {
            MemoModel? currentContact = box.getAt(index);
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onLongPress: () {
                  /* ... */
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(currentContact!.title,
                                overflow: TextOverflow.ellipsis),
                          ),
                          TextButton(
                            onPressed: () {
                              HiveHelper().delete(index);
                            },
                            child: Icon(Icons.delete_outline, size: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(currentContact.time.toString()),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
