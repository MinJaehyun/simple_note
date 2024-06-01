import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/main.dart';

class GridPainter extends CustomPainter {
  var box = Hive.box(themeModeBox);
  bool? isGridVisible;

  @override
  void paint(Canvas canvas, Size size) {
    // print(Hive.box(themeModeBox).values);
    // note: (true, false) 이 생성한 메모 개수 만큼 6개 출력된다.. ListView.builder 에서 itemCount 개수만큼 사용하므로 6개 출력한다
    // note: 즉, themeModeBox 박스에는 (true, false) 이 담기게 된다.
    // 리스트의 첫 번째 요소는 darkmode, 두 번째 요소는 gridmode 가 담겨있다.

    final paint = Paint()
      // note: 다크모드면 연한 흰색 나타내기
      ..color = Hive.box(themeModeBox).values.first == false ? Colors.black12 : Colors.white12
      ..strokeWidth = 1.0;

    const double gridSize = 20.0;

    // note: 인덱스로 접근하면 themeMode가 추가될 수록 바뀌므로, 키 값으로 지정 해야한다.
    // note: 아래 [2]는 gridMode 키의 값을 가져오면 된다(gridMode: true)
    // 변경 전: isGridVisible = Hive.box(themeModeBox).values.toList()[2];
    // 변경 후:
    for (var key in box.keys) {
      var value = box.get(key);
      // print('$key: $value');
      if (key == 'gridMode') {
        isGridVisible = value;
      }
    }

    // 가로 선 그리기
    for (double i = 0; i < size.height; i += gridSize) {
      // canvas.drawLine(Offset(0, i), Offset(size.width, i), paint); // 변경 전
      isGridVisible! ? canvas.drawLine(Offset(0, i), Offset(size.width, i), paint) : null;
    }
    // 세로 선 그리기
    for (double i = 0; i < size.width; i += gridSize) {
      // canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
      isGridVisible! ? canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint) : null;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
