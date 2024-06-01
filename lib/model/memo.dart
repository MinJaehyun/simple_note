import 'package:hive/hive.dart';

part 'memo.g.dart';

// note: typeId 는 모델마다 달라야 한다.
@HiveType(typeId: 1)
class MemoModel extends HiveObject {
  @HiveField(0)
  final DateTime createdAt;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? mainText;

  @HiveField(3)
  final String? selectedCategory;

  @HiveField(4)
  final DateTime? startTime;

  @HiveField(5)
  final DateTime? endTime;

  @HiveField(6)
  final bool? isFavoriteMemo;

  // 변경 전: 사용 가능하나, this.createdAt, this.title는 positional parameter 이므로 가독성이 좋지 않다.
  // MemoModel(this.createdAt, this.title, {this.mainText, this.selectedCategory, this.startTime, this.endTime});

  // 변경 후
  MemoModel({
    required this.createdAt,
    required this.title,
    this.mainText,
    this.selectedCategory,
    this.startTime,
    this.endTime,
    this.isFavoriteMemo = false,
  });

  MemoModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        mainText = json['mainText'],
        selectedCategory = json['selectedCategory'],
        createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
        startTime = json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
        endTime = json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
        isFavoriteMemo = json['isFavoriteMemo'] as bool? ?? false;
}
