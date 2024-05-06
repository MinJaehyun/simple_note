import 'package:hive/hive.dart';
part 'category.g.dart';

@HiveType(typeId: 0)
class CategoryModel {
  @HiveField(0)
  final String? categories;

  CategoryModel(this.categories);

  CategoryModel.fromJson(Map<String, dynamic> json)
      : categories = json['categories'];
}
