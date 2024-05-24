import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/controller/hive_helper_trash_can.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:simple_note/view/screens/memo/memo_page.dart';

// todo: 추후 hive_helper_dark_mode 파일로 분리하기
const darkModeBox = 'darkModel';

void main() async {
  // note: hive 설정
  await Hive.initFlutter();
  Hive.registerAdapter(MemoModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(TrashCanModelAdapter());
  await HiveHelperMemo().openBox();
  await HiveHelperCategory().openBox();
  await HiveHelperTrashCan().openBox();
  // note: dark mode
  await Hive.openBox(darkModeBox);

  // note: intl 초기화
  await initializeDateFormatting();
  runApp(const GetMaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 다크모드 설정을 위한 ValueListenableBuilder 설정
    return ValueListenableBuilder(
      valueListenable: Hive.box(darkModeBox).listenable(),
      builder: (context, box, widget) {
        var darkMode = box.get('darkMode', defaultValue: false);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // 다크모드 설정
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(),
          // theme 내에 2가지 설정 (colorScheme, textTheme)
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff00ffff),
              brightness: Brightness.light,
            ),
            textTheme: GoogleFonts.notoSansNKoTextTheme(
              ThemeData.light().textTheme,
            ),
          ),
          home: const MemoPage(),
        );
      },
    );
  }
}
