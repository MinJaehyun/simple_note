import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_trash_can.dart';
import 'package:simple_note/helper/popup_trash_can_button_widget.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:simple_note/view/screens/trash_can/crud/update_trash_can_memo_page.dart';
import 'package:simple_note/view/widgets/public/footer_navigation_bar_widget.dart';
import 'package:simple_note/view/widgets/trash/trash_search.dart';

class TrashCanPage extends StatefulWidget {
  const TrashCanPage({super.key});

  @override
  State<TrashCanPage> createState() => _TrashCanPageState();
}

class _TrashCanPageState extends State<TrashCanPage> {
  String? searchControllerText;
  TextEditingController searchController = TextEditingController();
  bool isCurrentSortVal = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Simple Note'),
            centerTitle: true,
            actions: [
              // 정렬
              IconButton(
                  // note: 버튼 클릭 시, 오름차순, 내림차순 정렬하기
                  onPressed: () {
                    setState(() {
                      isCurrentSortVal = !isCurrentSortVal;
                    });
                  },
                  icon: const Icon(Icons.sort)),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // 상단: 검색창
                    SizedBox(
                      width: double.infinity,
                      child: Form(
                        child: TextFormField(
                          autofocus: false,
                          controller: searchController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.orange,
                                width: 1,
                              ),
                            ),
                            prefixIcon: GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.search,
                                size: 24,
                              ),
                            ),
                            prefixIconColor: Colors.grey,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchController.clear();
                                  searchControllerText = null;
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                size: 24,
                              ),
                            ),
                            suffixIconColor: Colors.grey,
                            hintText: '검색',
                            contentPadding: const EdgeInsets.all(12),
                            hintStyle: const TextStyle(
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
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<TrashCanModel>(TrashCanBox).listenable(),
                  builder: (context, Box<TrashCanModel> box, _) {
                    // 휴지통 분기문 시작점
                    if (searchControllerText == null || searchControllerText == '') {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: box.values.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                            childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
                            mainAxisSpacing: 0, //수평 Padding
                            crossAxisSpacing: 0, //수직 Padding
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            // firstTime이면 오래된 순서로 정렬하고, lastTime이면 생성된 순서로 정렬한다.
                            // note: *** 아래처럼 TrashCanModel? currentContact 설정하면 제대로 index 각각 가져오는데, 상단에 TrashCanModel? currentContact 작성하고 currentContact = box.getAt(index); 처리하면 각각의 요소 가져오지 못한다. 이유는? ***
                            TrashCanModel? currentContact = box.getAt(index);
                            TrashCanModel? reversedCurrentContact = box.getAt(box.values.length - 1 - index);
                            // sortedCard = widget.sortedTime == SortedTime.firstTime ? currentContact : reversedCurrentContact;

                            // 모든 휴지통 내용 출력
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      // UpdateMemo 는 memoModel 타입으로 들어가도록 설정되어 있다.
                                      return UpdateTrashCanMemoPage(
                                          index: index, currentContact: isCurrentSortVal ? reversedCurrentContact! : currentContact!);
                                    }),
                                  );
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
                                        Text(
                                          isCurrentSortVal ? reversedCurrentContact!.title : currentContact!.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: style,
                                        ),
                                        const SizedBox(height: 100.0), // 원하는 간격 크기
                                        Text(
                                          FormatDate()
                                              .formatSimpleTimeKor(isCurrentSortVal ? reversedCurrentContact!.createdAt : currentContact!.createdAt),
                                          style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                        ),
                                      ],
                                    ),
                                    // note: card() 수정 및 복원 버튼
                                    trailing: PopupTrashCanButtonWidget(index, isCurrentSortVal ? reversedCurrentContact! : currentContact!),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    // 휴지통에서 검색된 내용만 출력
                    else if (searchControllerText != null) {
                      return TrashSearch(searchControllerText!);
                    }
                    return const Center(child: Text('휴지통이 비었습니다'));
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: const FooterNavigationBarWidget(3),
        ),
      ),
    );
  }
}
