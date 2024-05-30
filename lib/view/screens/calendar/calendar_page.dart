import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/const/colors.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/add_memo_page.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/update_memo_page.dart';
import 'package:simple_note/view/widgets/public/memo_calendar_popup_button_widget.dart';
import 'package:simple_note/view/widgets/public/footer_navigation_bar_widget.dart';
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
  bool isAlarmColor = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    loadEvents();
  }

  // note: 달력 초기 진입 시, 생성된 메모에 마킹 나타내기
  void loadEvents() {
    final box = Hive.box<MemoModel>(MemoBox);
    dateTimeUtc = box.values.map((e) => e.createdAt).toList();
    textTitle = box.values.map((e) => e.title).toList();

    for (int i = 0; i < dateTimeUtc.length; i++) {
      DateTime date = dateTimeUtc[i];
      String title = textTitle[i];

      if (eventsList.containsKey(date)) {
        eventsList[date]!.add(title);
      } else {
        eventsList[date] = [title];
      }
    }

    setState(() {}); // UI를 업데이트
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle style = TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary);

    int getHashCode(DateTime key) {
      return key.day * 1000000 + key.month * 10000 + key.year;
    }

    final events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventsList);

    List getEventForDay(DateTime day) {
      return events[day] ?? [];
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const AddMemoPage();
            }));
          },
          label: const Text('메모 만들기'),
        ),
        appBar: AppBar(
            // title: Text('Simple Note', style: style),
            ),
        body: Column(
          children: [
            TableCalendar(
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
                  getEventForDay(selectedDay);
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              // note: eventLoader: (day){}는? 선택한 달에 나타나는 모든 날짜를 의미한다.
              eventLoader: (day) {
                return getEventForDay(day);
              },
              // note: 이하 style
              headerStyle: buildHeaderStyle(),
              calendarStyle: buildCalendarStyle(),
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box<MemoModel>(MemoBox).listenable(),
              builder: (context, Box<MemoModel> box, _) {
                dateTimeUtc = box.values.map((e) {
                  return e.createdAt;
                }).toList();

                textTitle = box.values.map((e) {
                  return e.title;
                }).toList();

                for (int i = 0; i < dateTimeUtc.length; i++) {
                  eventsList.addAll({
                    dateTimeUtc[i]: [textTitle]
                  });
                }

                classifiedTimeMemo = box.values.where((item) {
                  return FormatDate().formatDayEng(item.createdAt) == FormatDate().formatDayEng(_selectedDay!);
                }).toList();

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      CustomPaint(
                        painter: GridPainter(),
                        child: SizedBox(
                          height: 50,
                          // color: Colors.cyan,
                          child: Row(
                            children: [
                              // note: 달력 선택하면 선택한 날짜(_selectedDay)를 나타낸다
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(FormatDate().formatDefaultDateKor(_selectedDay!)),
                                ),
                              ),
                              Text('총 ${classifiedTimeMemo.length} 개'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 245,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: classifiedTimeMemo.length,
                          itemBuilder: (context, index) {
                            MemoModel? currentContact = classifiedTimeMemo[index];
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return UpdateMemoPage(index: index, currentContact: currentContact);
                                    }),
                                  );
                                },
                                leading: isAlarmColor
                                    ? const Icon(Icons.access_alarm, color: Colors.red)
                                    : const Icon(Icons.access_alarm, color: Colors.green),
                                title: Text(currentContact.title),
                                subtitle:
                                    Text(FormatDate().formatDotDateTimeKor(currentContact.createdAt), style: TextStyle(color: Colors.grey[500])),
                                dense: true,
                                trailing: MemoCalendarPopupButtonWidget(index, currentContact),
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
        // note: footer/navigation_bar
        bottomNavigationBar: const FooterNavigationBarWidget(0),
      ),
    );
  }

  HeaderStyle buildHeaderStyle() {
    return const HeaderStyle(
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
      selectedTextStyle: const TextStyle(
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
