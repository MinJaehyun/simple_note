import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_trash_can.dart';
import 'package:simple_note/helper/popup_trash_can_button_widget.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:simple_note/view/screens/home/my_page.dart';
import 'package:simple_note/view/screens/trash_can_memo/update_trash_can_memo.dart';


class TrashCan extends StatefulWidget {
  const TrashCan(this.sortedTime, {super.key});

  final SortedTime? sortedTime;

  @override
  State<TrashCan> createState() => _TrashCanState();
}

class _TrashCanState extends State<TrashCan> {
  String? searchControllerText;
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Simple Note'),
          centerTitle: true,
          actions: [
            // 정렬
            IconButton(
                onPressed: () {
                  // todo: 정렬 기능 구현하기
                },
                icon: Icon(Icons.sort)),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // 상단: 검색창
                  Container(
                    width: double.infinity,
                    child: Form(
                      child: TextFormField(
                        autofocus: false,
                        controller: searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          prefixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.search,
                              size: 24,
                            ),
                          ),
                          prefixIconColor: Colors.grey,
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.close,
                              size: 24,
                            ),
                          ),
                          suffixIconColor: Colors.grey,
                          hintText: '검색',
                          contentPadding: EdgeInsets.all(12),
                          hintStyle: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        cursorColor: Colors.grey,
                        onChanged: (value) {
                          setState(() {
                            searchController.text = value;
                            searchControllerText = searchController.text;
                          });
                        },
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 550,
              color: Colors.grey,
              // 삭제한 메모를 담고 있어야 한다.
              // 삭제한 메모가 담긴 리스트를 실시간 보여주기
              child: ValueListenableBuilder(
                valueListenable: Hive.box<TrashCanModel>(TrashCanBox).listenable(),
                builder: (context, Box<TrashCanModel> box, _) {
                  if (box.values.isEmpty) return Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));
                  return Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: box.values.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                        childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
                        mainAxisSpacing: 0, //수평 Padding
                        crossAxisSpacing: 0, //수직 Padding
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        // firstTime이면 오래된 순서로 정렬하고, lastTime이면 생성된 순서로 정렬한다.
                        TrashCanModel? currentContact = box.getAt(index);
                        TrashCanModel? reversedCurrentContact = box.getAt(box.values.length - 1 - index);
                        var sortedCard = widget.sortedTime == SortedTime.firstTime ? currentContact : reversedCurrentContact;

                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  // UpdateMemo 는 memoModel 타입으로 들어가도록 설정되어 있다.
                                  return UpdateTrashCanMemo(index: index, currentContact: currentContact);
                                }),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                titleAlignment: ListTileTitleAlignment.top,
                                contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10.0),
                                    Text(
                                      // sortedCard!.title,
                                      currentContact!.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: style,
                                    ),
                                    SizedBox(height: 100.0), // 원하는 간격 크기
                                    Text(
                                      FormatDate().formatSimpleTimeKor(currentContact.createdAt),
                                      style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                    ),
                                  ],
                                ),
                                // note: card() 수정 및 복원 버튼
                                trailing: PopupTrashCanButtonWidget(index, sortedCard!),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
