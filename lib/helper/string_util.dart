import 'package:intl/intl.dart';

class FormatDate {
  String formatDayEng(DateTime datetime) {
    // Mon, 5/6/2024
    return DateFormat.yMEd().format(datetime);
  }

  String formatDefaultDateKor(DateTime datetime) {
    // '2024.05.01
    return DateFormat('yyyy.MM.dd').format(datetime);
  }

  String formatDotDateTimeKor(DateTime datetime) {
    // '2024.05.01.03:24
    return DateFormat('yyyy.MM.dd. ').add_Hm().format(datetime);
  }

  String formatSimpleTimeKor(DateTime datetime) {
    // 24.05.17
    return DateFormat("yy.MM.dd").format(datetime);
  }
  
}
