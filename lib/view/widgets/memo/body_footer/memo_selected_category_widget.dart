import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/update_memo_page.dart';
import 'package:simple_note/view/widgets/public/memo_calenar_popup_button_widget.dart';

enum SampleItem { updateMemo, deleteMemo }

class MemoSelectedCategoryWidget extends StatefulWidget {
  const MemoSelectedCategoryWidget(this.selectedCategory, this.sortedTime, {super.key});

  final String? selectedCategory;
  final SortedTime? sortedTime;

  @override
  State<MemoSelectedCategoryWidget> createState() => _MemoSelectedCategoryWidgetState();
}

class _MemoSelectedCategoryWidgetState extends State<MemoSelectedCategoryWidget> {
  SampleItem? selectedItem;

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary);

    return ValueListenableBuilder(
      valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
      builder: (context, Box<MemoModel> box, _) {
        if (box.values.isEmpty)
          return const Center(
            child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'),
          );
        var memo = box.values.where((item) {
          return item.selectedCategory == widget.selectedCategory;
        }).toList();
        print(memo); // (Instance of 'MemoModel')

        return SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: memo.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (BuildContext context, int index) {
              // MemoModel? currentContact = box.getAt(index);
              MemoModel? currentContact = memo[index];
              MemoModel? reversedCurrentContact = memo[memo.length - 1 - index];
              var sortedCard = widget.sortedTime == SortedTime.firstTime ? currentContact : reversedCurrentContact;

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return UpdateMemoPage(index: index, currentContact: sortedCard);
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.top,
                      contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10.0),
                          Text(sortedCard.title, overflow: TextOverflow.ellipsis, style: style),
                          const SizedBox(height: 100.0), // 원하는 간격 크기
                          Text(
                            FormatDate().formatSimpleTimeKor(sortedCard.createdAt),
                            style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                          ),
                        ],
                      ),
                      trailing: MemoCalendarPopupButtonWidget(index, currentContact),
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
