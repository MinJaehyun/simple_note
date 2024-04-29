// id는 직접 지정하지 않을 것이다..
// time
// title
// mainText: 본문

import 'package:hive/hive.dart';
part 'memo.g.dart';

@HiveType(typeId: 0)
class MemoModel {
  @HiveField(0)
  final DateTime time;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String mainText;

  MemoModel({required this.title, required this.time, required this.mainText});

  // json 만들기
  MemoModel.fromJson(Map<String, dynamic> json)
      : time = json['time'],
        title = json['title'],
        mainText = json['mainText'];
}
