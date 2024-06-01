import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:simple_note/view/screens/settings/settings_page.dart';

enum SortedTime { firstTime, lastTime }

class SettingsController extends GetxController {
  RxBool isDarkMode = false.obs;
  RxBool gridMode = false.obs;
  RxDouble fontSizeSlide = 20.0.obs;
  Rx<SelectedFont> selectedFont = SelectedFont.pretendard.obs;
  Rx<SortedTime> sortedTime = SortedTime.firstTime.obs;

  Box<dynamic> box = Hive.box('themeModel');

  @override
  void onInit() {
    super.onInit();
    // Box<dynamic> box = Hive.box('themeModel');

    // isDarkMode.value = box.get('darkMode', defaultValue: false);
    // isDarkMode 값을 가져올 때 double 값이 할당되지 않도록 확인
    bool darkModeValue = box.get('darkMode', defaultValue: false);
    if (darkModeValue) {
      isDarkMode.value = darkModeValue;
    } else {
      isDarkMode.value = false; // 기본값으로 설정
    }

    // gridMode 값을 가져올 때 double 값이 할당되지 않도록 확인
    bool gridModeValue = box.get('gridMode', defaultValue: false);
    if (gridModeValue) {
      gridMode.value = gridModeValue;
    } else {
      gridMode.value = false; // 기본값으로 설정
    }
    
    int selectedFontValue = box.get('selectedFont', defaultValue: SelectedFont.pretendard.index);
    selectedFont.value = SelectedFont.values[selectedFontValue];

    double fontSizeValue = box.get('fontSizeSlide', defaultValue: 20.0);
    fontSizeSlide.value = fontSizeValue;
  }

  // sort
  void updateSortedName(SortedTime value) {
    sortedTime.value = value;
    box.put('sortedTime', value.index);
  }

  void updateFontSlider(double value) {
    fontSizeSlide.value = value;
    box.put('fontSizeSlide', value);
  }

  void updateFont(SelectedFont font) {
    selectedFont.value = font;
    box.put('selectedFont', font.index);
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = !isDarkMode.value;
    box.put('darkMode', isDarkMode.value);
  }
}
