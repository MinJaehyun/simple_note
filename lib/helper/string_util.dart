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
    // '2024.05.01.3:24:27PM
    return DateFormat('yyyy.MM.dd.').add_jms().format(datetime);
  }

  String formatDateKor(DateTime datetime) {
    // '2024년 05월 01일
    return DateFormat('yyyy${'년'} MM${'월'} dd${'일'}').format(datetime);
  }

  String formatDateTimeKor(DateTime datetime) {
    // '2024년 05월 01일 11:30:25AM'
    return DateFormat('yyyy${'년'} MM${'월'} dd${'일'}').add_jms().format(datetime);
  }
}
