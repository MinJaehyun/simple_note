import 'package:hive/hive.dart';

part 'trash_can.g.dart';

@HiveType(typeId: 2)
class TrashCanModel {
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

  TrashCanModel({required this.createdAt, required this.title, this.mainText, this.selectedCategory, this.startTime, this.endTime});

  TrashCanModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        mainText = json['mainText'],
        selectedCategory = json['selectedCategory'],
        createdAt = json['createdAt'],
        startTime = json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
        endTime = json['endTime'] != null ? DateTime.parse(json['endTime']) : null;
}
