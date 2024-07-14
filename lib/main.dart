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
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// todo: 추후 hive_helper_dark_mode 파일로 분리하기
const themeModeBox = 'themeModel';

void main() async {
  // note: flutter_native_splash 설정 중 필요한 세팅
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // 스플래시 화면을 보여주기 위해 3초간 대기
  await initialization();

  // 광고 기능 초기화
  MobileAds.instance.initialize();
  await dotenv.load(fileName: ".env");

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
    return Obx(
      () {
        RxBool darkMode = settingsController.isThemeMode;
        String selectedFont = settingsController.selectedFont.value.name; // enum의 name을 사용

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: darkMode.value == true ? ThemeMode.light : ThemeMode.dark,
          // note: theme 3가지 설정(폰트, colorScheme, textTheme)
          theme: ThemeData(
            fontFamily: selectedFont,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: AppBarTheme(backgroundColor: Colors.grey[100]),
          ),
          darkTheme: ThemeData(
            // fix: 다크 모드 시, 폰트 적용
            fontFamily: selectedFont,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff00ff00),
              brightness: Brightness.dark,
            ),
          ),
          home: const MemoPage(),
        );
      },
    );
  }
}
