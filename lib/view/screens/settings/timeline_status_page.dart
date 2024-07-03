import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

class TimelineStatusPage extends StatelessWidget {
  const TimelineStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('개발 로드맵'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 5),
                        Text('완료'),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        Icon(Icons.sync, color: Colors.blue, size: 16),
                        SizedBox(width: 5),
                        Text('진행 중'),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        Icon(Icons.circle_outlined, color: Colors.grey, size: 16),
                        SizedBox(width: 5),
                        Text('진행 예정'),
                      ],
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

// todo: 변경된 내용 직접 설정하기
class _Timeline extends StatelessWidget {
  final List<String> _timelineTexts = [
    '메모장 이미지 등록 기능 구현',
    '백업 및 복원 (google drive)',
    '태그',
    '메모 알람 및 달력 타임 라인',
    '메모장 스킨',
    '매년 6월 전체 패키지(pubspec.yaml) 업데이트',
  ];

  @override
  Widget build(BuildContext context) {
    const data = _TimelineStatus.values;
    return Column(
      children: [
        Flexible(
          child: Timeline.tileBuilder(
            theme: TimelineThemeData(
              nodePosition: 0,
              connectorTheme: const ConnectorThemeData(
                thickness: 3.0,
                color: Color(0xffd3d3d3),
              ),
              indicatorTheme: const IndicatorThemeData(
                size: 15.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            builder: TimelineTileBuilder.connected(
              contentsBuilder: (_, index) => _DynamicContents(text: _timelineTexts[index]),
              connectorBuilder: (_, index, __) {
                if (index == 0) {
                  return const SolidLineConnector();
                } else {
                  return const SolidLineConnector();
                }
              },
              indicatorBuilder: (_, index) {
                switch (data[index]) {
                  // todo: 추후, 진행 상태 나타내기
                  case _TimelineStatus.done:
                    return DotIndicator(
                      color: Colors.blue,
                      child: Icon(
                        Icons.sync,
                        color: Colors.white,
                        size: 10.0,
                      ),
                    );

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
                    return const OutlinedDotIndicator(
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

  const _DynamicContents({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      height: 25.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.green[100],
      ),
      child: Center(
        child: Text(text, style: const TextStyle(color: Colors.black45)),
      ),
    );
  }
}

// todo: 추후, 직접 todo4 늘려서 적용하기 (완료, 진행, 예정,)
enum _TimelineStatus {
  done,
  sync,
  todo,
  todo2,
  todo3,
  todo4,
}

extension on _TimelineStatus {
  // bool get done => this == _TimelineStatus.done;
}
