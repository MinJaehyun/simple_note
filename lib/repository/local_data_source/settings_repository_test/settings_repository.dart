import 'dart:async';

import 'package:hive/hive.dart';
import 'package:simple_note/model/settings_test/settings.dart';

const String SettingsBox = 'SETTINGS_BOX';

class SettingsRepository {
  static final SettingsRepository _singleton = SettingsRepository._internal();

  factory SettingsRepository() {
    return _singleton;
  }

  SettingsRepository._internal();

  Box<SettingsModel>? settingsBox;

  Future openBox() async {
    settingsBox = await Hive.openBox<SettingsModel>(SettingsBox);
  }
  // note: CRUD
  Future<List<SettingsModel>> getAllMemoRepo() async {
    return settingsBox!.values.toList();
  }

  // sort: update
  Future<void> sortedTimeRepo(value) async {
    // todo: 아래 한줄 필요한가?
    // settingsList.sortedTime.value = value;
    await settingsBox!.put('sortedTime', value);
  }

  // fontSlider: update
  Future<void> selectedFontSliderRepo(value) async {
    await settingsBox!.put('fontSizeSlider', value);
  }

  // font: update
  Future<void> selectedFontRepo(value) async {
    await settingsBox!.put('selectedFont', value);
  }

  // selectedToggleRepo
  Future<void> selectedToggleRepo(value) async {
    await settingsBox!.put('darkMode', value);
  }

  // 복붙용
  Future<void> a(value) async {
    await settingsBox!.put('', value);
  }

  // delete
  // Future deleteRepo(int index) async {
  //   await memoBox!.deleteAt(index);
  // }

}