import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  bool isCategories = false;

  // todo: widget.title 값 가져와서 넣기
  String title = '';

  String _dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    void dropdownCallback(String? selectedValue) {
      if (selectedValue is String) {
        setState(() {
          _dropdownValue = selectedValue;
        });
      }
    }

    DropdownButton<String> DropdownButtonWidget() {
      return DropdownButton(
        value: _dropdownValue.isNotEmpty
            ? _dropdownValue
            : null,
        onChanged: dropdownCallback,
        items: const [
          DropdownMenuItem(
              child: Text('직장'), value: 'job'),
          DropdownMenuItem(
              child: Text('감사일기'), value: 'thanksDairy'),
          DropdownMenuItem(
              child: Text('일상'), value: 'today'),
        ],
        iconSize: 35,
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // note: 상단 컨테이너
            Padding(
              padding: const EdgeInsets.all(8.0),
              // note: 상단 컨테이너
              child: Container(
                color: Colors.green,
                height: 80,
                child: Row(
                  children: [
                    Expanded(child: Text('${DateTime.now()}')),
                    // Text('직장'),
                    TextButton.icon(
                      onPressed: () {
                        // todo: 클릭하면 하단에 리스트로 카테고리 나타내기
                        setState(() {
                          isCategories = !isCategories;
                        });
                      },
                      icon: isCategories
                          ? Icon(Icons.arrow_drop_up)
                          : DropdownButtonWidget(),
                      label: Text(''),
                    ),
                  ],
                ),
              ),
            ),
            // note: 중단 컨테이너
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.green,
                // height: 80,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '제목을 입력해 주세요',
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
              ),
            ),
            // note: 하단 컨테이너
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.green,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '내용을 입력해 주세요',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ),
            ),
            // note: save and cancel
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // todo: 클릭 시, 메모 저장하고, 홈화면으로 이동하며, 저장한 메모 나타내기
                        setState(() {
                          // todo: 홈화면에서 메모 데이터 만들고 가져오기
                          // todo: 상위에서 메모 데이터에 저장하기 위해, 하위에서 멤버변수와 생성자 만들기

                        });
                      },
                      child: Text('저장'),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('취소'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
