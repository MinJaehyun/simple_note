import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_note/controller/hive_helper.dart';
import 'package:simple_note/controller/string_util.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/category/category.dart';
import 'package:simple_note/view/screens/memo/update_memo.dart';
import 'package:simple_note/view/widgets/home/value_listen.dart';
import 'package:simple_note/controller/hive_helper_category.dart';

enum SampleItem { updateMemo, deleteMemo }

class HomePageBodyFrame extends StatefulWidget {
  HomePageBodyFrame({super.key});

  @override
  State<HomePageBodyFrame> createState() => _HomePageBodyFrameState();
}

class _HomePageBodyFrameState extends State<HomePageBodyFrame> {
  SampleItem? selectedItem;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
      builder: (context, Box<CategoryModel> box, _) {
        // if (box.values.isEmpty) return Center(child: Text('범주를 생성해 주세요'));
        return Column(
          children: [
            Container(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      child: Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10);
                          },
                          itemCount: box.values.length,
                          itemBuilder: (context, index) {
                            CategoryModel? categoryContact = box.getAt(index);
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = categoryContact!.categories;
                                  });
                                },
                                // note: categoryContact?.categories 에만 모든 범주가 담겨있다
                                child: Text('${categoryContact?.categories}'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // note: 우측 끝: 목록 생성 버튼과 달력 버튼
                    Container(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return AddCategory();
                                }));
                              },
                              icon: Icon(Icons.list_alt_outlined)),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.calendar_month),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            // note: 하단 body - 전체 나타내기
            // note: 선택한 범주가 없으면 아래 실행하고,
            if (selectedCategory == null) ValueListenWidget(),
            // note: 선택한 범주가 있으면 아래 실행한다.
            if (selectedCategory != null)
              ValueListenableBuilder(
                valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
                builder: (context, Box<MemoModel> box, _) {
                  if (box.values.isEmpty) return Center(child: Text('우측 하단 버튼을 클릭하여 메모를 생성해 주세요'));
                  var memo = box.values.where((item) {
                    return item.selectedCategory == selectedCategory;
                  }).toList();
                  print(memo); // (Instance of 'MemoModel')

                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: memo.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                      childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
                      mainAxisSpacing: 10, //수평 Padding
                      crossAxisSpacing: 10, //수직 Padding
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      // MemoModel? currentContact = box.getAt(index);
                      MemoModel? currentContact = memo[index];
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
                              contentPadding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 16.0),
                              title: Text(currentContact.title,
                                  overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20)),
                              subtitle: Text(FormatDate().formatDate(currentContact.time),
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
                                              builder: (context) =>
                                                  UpdateMemo(index: index, currentContact: currentContact),
                                            ),
                                          );
                                        },
                                        value: SampleItem.updateMemo,
                                        child: Text('수정'),
                                      ),
                                      PopupMenuItem<SampleItem>(
                                        onTap: () => HiveHelper().delete(index),
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
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
