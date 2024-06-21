import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/helper/banner_ad_widget.dart';
import 'package:simple_note/view/screens/settings/timeline_status_page.dart';
import 'package:simple_note/view/widgets/public/footer_navigation_bar_widget.dart';
import 'package:simple_note/view/widgets/settings/send_mail.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final settingsController = Get.find<SettingsController>();
  late double selectedFont;

  @override
  void initState() {
    super.initState();
    selectedFont = settingsController.fontSizeSlider.value.toDouble();
  }

  radioListTileFunc({required String title, required SelectedFont value}) {
    return RadioListTile.adaptive(
      title: Text(title),
      value: value,
      groupValue: settingsController.selectedFont.value,
      onChanged: (SelectedFont? value) {
        if (value != null) {
          settingsController.updateFont(value);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: BannerAdWidget(),
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
                      child: Text('사용자 정의', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                    Card(
                      child: Obx(
                        () {
                          return Column(
                            children: [
                              // note: 테마 설정
                              ListTile(
                                leading: settingsController.isThemeMode == true
                                    ? const Icon(Icons.light_mode_outlined)
                                    : const Icon(Icons.dark_mode_outlined),
                                title: const Text('테마 설정'),
                                trailing: Switch(
                                  value: settingsController.isThemeMode == false,
                                  activeColor: Colors.pinkAccent,
                                  onChanged: (bool value) {
                                    settingsController.isThemeMode == false
                                        ? settingsController.toggleDarkMode(true)
                                        : settingsController.toggleDarkMode(false);
                                  },
                                ),
                              ),
                              // note: 격자 설정
                              ListTile(
                                leading: settingsController.isGridMode == true ? const Icon(Icons.apps) : const Icon(Icons.crop_din),
                                title: const Text('격자 설정'),
                                trailing: Switch(
                                  value: settingsController.isGridMode == true,
                                  activeColor: Colors.pinkAccent,
                                  onChanged: (bool value) {
                                    settingsController.isGridMode == true
                                        ? settingsController.toggleGridMode(false)
                                        : settingsController.toggleGridMode(true);
                                  },
                                ),
                              ),
                              // note: 폰트 설정
                              ListTile(
                                leading: const Icon(Icons.text_format),
                                title: const Text('폰트 설정'),
                                onTap: () {
                                  Get.dialog(
                                    AlertDialog(
                                      title: const Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('폰트 설정'),
                                          Divider(),
                                        ],
                                      ),
                                      content: Obx(
                                        () => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // note: RadioListTile.adaptive는 플랫폼에 따른(ios, android) 적응형 디자인을 제공하므로 다양한 플랫폼에서 일관된 사용자 경험을 유지하고자 할 때 매우 유용하다
                                            radioListTileFunc(title: '기본 폰트', value: SelectedFont.pretendard),
                                            radioListTileFunc(title: '나눔고딕 D2coding', value: SelectedFont.d2coding),
                                            radioListTileFunc(title: '나눔손글씨 붓', value: SelectedFont.nanumBrush),
                                            radioListTileFunc(title: '나눔명조', value: SelectedFont.nanumMyeongjo),
                                            radioListTileFunc(title: '나눔손글씨 펜', value: SelectedFont.nanumPen),
                                            radioListTileFunc(title: '나눔스퀘어 네오', value: SelectedFont.NanumSquareNeo),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(onPressed: Get.back, child: const Text('닫기')),
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
                      child: Text('일반', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.backup),
                            title: const Text('백업 설정'),
                            onTap: () => Get.snackbar('기능을 준비 중 입니다.', '', snackPosition: SnackPosition.BOTTOM, colorText: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // note: 정보: 의견 보내기 / 앱 정보
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.calendar_today_outlined),
                            title: const Text('개발 로드맵'),
                            onTap: () => Get.to(const TimelineStatusPage()),
                          ),
                          // note: 메일 보내기 기능 widget으로 분리
                          const SendMail(),
                          const ListTile(
                            leading: Icon(Icons.info),
                            title: Row(
                              children: [
                                Text('버전 정보'),
                                Spacer(),
                                Text('1.0.4'),
                              ],
                            ),
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
