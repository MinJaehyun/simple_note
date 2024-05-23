import 'package:intl/intl.dart';

class FormatDate {
  // 사용 중
  String formatDayEng(DateTime datetime) {
    // Mon, 5/6/2024
    return DateFormat.yMEd().format(datetime);
  }
  // 사용 중
  String formatDefaultDateKor(DateTime datetime) {
    // '2024.05.01
    return DateFormat('yyyy.MM.dd').format(datetime);
  }

  // // 사용 중: 공통
  String formatDotDateTimeKor(DateTime datetime) {
    // '2024.05.01.03:24
    return DateFormat('yyyy.MM.dd. ').add_Hm().format(datetime);
  }

  // String formatDateKor(DateTime datetime) {
  //   // '2024년 05월 01일
  //   return DateFormat('yyyy${'년'} MM${'월'} dd${'일'}').format(datetime);
  // }

  // String formatOnlyTimeKor(DateTime datetime) {
  //   // 02:15
  //   return DateFormat().add_Hm().format(datetime);
  // }

  String formatSimpleTimeKor(DateTime datetime) {
    // 24.05.17
    return DateFormat("yy.MM.dd").format(datetime);
  }

  // String formatDateTimeKor(DateTime datetime) {
  //   // '2024년 05월 01일 11:30:25AM'
  //   return DateFormat('yyyy${'년'} MM${'월'} dd${'일'}').add_jms().format(datetime);
  // }
}
