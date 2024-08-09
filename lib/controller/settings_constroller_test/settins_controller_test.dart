import 'package:get/get.dart';
import 'package:simple_note/model/settings_test/settings.dart';
import 'package:simple_note/repository/local_data_source/settings_repository_test/settings_repository.dart';

class SettingsController extends GetxController {
  late SettingsRepository _settingsRepository;

  RxList<SettingsModel> settingsList = <SettingsModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // RxBool isThemeMode = false.obs;
  // RxBool isGridMode = false.obs;
  // RxDouble fontSizeSlider = 20.0.obs;
  // Rx<SelectedFont> selectedFont = SelectedFont.pretendard.obs;
  // Rx<SortedTime> sortedTime = SortedTime.firstTime.obs;

  // Box<dynamic> box = Hive.box('themeModel');

  @override
  void onInit() {
    super.onInit();
    _settingsRepository = SettingsRepository();
    loadMemoCtr();
    // Box<dynamic> box = Hive.box('themeModel');

    // isDarkMode.value = box.get('darkMode', defaultValue: false);
    // isDarkMode 값을 가져올 때 double 값이 할당되지 않도록 확인

    // bool darkModeValue = box.get('darkMode', defaultValue: false);
    // if (darkModeValue) {
    //   isThemeMode.value = darkModeValue;
    // } else {
    //   isThemeMode.value = false; // 기본값으로 설정
    // }

    // gridMode 값을 가져올 때 double 값이 할당되지 않도록 확인
    // bool gridModeValue = box.get('gridMode', defaultValue: false);
    // if (gridModeValue) {
    //   isGridMode.value = gridModeValue;
    // } else {
    //   isGridMode.value = false; // 기본값으로 설정
    // }

    // int selectedFontValue = box.get('selectedFont', defaultValue: SelectedFont.pretendard.index);
    // selectedFont.value = SelectedFont.values[selectedFontValue];

    // double fontSizeValue = box.get('fontSizeSlide', defaultValue: 20.0);
    // fontSizeSlider.value = fontSizeValue;
  }

  // load data
  void loadMemoCtr() async {
    isLoading(true);
    try {
      List<SettingsModel> memos = await _settingsRepository.getAllMemoRepo();
      settingsList.assignAll(memos);
    } catch (e) {
      errorMessage('Failed to load memos: $e');
    } finally {
      isLoading(false);
    }
  }

  // sort: update
  void updateSortedName(SortedTime value) async {
    isLoading(true);
    try {
      await _settingsRepository.sortedTimeRepo(value);
    } catch(e) {
      errorMessage('Failed to updateSorted: $e');
    } finally {
      isLoading(false);
    }
  }

  // fontSlider: update
  void updateFontSlider(value) async {
    isLoading(true);
    try {
      await _settingsRepository.selectedFontSliderRepo(value);
    } catch(e) {
      errorMessage('Failed to updateFontSlider: $e');
    } finally {
      isLoading(false);
    }
  }

  // font: update
  void updateFont(SelectedFont value) async {
    isLoading(true);
    try {
      await _settingsRepository.selectedFontRepo(value);
    } catch(e) {
      errorMessage('Failed to updateFontSlider: $e');
    } finally {
      isLoading(false);
    }
  }

  // toggleDarkMode: update
  void updateToggleDarkMode(bool value) async {
    isLoading(true);
    try {
      await _settingsRepository.selectedToggleRepo(value);
    } catch(e) {
      errorMessage('Failed to updateFontSlider: $e');
    } finally {
      isLoading(false);
    }
  }

}
