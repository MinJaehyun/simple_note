import 'package:get/get.dart';
import 'package:hive/hive.dart';

// note: 프리텐드, 나눔고딕 D2coding, 나눔손글씨 붓, 나눔명조, 나눔손글씨 펜, 나눔스퀘어 네오
enum SelectedFont { pretendard, d2coding, nanumBrush, nanumMyeongjo, nanumPen, NanumSquareNeo }
enum SortedTime { firstTime, lastTime }

class SettingsController extends GetxController {
  // note: 모델을 통해서 설정 페이지에서 뭔가를 만드는게 아니므로, 모델 작성할 필요 없다
  // var settingsInstance = <SettingsModel>[].obs; // 임시

  RxBool isThemeMode = false.obs;
  RxBool isGridMode = false.obs;
  RxDouble fontSizeSlider = 20.0.obs;
  Rx<SelectedFont> selectedFont = SelectedFont.pretendard.obs;
  Rx<SortedTime> sortedTime = SortedTime.firstTime.obs;
  RxBool isAppbarFavoriteMemo = false.obs;
  Box<dynamic> themeBox = Hive.box('themeModel');

  @override
  void onInit() {
    super.onInit();

    bool darkModeValue = themeBox.get('isThemeMode', defaultValue: false);
    if (darkModeValue) {
      isThemeMode.value = darkModeValue;
    } else {
      isThemeMode.value = false;
    }

    // note: 초기 설정 없으면 기본값으로 풀린다.
    bool gridModeValue = themeBox.get('isGridMode', defaultValue: false);
    if (gridModeValue) {
      isGridMode.value = gridModeValue;
    } else {
      isGridMode.value = false;
    }
    
    int selectedFontValue = themeBox.get('selectedFont', defaultValue: SelectedFont.pretendard.index);
    selectedFont.value = SelectedFont.values[selectedFontValue];

    // double fontSizeValue = themeBox.get('fontSizeSlider', defaultValue: 20.0);
    // fontSizeSlider.value = fontSizeValue;
  }

  void updateAppbarFavoriteMemo() {
    isAppbarFavoriteMemo.value = !isAppbarFavoriteMemo.value;
    themeBox.put('isAppbarFavoriteMemo', isAppbarFavoriteMemo.value);
  }

  // sort
  void updateSortedName(SortedTime value) {
    sortedTime.value = value;
    themeBox.put('sortedTime', value.index);
  }

  void updateFontSlider(double value) {
    print(value);
    fontSizeSlider.value = value;
    print(fontSizeSlider.value);
    themeBox.put('fontSizeSlider', fontSizeSlider.value);
  }

  void updateFont(SelectedFont font) {
    // print(font);
    // print(selectedFont.value);
    selectedFont.value = font;
    themeBox.put('selectedFont', selectedFont.value.index);
  }

  void toggleDarkMode(bool value) {
    // 변경 전:
    // isThemeMode.toggle();
    // themeBox.put('darkMode', isThemeMode.toggle());
    // 변경 후: bool는 .toggle() 기능으로 간편하게 처리할 수 있지만, 에러 문구 출력하므로 이전 코드 사용
    isThemeMode.value = value;
    themeBox.put('isThemeMode', isThemeMode.value);
  }

  void toggleGridMode(bool value) {
    isGridMode.value = value;
    themeBox.put('isGridMode', isGridMode.value);
  }

}
