import 'package:hive/hive.dart';
part 'memo.g.dart';

@HiveType(typeId: 1)
class MemoModel {
  @HiveField(0)
  final DateTime time;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String mainText;

  @HiveField(3)
  final String? selectedCategory;

  MemoModel(this.selectedCategory, this.mainText, {required this.time, required this.title});

  MemoModel.fromJson(Map<String, dynamic> json)
      : time = json['time'],
        title = json['title'],
        mainText = json['mainText'],
        selectedCategory = json['selectedCategory'];
}
