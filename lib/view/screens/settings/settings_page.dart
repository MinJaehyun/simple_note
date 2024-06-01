import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/view/widgets/public/footer_navigation_bar_widget.dart';

// 프리텐드, 나눔고딕 D2coding, 나눔손글씨 붓, 나눔명조, 나눔손글씨 펜, 나눔스퀘어 네오
enum SelectedFont { pretendard, d2coding, nanumBrush, nanumMyeongjo, nanumPen, NanumSquareNeo }

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // double _fontSize = 20.0; // 초기 글자 크기

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    double selectedFont = settingsController.fontSizeSlide.value.toDouble();

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '사용자 정의',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    Card(
                      child: ValueListenableBuilder(
                        // valueListenable: Hive.box('themeModel').listenable(keys: ['darkMode']), // 변경 전: 불필요한 요소 제거?
                        valueListenable: Hive.box('themeModel').listenable(),
                        builder: (context, box, child) {
                          // note: RxBool 인지 bool 인지에 따라 , Hive Box에서 가져왔는지 GetX controller에서 가져왔는지 확인이 가능하다..
                          bool darkMode = box.get('darkMode', defaultValue: false);
                          bool gridMode = box.get('gridMode', defaultValue: false);

                          return Column(
                            children: [
                              // note: 테마 설정
                              ListTile(
                                leading: darkMode ? const Icon(Icons.dark_mode_outlined) : const Icon(Icons.light_mode_outlined),
                                title: const Text('테마 설정'),
                                trailing: Switch(
                                  value: darkMode,
                                  activeColor: Colors.pinkAccent,
                                  onChanged: (bool value) {
                                    settingsController.toggleDarkMode(value);
                                    setState(() {
                                      // note: darkMode = value 대신 분기문 처리하여 darkMode 키에 bool 값 변경함
                                      darkMode == false ? box.put('darkMode', true) : box.put('darkMode', false);
                                    });
                                  },
                                ),
                              ),

                              // note: 격자 설정
                              ListTile(
                                leading: gridMode ? const Icon(Icons.apps) : const Icon(Icons.crop_din),
                                title: const Text('격자 설정'),
                                trailing: Switch(
                                  value: gridMode,
                                  activeColor: Colors.pinkAccent,
                                  onChanged: (bool value) {
                                    setState(() {
                                      gridMode == false ? box.put('gridMode', true) : box.put('gridMode', false);
                                    });
                                  },
                                ),
                              ),

                              // note: 폰트 설정
                              ListTile(
                                leading: const Icon(Icons.text_format),
                                title: const Text('폰트 설정'),
                                onTap: () {
                                  // Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                                  Get.dialog(
                                    AlertDialog(
                                      title: const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('폰트 설정'),
                                          Divider(),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // note: RadioListTile.adaptive는 플랫폼에 따른(ios, android) 적응형 디자인을 제공하므로 다양한 플랫폼에서 일관된 사용자 경험을 유지하고자 할 때 매우 유용하다
                                          Obx(
                                            () => RadioListTile.adaptive(
                                              title: const Text('기본 폰트'),
                                              value: SelectedFont.pretendard,
                                              // 변경 전
                                              groupValue: settingsController.selectedFont.value,
                                              // groupValue: controller.selectedFont.value,
                                              // 변경 전:
                                              // onChanged: (SelectedFont? value) {
                                              //   setState(() {
                                              //     _selectedFont = value!;
                                              //   });
                                              // },
                                              onChanged: (SelectedFont? value) {
                                                if (value != null) {
                                                  settingsController.updateFont(value);
                                                }
                                              },
                                            ),
                                          ),
                                          Obx(
                                            () => RadioListTile.adaptive(
                                              title: const Text('나눔고딕 D2coding'),
                                              value: SelectedFont.d2coding,
                                              groupValue: settingsController.selectedFont.value,
                                              onChanged: (SelectedFont? value) {
                                                if (value != null) {
                                                  settingsController.updateFont(value);
                                                }
                                              },
                                            ),
                                          ),
                                          Obx(
                                            () => RadioListTile.adaptive(
                                              title: const Text('나눔손글씨 붓'),
                                              value: SelectedFont.nanumBrush,
                                              groupValue: settingsController.selectedFont.value,
                                              onChanged: (SelectedFont? value) {
                                                if (value != null) {
                                                  settingsController.updateFont(value);
                                                }
                                              },
                                            ),
                                          ),
                                          Obx(
                                            () => RadioListTile.adaptive(
                                              title: const Text('나눔명조'),
                                              value: SelectedFont.nanumMyeongjo,
                                              groupValue: settingsController.selectedFont.value,
                                              onChanged: (SelectedFont? value) {
                                                if (value != null) {
                                                  settingsController.updateFont(value);
                                                }
                                              },
                                            ),
                                          ),
                                          Obx(
                                            () => RadioListTile.adaptive(
                                              title: const Text('나눔손글씨 펜'),
                                              value: SelectedFont.nanumPen,
                                              groupValue: settingsController.selectedFont.value,
                                              onChanged: (SelectedFont? value) {
                                                if (value != null) {
                                                  settingsController.updateFont(value);
                                                }
                                              },
                                            ),
                                          ),
                                          Obx(
                                            () => RadioListTile.adaptive(
                                              title: const Text('나눔스퀘어 네오'),
                                              value: SelectedFont.NanumSquareNeo,
                                              groupValue: settingsController.selectedFont.value,
                                              onChanged: (SelectedFont? value) {
                                                if (value != null) {
                                                  settingsController.updateFont(value);
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: Get.back,
                                          child: const Text('저장'),
                                        ),
                                        TextButton(
                                          onPressed: Get.back,
                                          child: const Text('취소'),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              // note: 글자 크기 설정
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.format_shapes),
                                        SizedBox(width: 16),
                                        Text('글자 크기', style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    Slider(
                                      value: selectedFont,
                                      min: 10.0,
                                      max: 40.0,
                                      divisions: 10,
                                      label: '$selectedFont',
                                      onChanged: (double value) {
                                        setState(() {
                                          settingsController.updateFontSlider(value);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // note: 일반
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '일반',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.backup),
                            title: const Text('백업 설정'),
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
                // note: 정보: 개선 사항 문의하기/앱 리뷰하기/앱 정보
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '정보',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.flutter_dash),
                            title: const Text('개선 사항 문의하기'),
                            onTap: () => Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                          ),
                          ListTile(
                            leading: const Icon(Icons.flutter_dash),
                            title: const Text('앱 리뷰하기'),
                            onTap: () => Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                          ),
                          ListTile(
                            leading: const Icon(Icons.flutter_dash),
                            title: const Text('앱 정보'),
                            onTap: () => Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const FooterNavigationBarWidget(4),
      ),
    );
  }
}
