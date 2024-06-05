import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/popup_trash_can_button_widget.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:simple_note/repository/local_data_source/trash_can_memo_repository.dart';
import 'package:simple_note/view/screens/trash_can/crud/update_trash_can_memo_page.dart';
import 'package:simple_note/view/widgets/public/footer_navigation_bar_widget.dart';
import 'package:simple_note/view/widgets/trash/trash_search.dart';

// 생성한 순서가 아닌, 삭제한 순서대로 휴지통에 들어가며 정렬된다
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // todo: 앱바 배경색 추후 변경하기
            backgroundColor: Colors.grey[100],
            // actions: [
              // // 정렬
              // IconButton(
              //   visualDensity: const VisualDensity(horizontal: -4),
              //   // note: 버튼 클릭 시, 오름차순, 내림차순 정렬하기
              //   onPressed: () {
              //     setState(() {
              //       isCurrentSortVal = !isCurrentSortVal;
              //     });
              //   },
              //   icon: const Icon(Icons.sort),
              // ),
            // ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
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
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.orange,
                                width: 1,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 24,
                            ),
                            prefixIconColor: Colors.grey,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchController.clear();
                                  searchControllerText = null;
                                });
                              },
                              child: searchControllerText != null ? const Icon(Icons.close, size: 24) : const Icon(Icons.transit_enterexit),
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
                              // 변경 전: 자음 한개씩 가져오는게 아닌, 전체를 가져오도록 변경
                              // searchController.text = value;
                              // 변경 후
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
              // todo: 빈공간 배너 넣기: height: 20
              const SizedBox(height: 75),
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
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            // firstTime이면 오래된 순서로 정렬하고, lastTime이면 생성된 순서로 정렬한다.
                            // note: *** 아래처럼 TrashCanModel? currentContact 설정하면 제대로 index 각각 가져오는데, 상단에 TrashCanModel? currentContact 작성하고 currentContact = box.getAt(index); 처리하면 각각의 요소 가져오지 못한다. 이유는? ***
                            // TrashCanModel? currentContact = box.getAt(index);
                            TrashCanModel? reversedCurrentContact = box.getAt(box.values.length - 1 - index);
                            // sortedCard = widget.sortedTime == SortedTime.firstTime ? currentContact : reversedCurrentContact;

                            // 모든 휴지통 내용 출력
                            return Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CustomPaint(
                                painter: GridPainter(),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        // UpdateMemo 는 memoModel 타입으로 들어가도록 설정되어 있다.
                                        return UpdateTrashCanMemoPage(
                                          index: index,
                                          // currentContact: isCurrentSortVal ? reversedCurrentContact! : currentContact!,
                                          currentContact: reversedCurrentContact,
                                        );
                                      }),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ListTile(
                                      titleAlignment: ListTileTitleAlignment.titleHeight,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(Icons.account_box),
                                                  padding: EdgeInsets.zero,
                                                  // 패딩 설정
                                                  constraints: const BoxConstraints(),
                                                  iconSize: 50,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 10.0),
                                                Expanded(
                                                  child: Text(
                                                    // isCurrentSortVal ? reversedCurrentContact!.title : currentContact!.title,
                                                    reversedCurrentContact!.title,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary),
                                                  ),
                                                ),
                                                // card() 수정 및 복원 버튼
                                                // PopupTrashCanButtonWidget(index, isCurrentSortVal ? reversedCurrentContact! : currentContact!),
                                                PopupTrashCanButtonWidget(index, reversedCurrentContact),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 90.0),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  FormatDate().formatSimpleTimeKor(
                                                      // 변경 전: isCurrentSortVal ? reversedCurrentContact!.createdAt : currentContact!.createdAt,
                                                      reversedCurrentContact.createdAt),
                                                  style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                                ),
                                              ),
                                              const IconButton(
                                                onPressed: null,
                                                icon: SizedBox.shrink(), // 비어있는 아이콘 버튼
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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
