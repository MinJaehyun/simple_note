import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

class TimelineStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('개발 로드맵'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Container(
              height: 30,
              width: double.infinity,
              // color: Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    child: Row(
                      children: [Icon(Icons.check_circle, color: Colors.green, size: 16), Text('완료')],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: [Icon(Icons.circle, color: Colors.blue, size: 16), Text('진행 중')],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: [Icon(Icons.circle_outlined, color: Colors.grey, size: 16), Text('진행 예정')],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _Timeline(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final List<String> _timelineTexts = [
    '백업 및 복원 (google drive)',
    '메모장 이미지 등록 기능',
    '매년 6월 전체 패키지(pubspec.yaml) 업데이트',
    // '메모장 스킨',
    // '태그',
    // '메모 알람 및 달력 타임 라인',
  ];

  @override
  Widget build(BuildContext context) {
    final data = _TimelineStatus.values;
    return Column(
      children: [
        Flexible(
          child: Timeline.tileBuilder(
            theme: TimelineThemeData(
              nodePosition: 0,
              connectorTheme: ConnectorThemeData(
                thickness: 3.0,
                color: Color(0xffd3d3d3),
              ),
              indicatorTheme: IndicatorThemeData(
                size: 15.0,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20.0),
            builder: TimelineTileBuilder.connected(
              contentsBuilder: (_, index) => _DynamicContents(text: _timelineTexts[index]),
              connectorBuilder: (_, index, __) {
                if (index == 0) {
                  // todo: 추후 완료되면 아래에 color: Color(0xff6ad192) 색상 넣기
                  return SolidLineConnector();
                } else {
                  return SolidLineConnector();
                }
              },
              indicatorBuilder: (_, index) {
                switch (data[index]) {
                  // case _TimelineStatus.done:
                  //   return DotIndicator(
                  //     color: Color(0xff6ad192),
                  //     child: Icon(
                  //       Icons.check,
                  //       color: Colors.white,
                  //       size: 10.0,
                  //     ),
                  //   );

                  // case _TimelineStatus.sync:
                  //   return DotIndicator(
                  //     color: Color(0xff193fcc),
                  //     child: Icon(
                  //       Icons.sync,
                  //       color: Colors.white,
                  //       size: 10.0,
                  //     ),
                  //   );

                  // case _TimelineStatus.inProgress:
                  //   return OutlinedDotIndicator(
                  //     color: Color(0xffa7842a),
                  //     borderWidth: 2.0,
                  //     backgroundColor: Color(0xffebcb62),
                  //   );
                  // case _TimelineStatus.todo:
                  default:
                    return OutlinedDotIndicator(
                      color: Color(0xffbabdc0),
                      backgroundColor: Color(0xffe6e7e9),
                    );
                }
              },
              itemExtentBuilder: (_, __) => kTileHeight,
              itemCount: data.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _DynamicContents extends StatelessWidget {
  final String text;

  _DynamicContents({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0),
      height: 25.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Color(0xffe6e7e9),
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

enum _TimelineStatus {
  done,
  sync,
  inProgress,
  todo,
}

extension on _TimelineStatus {
  bool get isInProgress => this == _TimelineStatus.inProgress;
}
