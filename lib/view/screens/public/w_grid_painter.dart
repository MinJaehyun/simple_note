import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/main.dart';

class GridPainter extends CustomPainter {
  final settingsCtr = Get.find<SettingsController>();
  // themeModeBox는 여러 종류이므로 dynamic 설정함
  Box<dynamic> box = Hive.box(themeModeBox);
  bool isGridVisible = true;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    // note: 다크모드면 연한 흰색 나타내기(isGridMode 아니다!)
      ..color = settingsCtr.isThemeMode == true ? Colors.black12 : Colors.white12
      ..strokeWidth = 1.0;

    const double gridSize = 20.0;

    // note: 인덱스로 접근하면 themeMode가 추가될 수록 바뀌므로, 키 값으로 지정 해야한다.
    // note: 아래 [2]는 gridMode 키의 값을 가져오면 된다(gridMode: true)
    // 변경 전: isGridVisible = Hive.box(themeModeBox).values.toList()[2];
    // 변경 후:
    for (var key in box.keys) {
      var value = box.get(key);
      // print('$key: $value');
      if (key == 'isGridMode') {
        isGridVisible = value;
      }
    }

    // 가로 선 그리기
    for (double i = 0; i < size.height; i += gridSize) {
      // canvas.drawLine(Offset(0, i), Offset(size.width, i), paint); // 변경 전
      isGridVisible ? canvas.drawLine(Offset(0, i), Offset(size.width, i), paint) : null;
    }
    // 세로 선 그리기
    for (double i = 0; i < size.width; i += gridSize) {
      // canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
      isGridVisible ? canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint) : null;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}