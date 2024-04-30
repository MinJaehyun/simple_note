import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/helper/hive_helper.dart';
import 'package:simple_note/model/memo.dart';
import 'view/screens/home/my_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MemoModelAdapter());
  await HiveHelper().openBox();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyPage(),
    );
  }
}
