import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> categories = ['모두', '직장', '감사 일기', '오래전 일기', '롤 마스터'];

    return SafeArea(
      child: Scaffold(
        // note: 하단 footer 설정
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          label: const Text('Add'),
          icon: const Icon(Icons.add),
        ),
        // note: Drawer 만들기
        drawer: Drawer(
            // child: ListTile(
            //   leading: const Icon(Icons.change_history),
            //   title: const Text('Change history'),
            //   onTap: () {
            //     // change app state...
            //     Navigator.pop(context); // close the drawer
            //   },
            // ),
            ),
        // todo: 추후 appbar 분리하기
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          ],
        ),

        body: Column(
          children: [
            // todo: 추후 상단 body 분리하기
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
            // todo: 하단 body 분리하기
            Container(
              color: Colors.green,
              height: 600,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  crossAxisCount: 3,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[100],
                      child: Column(
                        children: [
                          Expanded(
                            child:
                                const Text("표제 및 세부 내용 작성")
                          ),
                          Text('${DateTime.now()}')
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[200],
                      child: Column(
                        children: [
                          Expanded(child: const Text('Heed not the rabble')),
                          Text('${DateTime.now()}')
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[300],
                      child: Column(
                        children: [
                          Expanded(
                              child: const Text('Sound of screams but the')),
                          Text('${DateTime.now()}')
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[400],
                      child: Column(
                        children: [
                          Expanded(child: const Text('Who scream')),
                          Text('${DateTime.now()}')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
