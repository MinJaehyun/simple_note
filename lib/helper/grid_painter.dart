import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/settings_controller.dart';

// todo: 코드 개선하기 (isGridVisible는 격자 설정 변수로써, controll => repository 사용하여 리펙토링하기)
class GridPainter extends CustomPainter {
  final settingsController = Get.find<SettingsController>();

  @override
  void paint(Canvas canvas, Size size) {
    // note: (true, false) 이 생성한 메모 개수 만큼 6개 출력된다.. ListView.builder 에서 itemCount 개수만큼 사용하므로 6개 출력한다

    final paint = Paint();
      // note: 다크모드면 연한 흰색 나타내기
      //  box.values.first == false
    // fixme:
    paint.color = settingsController.isGridMode == false ? Colors.black12 : Colors.white12;
    // paint.color = settingsController.isGridMode == true ? Colors.black12 : Colors.white12;
    paint.strokeWidth = 1.0;

    const double gridSize = 20.0;

    // note: 인덱스로 접근하면 themeMode가 추가될 수록 바뀌므로, 키 값으로 지정 해야한다.
    // note: 아래 [2]는 gridMode 키의 값을 가져오면 된다(gridMode: true)
    // 변경 전: 삭제함.. 240616
    // for (var key in box.keys) {
    //   var value = box.get(key);
    //   // print('$key: $value');
    //   if (key == 'gridMode') {
    //     // settingsController.isGridMode = value;
    //     settingsController.updateAppbarFavoriteMemo();
    //   }
    // }

    // 가로 선 그리기
    for (double i = 0; i < size.height; i += gridSize) {
      // canvas.drawLine(Offset(0, i), Offset(size.width, i), paint); // 변경 전
      settingsController.isGridMode == true ? canvas.drawLine(Offset(0, i), Offset(size.width, i), paint) : null;
    }
    // 세로 선 그리기
    for (double i = 0; i < size.width; i += gridSize) {
      // canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
      settingsController.isGridMode == true ? canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint) : null;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
