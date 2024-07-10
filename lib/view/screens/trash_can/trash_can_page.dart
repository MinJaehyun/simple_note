import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/controller/trash_can_memo_controller.dart';
import 'package:simple_note/helper/banner_ad_widget.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/popup_trash_can_button_widget.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/trash_can.dart';
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
  TextEditingController textSearchController = TextEditingController();
  final trashCanMemoController = Get.find<TrashCanMemoController>();
  late final settingsController = Get.find<SettingsController>();

  List<TrashCanModel> sortedMemoList = [];
  List<TrashCanModel> reverseSortedMemoList = [];
  List<TrashCanModel> selectedMemoList = [];

  String? searchText;

  @override
  void initState() {
    super.initState();
    updateSortedLists();
  }

  @override
  void dispose() {
    textSearchController.dispose();
    super.dispose();
  }

  void updateSortedLists() {
    sortedMemoList = List.from(trashCanMemoController.trashCanMemoList)..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    reverseSortedMemoList = List.from(trashCanMemoController.trashCanMemoList)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    selectedMemoList = settingsController.sortedTime.value == SortedTime.firstTime ? sortedMemoList : reverseSortedMemoList;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const BannerAdWidget(),
            backgroundColor: Colors.transparent,
            actions: [
              Semantics(
                label: '전체 삭제',
                child: IconButton(
                  visualDensity: const VisualDensity(horizontal: -4),
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('휴지통의 메모를 모두 삭제 하시겠습니까?', style: TextStyle(fontSize: 16)),
                        content: const Text('더이상 휴지통의 메모를 복구할 수 없습니다', style: TextStyle(fontSize: 12)),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await trashCanMemoController.allDeleteCtr();
                              Get.back();
                              updateSortedLists();
                            },
                            child: const Text('삭제', style: TextStyle(color: Colors.red, fontSize: 14)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, size: 32),
                ),
              ),
              Semantics(
                label: '정렬',
                child: IconButton(
                  visualDensity: const VisualDensity(horizontal: -4),
                  // note: 버튼 클릭 시, 오름차순, 내림차순 정렬하기
                  icon: const Icon(Icons.low_priority, size: 32),
                  onPressed: () {
                    setState(() {
                      if (settingsController.sortedTime.value == SortedTime.firstTime) {
                        settingsController.updateSortedName(SortedTime.lastTime);
                      } else {
                        settingsController.updateSortedName(SortedTime.firstTime);
                      }
                    });
                  },
                ),
              ),
            ],
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
                          controller: textSearchController,
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
                                  textSearchController.clear();
                                  searchText = null;
                                });
                              },
                              child: searchText != null ? const Icon(Icons.close, size: 24) : const SizedBox.shrink(),
                            ),
                            suffixIconColor: Colors.grey,
                            hintText: '검색',
                            contentPadding: const EdgeInsets.all(12),
                            hintStyle: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          cursorColor: Colors.grey,
                          onChanged: (value) {
                            setState(() {
                              // 변경 전: 자음 한개씩 가져오는게 아닌, 전체를 가져오도록 변경
                              // textSearchController.text = value;
                              // 변경 후
                              searchText = textSearchController.text;
                            });
                          },
                          onTap: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 75),
              // note: 빈휴지통 분기문 시작점
              if (trashCanMemoController.trashCanMemoList.isEmpty) const Center(child: Text('휴지통이 비었습니다')),
              // note: 검색어가 없을 시, 메모 나타내기
              if (searchText == null || searchText == '')
                Expanded(
                  child: Obx(
                    () {
                      // fix: 휴지통 업데이트 메모 변경 후, 리스트 리로드
                      updateSortedLists();
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 270,
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: trashCanMemoController.trashCanMemoList.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 0,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            TrashCanModel? currentContact = selectedMemoList[index];
                            int sortedIndex = trashCanMemoController.trashCanMemoList.indexOf(currentContact);
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
                                        return UpdateTrashCanMemoPage(
                                          index: sortedIndex,
                                          currentContact: currentContact,
                                        );
                                      }),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Stack(
                                      children: [
                                        // Container(
                                        //   decoration: currentContact.imagePath != null
                                        //       ? BoxDecoration(
                                        //           image: DecorationImage(
                                        //             image: FileImage(File(currentContact.imagePath!)),
                                        //             fit: BoxFit.cover,
                                        //           ),
                                        //         )
                                        //       : const BoxDecoration(),
                                        // ),
                                        // if (currentContact.imagePath != null)
                                        //   // note: BackdropFilter 위젯 사용하면 흐릿한(이미지 색상 및 전체 색상) 이미지로 처리할 수 있다
                                        //   BackdropFilter(
                                        //     filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                        //     child: Container(color: Colors.black.withOpacity(0.2)),
                                        //   ),

                                        Container(
                                          height: 200,
                                          decoration: currentContact.imagePath != null
                                          // 이미지 있는 경우: 이미지만 처리
                                              ? BoxDecoration(
                                            image: DecorationImage(
                                              image: FileImage(File(currentContact.imagePath!)),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                          // 이미지 없는 경우: 그라데이션 처리
                                              : BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: settingsController.isThemeMode.value == false
                                                  ? [Colors.white.withOpacity(0.5), Colors.transparent]
                                                  : [Colors.black.withOpacity(0.5), Colors.transparent],
                                            ),
                                          ),
                                        ),
                                        if (currentContact.imagePath != null)
                                        // 이미지 있는 경우: 전체 블러 효과
                                          Positioned(
                                            child: Container(
                                              height: 200,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [Colors.white12.withOpacity(1), Colors.transparent],
                                                ),
                                              ),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                                child: Container(
                                                  // 상단 투명 조정
                                                  color: settingsController.isThemeMode.value == false
                                                      ? Colors.black.withOpacity(0.3)
                                                      : Colors.white.withOpacity(0.3),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ListTile(
                                          titleAlignment: ListTileTitleAlignment.titleHeight,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 10.0),
                                                    Expanded(
                                                      child: Text(
                                                        currentContact.title,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary),
                                                      ),
                                                    ),
                                                    // card() 수정 및 복원 및 완전히 삭제
                                                    PopupTrashCanButtonWidget(sortedIndex, currentContact),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      FormatDate().formatSimpleTimeKor(currentContact.createdAt),
                                                      style: TextStyle(color: Colors.grey.withOpacity(0.9)),
                                                    ),
                                                  ),
                                                  const IconButton(
                                                    onPressed: null,
                                                    icon: SizedBox.shrink(), // 비어있는 아이콘 버튼
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15.0),
                                            ],
                                          ),
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
                  ),
                ),
              // note: 휴지통에서 검색 내용만 출력
              if (searchText != null)
                Expanded(
                  child: TrashSearch(searchText!),
                ),
            ],
          ),
          bottomNavigationBar: const FooterNavigationBarWidget(3),
        ),
      ),
    );
  }
}
