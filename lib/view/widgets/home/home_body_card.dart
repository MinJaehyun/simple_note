import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/helper/popup_menu_button_widget.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/home/my_page.dart';
import 'package:simple_note/view/screens/memo/update_memo.dart';

class HomeBodyCardWidget extends StatefulWidget {
  const HomeBodyCardWidget(this.sortedTime, {super.key});

  final SortedTime? sortedTime;

  @override
  State<HomeBodyCardWidget> createState() => _HomeBodyCardWidgetState();
}

class _HomeBodyCardWidgetState extends State<HomeBodyCardWidget> {
  var sortedCard;

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary);

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
              // firstTime이면 오래된 순서로 정렬하고, lastTime이면 생성된 순서로 정렬한다.
              MemoModel? currentContact = box.getAt(index);
              MemoModel? reversedCurrentContact = box.getAt(box.values.length - 1 - index);
              sortedCard = widget.sortedTime == SortedTime.firstTime ? currentContact : reversedCurrentContact;

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        // fix: 업데이트 할 때에는 currentContact: sortedCard 넣으면 에러
                        return UpdateMemo(index: index, currentContact: currentContact!);
                      }),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        titleAlignment: ListTileTitleAlignment.top,
                        contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                        title: Text(sortedCard!.title, overflow: TextOverflow.ellipsis, style: style),
                        subtitle:
                            Text(FormatDate().formatDefaultDateKor(sortedCard.createdAt), style: TextStyle(color: Colors.grey.withOpacity(0.9))),
                        // note: card() 내 수정, 삭제 버튼
                        trailing: PopupMenuButtonWidget(index, sortedCard)),
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
