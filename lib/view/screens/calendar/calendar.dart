import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/const/colors.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/memo/add_memo.dart';
import 'package:simple_note/view/widgets/public/navigation_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<MemoModel> classifiedTimeMemo = [];
  List<String> textTitle = [];
  late List<DateTime> dateTimeUtc;
  Map<DateTime, List<dynamic>> eventsList = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    int getHashCode(DateTime key) {
      return key.day * 1000000 + key.month * 10000 + key.year;
    }

    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventsList);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return AddMemo();
            }));
          },
          label: Text('메모 만들기'),
        ),
        appBar: AppBar(title: Text('달력'), centerTitle: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
                builder: (context, Box<MemoModel> box, _) {
                  return TableCalendar(
                    locale: 'ko-KR',
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    // note: 날짜 선택 시, Datetime 타입의 day 를 받을 수 있고 bool 타입을 반환한다.
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        _getEventForDay(selectedDay);
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    // note: eventLoader: (day){}는? 선택한 달에 나타나는 모든 날짜를 의미한다.
                    eventLoader: (day) {
                      return _getEventForDay(day);
                    },
                    // note: 이하 style
                    headerStyle: buildHeaderStyle(),
                    calendarStyle: buildCalendarStyle(),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
                builder: (context, Box<MemoModel> box, _) {
                  dateTimeUtc = box.values.map((e) {
                    return e.time;
                  }).toList();

                  textTitle = box.values.map((e) {
                    return e.title;
                  }).toList();

                  for (int i = 0; i < dateTimeUtc.length; i++) {
                    eventsList.addAll({
                      dateTimeUtc[i]: [textTitle]
                    });
                  }

                  classifiedTimeMemo = box.values.where((item) => FormatDate().formatDayEng(item.time) == FormatDate().formatDayEng(_selectedDay!)).toList();

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          color: Colors.cyan,
                          child: Row(
                            children: [
                              // note: 달력 선택하면 선택한 날짜(_selectedDay)를 나타낸다
                              Expanded(child: Text('${FormatDate().formatDateKor(_selectedDay!)}')),
                              Text('총 ${classifiedTimeMemo.length ?? 0} 개의 메모'),
                            ],
                          ),
                        ),
                        Container(
                          height: 245,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // 반복문으로 MemoModel 인스턴스에 접근
                                for (MemoModel memo in classifiedTimeMemo)
                                  Card(child: ListTile(title: Text("제목: ${memo.title}")))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // note: navigation bar
        bottomNavigationBar: BuildCurvedNavigationBar(0),
      ),
    );
  }

HeaderStyle buildHeaderStyle() {
  return HeaderStyle(
    // note: 2week 기능
    // formatButtonVisible: false,
    titleCentered: true,
    titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  );
}

CalendarStyle buildCalendarStyle() {
  return CalendarStyle(
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
    // marker 여러개 일 때 cell 영역을 벗어날지 여부
    canMarkersOverflow: false,
    // 자동정렬 여부
    markersAutoAligned: true,
    // marker 크기 조절
    markerSize: 7.0,
    // marker 크기 비율 조절
    markerSizeScale: 10.0,
    // marker 의 기준점 조정
    markersAnchor: 0.7,
    // marker margin 조절
    markerMargin: const EdgeInsets.symmetric(horizontal: 0.3),
    // marker 위치 조정
    markersAlignment: Alignment.bottomCenter,
    // 한줄에 보여지는 marker 갯수
    markersMaxCount: 1,
    //
    markersOffset: const PositionedOffset(),
    // marker 모양 조정
    markerDecoration: const BoxDecoration(
      color: Colors.deepOrangeAccent,
      shape: BoxShape.rectangle,
    ),
  );
  }

}
