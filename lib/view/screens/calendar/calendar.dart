import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/const/colors.dart';
import 'package:simple_note/controller/hive_helper.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/memo/add_memo.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var _selectedDay = DateTime.now();
  var _focusedDay;
  var classifiedTimeMemo;

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
        body: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
              builder: (context, Box<MemoModel> box, _) {
                classifiedTimeMemo = box.values.where((item) => FormatDate().formatDay(item.time) == FormatDate().formatDay(_selectedDay));
                // print('box1: ${box.values.length}');
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      TableCalendar(
                        locale: 'ko-KR',
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: DateTime.now(),
                        // note: 날짜 선택 시, Datetime 타입의 day 를 받을 수 있고 bool 타입을 반환한다.
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        // todo: set marking
                        // eventLoader: _getEventsForDay,
                        // note: 이하 style
                        headerStyle: buildHeaderStyle(),
                        calendarStyle: buildCalendarStyle(),
                      ),
                      Container(
                        height: 50,
                        color: Colors.cyan,
                        child: Row(
                          children: [
                            Expanded(child: Text('${FormatDate().formatDate(_selectedDay)}')),
                            // note: 최초 0개이며, 선택한 날짜에 메모의 개수만큼 나타낸다
                            Text('총 ${classifiedTimeMemo?.length ?? 0} 개의 메모'),
                          ],
                        ),
                      ),
                      Container(
                        height: 275,
                        child: ListView.builder(
                          // note: 분류된 개수만큼만 리스트 채우므로, box는 총16개 이지만, 선택된 날짜에 해당하는 메모만 나타내게 된다
                          itemCount: classifiedTimeMemo.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // print('box3: ${box.values.length}'); // 16,16,16,16
                            MemoModel? currentContact = box.getAt(index);
                            // print(currentContact); // 는 length를 구할수없으므로, classifiedTimeMemo 처리
                            return Card(
                              child: ListTile(
                                title: Text('제목: ${currentContact!.title}'),
                                trailing: IconButton(onPressed: (){},
                                  icon: Icon(Icons.more_vert),),
                              ),
                            );
                          },
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
    );
  }

  HeaderStyle buildHeaderStyle() {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
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
