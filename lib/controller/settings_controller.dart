import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:simple_note/view/screens/settings/settings_page.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var gridMode = false.obs;
  var selectedFont = SelectedFont.pretendard.obs;

  @override
  void onInit() {
    super.onInit();
    var box = Hive.box('themeModel');
    isDarkMode.value = box.get('darkMode', defaultValue: false);

    // selectedFont.value = SelectedFont.values[box.get('selectedFont', defaultValue: SelectedFont.pretendard)]; // 변경 전
    // int selectedFontIndex = box.get('selectedFont', defaultValue: SelectedFont.pretendard.index); // index로 가져오기
    // selectedFont.value = SelectedFont.values[selectedFontIndex];  // index를 enum으로 변환

    // 변경된 부분
    dynamic selectedFontValue = box.get('selectedFont', defaultValue: SelectedFont.pretendard.index);
    if (selectedFontValue is int) {
      print('1: ${SelectedFont.values[selectedFontValue]}');
      selectedFont.value = SelectedFont.values[selectedFontValue];
    } else {
      print('2: ${SelectedFont.values[selectedFontValue]}');
      selectedFont.value = SelectedFont.pretendard; // 혹은 원하는 기본값으로 설정
    }
  }

  // 변경 전:
  // void updateFont(SelectedFont font) {
  //   selectedFont.value = font;
  //   // todo: 폰트 저장 테스트 중....
  //   // var selectedFontBox = Hive.box('themeModel').put('selectedFont', selectedFont.value);
  //   // print(selectedFontBox);
  // }

  void updateFont(SelectedFont font) {
    // print(font); // SelectedFont.pretendard
    selectedFont.value = font;
    var box = Hive.box('themeModel');
    box.put('selectedFont', font.index);
    // print(font.index);
  }

  void toggleDarkMode() {
    var box = Hive.box('themeModel');
    isDarkMode.value = !isDarkMode.value;
    box.put('darkMode', isDarkMode.value);
  }
}
