import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/category_controller.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/trash_can_memo_controller.dart';
import 'package:simple_note/repository/local_data_source/category_repository.dart';
import 'package:simple_note/repository/local_data_source/memo_repository.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:simple_note/repository/local_data_source/trash_can_memo_repository.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// todo: 추후 hive_helper_dark_mode 파일로 분리하기
const themeModeBox = 'themeModel';

void main() async {
  // note: flutter_native_splash 설정 중 필요한 세팅
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // 스플래시 화면을 보여주기 위해 5초간 대기
  await initialization();

  // 광고 기능 초기화
  MobileAds.instance.initialize();

  // note: hive 설정
  await Hive.initFlutter();
  Hive.registerAdapter(MemoModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(TrashCanModelAdapter());
  await MemoRepository().openBox();
  await TrashCanMemoRepository().openBox();
  await CategoryRepository().openBox();

  // note: themeModeBox(dark/light mode, gridPaingter(on/off)
  await Hive.openBox(themeModeBox);
  // note: intl 초기화
  await initializeDateFormatting();
  // note: Get.put은 즉시 컨트롤러를 생성하는 반면, Get.lazyPut은 실제로 필요할 때까지 컨트롤러를 생성하지 않습니다
  Get.lazyPut<SettingsController>(() => SettingsController());
  Get.lazyPut<MemoController>(() => MemoController());
  Get.lazyPut<TrashCanMemoController>(() => TrashCanMemoController());
  Get.lazyPut<CategoryController>(() => CategoryController());
  runApp(MyApp());
}

Future initialization() async {
  await Future.delayed(const Duration(seconds: 3));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove();
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

        bool darkMode = box.get('darkMode', defaultValue: true); // Hive
        // RxBool darkMode = settingsController.isDarkMode; // getx
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
