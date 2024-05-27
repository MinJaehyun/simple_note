import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:simple_note/view/screens/settings/settings_page.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var gridMode = false.obs;
  var selectedFont = SelectedFont.pretendard.obs;
  var fontSizeSlide = 20.0.obs;

  @override
  void onInit() {
    super.onInit();
    var box = Hive.box('themeModel');

    // isDarkMode.value = box.get('darkMode', defaultValue: false);
    // isDarkMode 값을 가져올 때 double 값이 할당되지 않도록 확인
    dynamic darkModeValue = box.get('darkMode', defaultValue: false);
    if (darkModeValue is bool) {
      isDarkMode.value = darkModeValue;
    } else {
      isDarkMode.value = false; // 기본값으로 설정
    }

    // gridMode 값을 가져올 때 double 값이 할당되지 않도록 확인
    dynamic gridModeValue = box.get('gridMode', defaultValue: false);
    if (gridModeValue is bool) {
      gridMode.value = gridModeValue;
    } else {
      gridMode.value = false; // 기본값으로 설정
    }

    dynamic selectedFontValue = box.get('selectedFont', defaultValue: SelectedFont.pretendard.index);
    if (selectedFontValue is int) {
      selectedFont.value = SelectedFont.values[selectedFontValue];
    } else {
      selectedFont.value = SelectedFont.pretendard; // 혹은 원하는 기본값으로 설정
    }

    double fontSizeValue = box.get('fontSizeSlide', defaultValue: 20.0);
    fontSizeSlide.value = fontSizeValue;
  }

  void updateFontSlider(double value) {
    print(value);
    fontSizeSlide.value = value;
    var box = Hive.box('themeModel');
    box.put('fontSizeSlide', value);
  }

  // 변경 전:
  // void updateFont(SelectedFont font) {
  //   selectedFont.value = font;
  //   // todo: 폰트 저장 테스트 중....
  //   // var selectedFontBox = Hive.box('themeModel').put('selectedFont', selectedFont.value);
  //   // print(selectedFontBox);
  // }

  void updateFont(SelectedFont font) {
    selectedFont.value = font;
    var box = Hive.box('themeModel');
    box.put('selectedFont', font.index);
  }

  void toggleDarkMode() {
    var box = Hive.box('themeModel');
    isDarkMode.value = !isDarkMode.value;
    box.put('darkMode', isDarkMode.value);
  }
}
