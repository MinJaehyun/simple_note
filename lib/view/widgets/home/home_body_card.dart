import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/memo/update_memo.dart';

enum SampleItem { updateMemo, deleteMemo }

class HomeBodyCardWidget extends StatefulWidget {
  const HomeBodyCardWidget({super.key});

  @override
  State<HomeBodyCardWidget> createState() => _HomeBodyCardWidgetState();
}

class _HomeBodyCardWidgetState extends State<HomeBodyCardWidget> {
  SampleItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
      builder: (context, Box<MemoModel> box, _) {
        if (box.values.isEmpty) return Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));
        return Container(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: box.values.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
              mainAxisSpacing: 10, //수평 Padding
              crossAxisSpacing: 10, //수직 Padding
            ),
            itemBuilder: (BuildContext context, int index) {
              MemoModel? currentContact = box.getAt(index);
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return UpdateMemo(index: index, currentContact: currentContact);
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                      title: Text(currentContact!.title, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary)),
                      subtitle: Text(FormatDate().formatDefaultDateKor(currentContact.time),
                          style: TextStyle(color: Colors.grey.withOpacity(0.9))),
                      // note: card() 내 수정, 삭제 버튼
                      trailing: Column(
                        children: [
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
                                      builder: (context) => UpdateMemo(index: index, currentContact: currentContact),
                                    ),
                                  );
                                },
                                value: SampleItem.updateMemo,
                                child: Text('수정'),
                              ),
                              PopupMenuItem<SampleItem>(
                                onTap: () => HiveHelperMemo().delete(index),
                                value: SampleItem.deleteMemo,
                                child: Text('삭제'),
                              ),
                            ],
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
