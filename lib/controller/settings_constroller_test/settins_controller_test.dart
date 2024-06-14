// import 'package:get/get.dart';
// import 'package:hive/hive.dart';
// import 'package:simple_note/model/settings_test/settings.dart';
// import 'package:simple_note/repository/local_data_source/settings_repository_test/settings_repository.dart';
//
// // note: 프리텐드, 나눔고딕 D2coding, 나눔손글씨 붓, 나눔명조, 나눔손글씨 펜, 나눔스퀘어 네오
// // enum SelectedFont { pretendard, d2coding, nanumBrush, nanumMyeongjo, nanumPen, NanumSquareNeo }
// // enum SortedTime { firstTime, lastTime }
//
// class SettingsController extends GetxController {
//   late SettingsRepository _settingsRepository;
//
//   RxList<SettingsModel> settingsList = <SettingsModel>[].obs;
//   RxBool isLoading = false.obs;
//   RxString errorMessage = ''.obs;
//
//   // RxBool isThemeMode = false.obs;
//   // RxBool isGridMode = false.obs;
//   // RxDouble fontSizeSlider = 20.0.obs;
//   // Rx<SelectedFont> selectedFont = SelectedFont.pretendard.obs;
//   // Rx<SortedTime> sortedTime = SortedTime.firstTime.obs;
//
//   Box<dynamic> box = Hive.box('themeModel');
//
//   @override
//   void onInit() {
//     super.onInit();
//     _settingsRepository = SettingsRepository();
//     loadMemoCtr();
//     // Box<dynamic> box = Hive.box('themeModel');
//
//     // isDarkMode.value = box.get('darkMode', defaultValue: false);
//     // isDarkMode 값을 가져올 때 double 값이 할당되지 않도록 확인
//     bool darkModeValue = box.get('darkMode', defaultValue: false);
//     if (darkModeValue) {
//       isThemeMode.value = darkModeValue;
//     } else {
//       isThemeMode.value = false; // 기본값으로 설정
//     }
//
//     // gridMode 값을 가져올 때 double 값이 할당되지 않도록 확인
//     bool gridModeValue = box.get('gridMode', defaultValue: false);
//     if (gridModeValue) {
//       isGridMode.value = gridModeValue;
//     } else {
//       isGridMode.value = false; // 기본값으로 설정
//     }
//
//     int selectedFontValue = box.get('selectedFont', defaultValue: SelectedFont.pretendard.index);
//     selectedFont.value = SelectedFont.values[selectedFontValue];
//
//     double fontSizeValue = box.get('fontSizeSlide', defaultValue: 20.0);
//     fontSizeSlider.value = fontSizeValue;
//   }
//
//   void loadMemoCtr() async {
//     isLoading(true);
//     try {
//       var memos = await _settingsRepository.getAllMemoRepo();
//       settingsList(memos);
//     } catch (e) {
//       errorMessage('Failed to load memos: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   // sort
//   void updateSortedName(SortedTime value) async {
//     isLoading(true);
//     try {
//       await _settingsRepository.sortedTimeRepo(value);
//     } catch(e) {
//       errorMessage('Failed to updateSorted: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   void updateFontSlider(double value) {
//     fontSizeSlider.value = value;
//     box.put('fontSizeSlide', value);
//   }
//
//   void updateFont(SelectedFont font) {
//     selectedFont.value = font;
//     box.put('selectedFont', font.index);
//   }
//
//   void toggleDarkMode(bool value) {
//     // 변경 전:
//     // isThemeMode.toggle();
//     // box.put('darkMode', isThemeMode.toggle());
//     // 변경 후: bool는 .toggle() 기능으로 간편하게 처리할 수 있지만, 에러 문구 출력하므로 이전 코드 사용
//     isThemeMode.value = !isThemeMode.value;
//     box.put('darkMode', isThemeMode.value);
//   }
// }