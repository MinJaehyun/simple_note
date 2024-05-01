import 'package:flutter/material.dart';
import 'package:simple_note/view/screens/category/category.dart';
import 'package:simple_note/view/widgets/home/value_listen.dart';

class HomePageBodyFrame extends StatelessWidget {
  const HomePageBodyFrame({
    super.key,
    required this.categories,
  });

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
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
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            splashColor: Colors.blue.withAlpha(30),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('${categories[index]}'),
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
                            // todo:
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return AddCategory();
                            },),);
                          },
                          icon: Icon(Icons.list_alt_outlined)),
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.calendar_month))
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
  }
}
