import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:simple_note/const/colors.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/repository/local_data_source/memo_repository.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/add_memo_page.dart';
import 'package:simple_note/view/screens/public_crud_memo_calendar/update_memo_page.dart';
import 'package:simple_note/view/widgets/public/footer_navigation_bar_widget.dart';
import 'package:simple_note/view/widgets/public/memo_calendar_popup_button_widget.dart';
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
  List<MemoModel> sameSelectedDayMemo = [];
  List<MemoModel> todayIsCheckedTodoList = [];
  List<String> textTitle = [];
  late List<DateTime> dateTimeUtc;

  // note: {2024-06-09 00:22:16.784: [[3, 4, 5]], 2024-06-10 22:33:10.173: [[3, 4, 5]]}
  Map<DateTime, List<dynamic>> eventsList = {};
  final memoController = Get.find<MemoController>();
  final settingsController = Get.find<SettingsController>();

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: DARK_GREY_COLOR, fontWeight: FontWeight.w600),
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      decoration:
                          BoxDecoration(color: PRIMARY_COLOR.withOpacity(0.5), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withOpacity(0.5),
                        shape: BoxShape.rectangle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                },
                outsideBuilder: (context, day, focusedDay) {
                  return Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ),
                    ),
                  );
                },
                headerTitleBuilder: (context, day) {
                  return Text(
                    DateFormat('yyyy.MM').format(DateTime.now()),
                    style: const TextStyle(fontSize: 20),
                  );
                },
              ),

              // note: 이하 style
              // headerTitleBuilder 와 headerStyle 둘 다 적용되지 않는다..
              // headerStyle: buildHeaderStyle(),
              calendarStyle: buildCalendarStyle(),
            ),
            Obx(
              () {
                if (memoController.memoList.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: 100),
                      Text('메모를 생성해 주세요'),
                    ],
                  );
                }

                dateTimeUtc = memoController.memoList.map((e) {
                  return e.createdAt;
                }).toList();

                textTitle = memoController.memoList.map((e) {
                  return e.title;
                }).toList();

                for (int i = 0; i < dateTimeUtc.length; i++) {
                  eventsList.addAll({
                    dateTimeUtc[i]: [textTitle]
                  });
                }

                // note: 선택한 날짜와 == 작성된 날짜가 같은 모든 인스턴스
                sameSelectedDayMemo = memoController.memoList.where((item) {
                  return FormatDate().formatDayEng(item.createdAt) == FormatDate().formatDayEng(_selectedDay!);
                }).toList();

                // note: 모든 박스에서 접근하면 안된다. 선택한 날짜에 해당하는 모든 메모에 접근해야 한다..
                todayIsCheckedTodoList = sameSelectedDayMemo.where((item) {
                  return item.isCheckedTodo == true;
                }).toList();

                // 정렬된 리스트를 생성하여 사용
                var sortedMemoList = List<MemoModel>.from(memoController.memoList)
                  ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

                var result = [];
                for (int i = 0; i < eventsList.values.first.first.length; i++) {
                  result.add(i);
                }

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      CustomPaint(
                        painter: GridPainter(),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              // note: 달력 선택하면 선택한 날짜(_selectedDay)를 나타낸다
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(FormatDate().formatDefaultDateKor(_selectedDay!)),
                                ),
                              ),
                              Text('체크한 메모 '),
                              Text('${todayIsCheckedTodoList.length}', style: TextStyle(color: Colors.redAccent)),
                              Text('개'),
                              Text('  |  금일 작성한 메모 '),
                              Text('${sameSelectedDayMemo.length}', style: TextStyle(color: Colors.redAccent)),
                              Text('개'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 205,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: sameSelectedDayMemo.length,
                          itemBuilder: (context, index) {
                            MemoModel? currentContact = sameSelectedDayMemo[index];
                            // print(sortedMemoList.indexOf(sameSelectedDayMemo[index]));

                            return Card(
                              child: ListTile(
                                title: currentContact.isCheckedTodo == true
                                    ? Text(
                                        currentContact.title,
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: Colors.red, // 취소선 색상 설정
                                          decorationThickness: 3, // 취소선 두께 설정
                                        ),
                                      )
                                    : Text(currentContact.title),
                                subtitle:
                                    Text(FormatDate().formatDotDateTimeKor(currentContact.createdAt), style: TextStyle(color: Colors.grey[500])),
                                dense: true,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        // return UpdateMemoPage(index: index, sortedCard: currentContact);
                                        return UpdateMemoPage(index: sortedMemoList.indexOf(sameSelectedDayMemo[index]), sortedCard: currentContact);
                                      },
                                    ),
                                  );
                                },
                                leading: currentContact.isCheckedTodo == true
                                    ? IconButton(
                                        icon: Icon(Icons.check_box, color: Colors.red),
                                        onPressed: () {
                                          memoController.updateCtr(
                                            index: sortedMemoList.indexOf(sameSelectedDayMemo[index]),
                                            createdAt: currentContact.createdAt,
                                            title: currentContact.title,
                                            selectedCategory: currentContact.selectedCategory,
                                            mainText: currentContact.mainText,
                                            isFavoriteMemo: currentContact.isFavoriteMemo ?? false,
                                            isCheckedTodo: false,
                                          );
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(Icons.check_box_outline_blank, color: Colors.green),
                                        onPressed: () {
                                          memoController.updateCtr(
                                            index: sortedMemoList.indexOf(sameSelectedDayMemo[index]),
                                            createdAt: currentContact.createdAt,
                                            title: currentContact.title,
                                            selectedCategory: currentContact.selectedCategory,
                                            mainText: currentContact.mainText,
                                            isFavoriteMemo: currentContact.isFavoriteMemo ?? false,
                                            isCheckedTodo: true,
                                          );
                                        },
                                      ),
                                trailing: MemoCalendarPopupButtonWidget(sortedMemoList.indexOf(sameSelectedDayMemo[index]), currentContact),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }, //
            ), //
          ],
        ),
        // note: footer/navigation_bar
        bottomNavigationBar: const FooterNavigationBarWidget(0),
      ),
    );
  }

  // 미사용: 위에 직접 설정 넣음
  HeaderStyle buildHeaderStyle() {
    return const HeaderStyle(
        // note: 2week 기능
        // formatButtonVisible: true,
        // titleCentered: true,
        // titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        );
  }

  // 사용: 위에 부분적으로 사용중
  CalendarStyle buildCalendarStyle() {
    return CalendarStyle(
      // note: 오늘 날짜 흐린 스타일 제거하기
      isTodayHighlighted: false,
      // note: 평일 style
      defaultDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
        color: LIGHT_GREY_COLOR,
      ),
      // note: 주말 style
      weekendDecoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
        color: LIGHT_GREY_COLOR,
      ),
      // note: 선택한 날짜 style
      selectedDecoration: BoxDecoration(
        // shape: BoxShape.circle,
        shape: BoxShape.rectangle,
        // error: Failed assertion: line 128 pos 12: 'shape != BoxShape.circle || borderRadius == null': is not true.
        // note: 선택한 날짜에 rectangle 와 circular 사용하면 위 에러 발생하여 임시로 아래 주석처리
        // borderRadius: BorderRadius.circular(10),
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
      markerSize: 9.0,
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
      markersOffset: const PositionedOffset(),
      // marker 모양 조정
      markerDecoration: const BoxDecoration(
        color: Colors.deepOrangeAccent,
        shape: BoxShape.circle,
      ),
    );
  }
}
