import 'package:hive/hive.dart';

part 'settings.g.dart';

enum SelectedFont { pretendard, d2coding, nanumBrush, nanumMyeongjo, nanumPen, NanumSquareNeo }
enum SortedTime { firstTime, lastTime }

@HiveType(typeId: 3)
class SettingsModel extends HiveObject {
  @HiveField(0)
  final bool isThemeMode;

  @HiveField(1)
  final bool isGridMode;

  @HiveField(2)
  final double fontSizeSlider;

  @HiveField(3)
  final SelectedFont selectedFont;

  @HiveField(4)
  final SortedTime sortedTime;

  // 변경 후
  SettingsModel({
    this.isThemeMode = false,
    this.isGridMode = true,
    this.selectedFont = SelectedFont.pretendard,
    this.sortedTime = SortedTime.firstTime,
    this.fontSizeSlider = 20.0,
  });

  SettingsModel.fromJson(Map<String, dynamic> json)
      : isThemeMode = json['isThemeMode'],
        isGridMode = json['isGridMode'],
        selectedFont = json['selectedFont'],
        sortedTime = json['sortedTime'],
        fontSizeSlider = json['fontSizeSlider'] as double? ?? 20.0;
}
