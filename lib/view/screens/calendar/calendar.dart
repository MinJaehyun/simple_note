import 'package:flutter/material.dart';
import 'package:simple_note/const/colors.dart';
import 'package:simple_note/view/screens/memo/add_memo.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var _selectedDay;
  var _focusedDay;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return AddMemo();
                },
              ),
            );
          },
          label: Text('메모 만들기'),
        ),
        appBar: AppBar(
          title: Text('달력 페이지'),
          centerTitle: true,
        ),
        body: TableCalendar(
          locale: 'ko-KR',
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },

          // note: 이하 style
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          calendarStyle: CalendarStyle(
              // note: 오늘 날짜 흐린 스타일 제거하기
              isTodayHighlighted: false,
              // note: 평일 style
              defaultDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: LIGHT_GREY_COLOR,
              ),
              // note: 주말 style
              weekendDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: LIGHT_GREY_COLOR,
              ),
              // note: 선택한 날짜 style
              selectedDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: PRIMARY_COLOR.withOpacity(0.5),
              ),
              // note: 평일 글꼴 style
              defaultTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: DARK_GREY_COLOR,
              ),
              // note: 주말 글꼴 style
              weekendTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: DARK_GREY_COLOR,
              ),
              // note: 선택한 날짜 글꼴 style
              selectedTextStyle: TextStyle(
                fontWeight: FontWeight.w600,
                // color: PRIMARY_COLOR,
              ),
          ),
        ),
      ),
    );
  }
}
