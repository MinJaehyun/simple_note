import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/view/screens/category/category.dart';
import 'package:simple_note/view/widgets/home/value_listen.dart';
import 'package:simple_note/controller/hive_helper_category.dart';

class HomePageBodyFrame extends StatelessWidget {
  const HomePageBodyFrame({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
      builder: (context, Box<CategoryModel> box, _) {
        if (box.values.isEmpty) return Center(child: Text('범주를 생성해 주세요'));
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
                            CategoryModel? currentContact = box.getAt(index);
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                splashColor: Colors.blue.withAlpha(30),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('${currentContact?.categories}'),
                                ),
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
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
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
            // note: 하단 body
            ValueListenWidget(),
          ],
        );
      },
    );
  }
}
