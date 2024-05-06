import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/view/screens/category/category.dart';
import 'package:simple_note/view/widgets/home/homeSelectedCategoryWidget.dart';
import 'package:simple_note/view/widgets/home/value_listen.dart';
import 'package:simple_note/controller/hive_helper_category.dart';


class HomePageBodyFrame extends StatefulWidget {
  HomePageBodyFrame({super.key});

  @override
  State<HomePageBodyFrame> createState() => _HomePageBodyFrameState();
}

class _HomePageBodyFrameState extends State<HomePageBodyFrame> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
      builder: (context, Box<CategoryModel> box, _) {
        // if (box.values.isEmpty) return Center(child: Text('범주를 생성해 주세요'));
        return SingleChildScrollView(
          child: Column(
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
              if (selectedCategory == null) HomeAllCategoryWidget(),
              // note: 선택한 범주가 있으면 아래 실행한다.
              if (selectedCategory != null) HomeSelectedCategoryWidget(selectedCategory)
            ],
          ),
        );
      },
    );
  }
}
