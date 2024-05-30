import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/controller/hive_helper_trash_can.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// todo: 추후 hive_helper_dark_mode 파일로 분리하기
const themeModeBox = 'themeModel';

void main() async {
  // note: hive 설정
  await Hive.initFlutter();
  Hive.registerAdapter(MemoModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(TrashCanModelAdapter());
  await HiveHelperMemo().openBox();
  await HiveHelperCategory().openBox();
  await HiveHelperTrashCan().openBox();

  // note: themeModeBox(dark/light mode, gridPaingter(on/off)
  await Hive.openBox(themeModeBox);
  // note: intl 초기화
  await initializeDateFormatting();
  // note: GetX Controller 초기화 - 테스트 중...
  Get.put(SettingsController());

  // note: flutter_native_splash 설정 중 필요한 세팅
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // WidgetsFlutterBinding.ensureInitialized();
  // await Future.delayed(const Duration(seconds: 3));
  // FlutterNativeSplash.remove();

  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Firebase.initializeApp().whenComplete(() => {
  //   FlutterNativeSplash.remove() });
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    final settingsController = Get.find<SettingsController>();

    // note: 다크 모드을 위한 ValueListenableBuilder
    return ValueListenableBuilder(
      valueListenable: Hive.box(themeModeBox).listenable(),
      builder: (context, box, widget) {
        // print(Hive.box(themeModeBox).values); //  (false, 28.0, true, 5)
        // print(Hive.box(themeModeBox).values.);
        // var box = Hive.box(themeModeBox);

        // 모든 키를 가져와서 반복하면서 값을 가져옴
        // box.keys.forEach((key) {
        //   var value = box.get(key);
        //   print('$key: $value');
        // });

        var darkMode = box.get('darkMode', defaultValue: true); // Hive
        // bool darkMode = settingsController.isDarkMode.value; // getx
        String selectedFont = settingsController.selectedFont.value.name; // enum의 name을 사용

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // 다크모드 설정
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          // theme 내에 3가지 설정 (폰트 설정, colorScheme, textTheme)
          theme: ThemeData(
            // fontFamily: 'NanumSquareNeo', // 변경 전
            fontFamily: selectedFont,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: Colors.grey[100], // 전체 배경색을 회색으로 설정
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[100], // AppBar의 배경색을 회색으로 설정
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff00ff00),
              brightness: Brightness.dark,
            ),
            // scaffoldBackgroundColor: Colors.grey[900], // 다크 모드의 경우 더 진한 회색으로 설정
          ),
          home: const MemoPage(),
        );
      },
    );
  }
}
