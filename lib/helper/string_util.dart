import 'package:intl/intl.dart';

class FormatDate {
  String formatDate(DateTime datetime) {
    // ==> '2024년 05월 01일  11:30:25AM'
    return DateFormat('yyyy${'년'} MM${'월'} dd${'일'} ').add_jms().format(datetime);
  }
}
