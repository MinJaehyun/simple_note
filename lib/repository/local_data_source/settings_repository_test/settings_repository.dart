// import 'dart:async';
//
// import 'package:hive/hive.dart';
// import 'package:simple_note/model/settings_test/settings.dart';
//
// const String SettingsBox = 'SETTINGS_BOX';
//
// class SettingsRepository {
//   static final SettingsRepository _singleton = SettingsRepository._internal();
//
//   factory SettingsRepository() {
//     return _singleton;
//   }
//
//   SettingsRepository._internal();
//
//   Box<SettingsModel>? settingsBox;
//
//   Future openBox() async {
//     settingsBox = await Hive.openBox<SettingsModel>(SettingsBox);
//   }
//
//
//
//   // note: CRUD
//   Future<List<SettingsModel>> getAllMemoRepo() async {
//     return settingsBox!.values.toList();
//   }
//
//   Future sortedTimeRepo(value) async {
//     // settingsList.sortedTime.value = value;
//     await settingsBox!.put('sortedTime', value);
//   }
//
//   // delete
//   Future deleteRepo(int index) async {
//     await memoBox!.deleteAt(index);
//   }
// }