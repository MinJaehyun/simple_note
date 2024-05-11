import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'view/screens/home/my_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // note: hive 설정
  await Hive.initFlutter();
  Hive.registerAdapter(MemoModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  await HiveHelper().openBox();
  await HiveHelperCategory().openBox();

  // note: intl 초기화
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff00ffff),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.notoSansNKoTextTheme(
          Theme.of(context).textTheme,
        )
      ),
      home: MyPage(),
    );
  }
}
