import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/main.dart';
import 'package:simple_note/view/widgets/public/footer_navigation_bar_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double _fontSize = 20.0; // 초기 글자 크기

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('환경 설정'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // note: 사용자 정의
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('사용자 정의', style: TextStyle(color: Colors.blue, fontSize: 16)),
                      ),
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Hive.box(darkModeBox).get('darkMode', defaultValue: false)
                                  ? const Icon(Icons.dark_mode_outlined)
                                  : const Icon(Icons.light_mode_outlined),
                              title: Text('테마 설정'),
                              trailing: ValueListenableBuilder(
                                valueListenable: Hive.box('darkModel').listenable(keys: ['darkMode']),
                                builder: (context, box, child) {
                                  var darkMode = box.get('darkMode', defaultValue: false);

                                  return Switch(
                                    value: darkMode,
                                    activeColor: Colors.red,
                                    onChanged: (bool value) {
                                      setState(() {
                                        // darkMode = value 대신 분기문 처리하여 darkMode 키에 bool 값 변경함
                                        darkMode == false ? box.put('darkMode', true) : box.put('darkMode', false);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.collections),
                              title: Text('기본 노트 배경  설정'),
                              onTap: () => Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                            ),
                            ListTile(
                              leading: Icon(Icons.text_format),
                              title: Text('폰트 설정'),
                              onTap: () => Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.format_shapes),
                                        SizedBox(width: 16),
                                        TextButton(
                                          child: Text('글자 크기'),
                                          onPressed: () =>
                                              Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                                        ),
                                      ],
                                    ),
                                    Slider(
                                      value: _fontSize,
                                      min: 10.0,
                                      max: 40.0,
                                      divisions: 10,
                                      label: '$_fontSize',
                                      onChanged: (double value) {
                                        setState(() {
                                          _fontSize = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // note: 일반
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('일반', style: TextStyle(color: Colors.blue, fontSize: 16)),
                      ),
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.backup),
                              title: Text('백업 설정'),
                              onTap: () => Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                            ),
                            // ListTile(
                            //   leading: Icon(Icons.collections),
                            //   title: Text('??? 설정'),
                            // ),
                            // ListTile(
                            //   leading: Icon(Icons.text_format),
                            //   title: Text('??? 설정'),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // note: 정보: 개선 사항 문의하기/앱 리뷰하기/앱 정보
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('정보', style: TextStyle(color: Colors.blue, fontSize: 16)),
                      ),
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.flutter_dash),
                              title: Text('개선 사항 문의하기'),
                              onTap: () => Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                            ),
                            ListTile(
                              leading: Icon(Icons.flutter_dash),
                              title: Text('앱 리뷰하기'),
                              onTap: () => Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                            ),
                            ListTile(
                              leading: Icon(Icons.flutter_dash),
                              title: Text('앱 정보'),
                              onTap: () => Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: FooterNavigationBarWidget(4),
      ),
    );
  }
}
