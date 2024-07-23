import 'dart:math';

import 'package:flutter/material.dart';

// note: 달력 스타일에 사용
const PRIMARY_COLOR = Color(0xFF0DB2B2);
final DARK_GREY_COLOR = Colors.grey[600];
final LIGHT_GREY_COLOR = Colors.grey[200];
final TEXT_FIELD_FILL_COLOR = Colors.grey[300];
final RED_ACCENT = Colors.redAccent;

// weight
final WEIGHT_600 = FontWeight.w600;

// note: 달력 및 범주 내에 하단 ListTile의 테두리에 사용할 색상 변수: 추후 분리하기
final List<Color> neonColors = [
  Colors.yellow,
  Colors.green,
  Colors.blueAccent,
  Colors.pinkAccent,
  Colors.orangeAccent,
];

// note: 달력 및 범주 내에 하단 ListTile의 테두리에 사용할 색상 변수: 추후 분리하기
Color getRandomNeonColor() {
  final random = Random();
  return neonColors[random.nextInt(neonColors.length)];
}