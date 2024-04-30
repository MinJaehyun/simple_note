import 'package:flutter/material.dart';
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
                // note: 카테고리 list view 가로 설정
                Container(
                  child: Expanded(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 25);
                      },
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Text('${categories[index]}');
                      },
                    ),
                  ),
                ),
                SizedBox(width: 15),
                // note: 우측 끝: 목록 생성 버튼과 달력 버튼
                Container(
                  child: Row(
                    children: [
                      // note: 목록 카테고리 생성 버튼
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.list_alt_outlined)),
                      // note: 달력 페이지로 이동하는 버튼
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.calendar_month))
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
