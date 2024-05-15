import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/view/screens/category/all_category.dart';

class UpdateMemo extends StatefulWidget {
  UpdateMemo({super.key, required this.currentContact, required this.index});

  final MemoModel currentContact;
  final int index;

  @override
  State<UpdateMemo> createState() => _UpdateMemoState();
}

class _UpdateMemoState extends State<UpdateMemo> {
  final _formKey = GlobalKey<FormState>();
  late DateTime time = widget.currentContact.createdAt;
  late String title = widget.currentContact.title;
  late String? mainText = widget.currentContact.mainText;
  late String? _dropdownValue = widget.currentContact.selectedCategory;

  @override
  Widget build(BuildContext context) {
    // ui에 나타낼 _dropdownValue 변경함
    void dropdownCallback(String? selectedValue) {
      if (selectedValue is String) {
        setState(() {
          _dropdownValue = selectedValue;
        });
      }
    }

    DropdownButton<String> DropdownButtonWidget(Box<CategoryModel> box) {
      return DropdownButton(
        style: const TextStyle(color: Colors.green),
        underline: Container(height: 2, color: Colors.green[100]),
        // value: _dropdownValue!.isNotEmpty ? _dropdownValue : null,
        value: null,
        // ui에 나타낼 _dropdownValue 나타냄
        hint: Text('$_dropdownValue'),
        onChanged: dropdownCallback,
        items: box.values.toList().map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value.categories,
            // todo 아래 고민하기
            child: Text(value.categories ?? 'test3'),
          );
        }).toList(),
        iconSize: 35,
      );
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: ValueListenableBuilder(
            valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
            builder: (context, Box<CategoryModel> box, _) {
              if (box.values.isEmpty) return Center(child: Text('test update memo'));
              return Column(
                children: [
                  // 상단: 시간 및 범주 메뉴
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 80,
                      child: Row(
                        children: [
                          // 시간
                          Expanded(
                            child: Text(
                              FormatDate().formatDotDateTimeKor(widget.currentContact.createdAt),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          // 범주
                          TextButton(
                            // TextButton 간격 줄이기 위해 패딩과 마진값을 제거
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: DropdownButtonWidget(box),
                          ),
                          // 범주 생성 버튼
                          IconButton(
                            // IconButton 간격 줄이기 위해 패딩과 마진값을 제거
                            visualDensity: const VisualDensity(horizontal: -4),
                            // visualDensity: VisualDensity.compact,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return AllCategory();
                              },));
                            },
                            icon: Icon(Icons.category),
                            iconSize: 18,
                            tooltip: '범주 생성',
                            hoverColor: Colors.orange,
                            focusColor: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 중단: 입력창 (제목/내용)
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                TextFormField(
                                  cursorColor: Colors.orange,
                                  cursorWidth: 3,
                                  // 커서 노출 여부
                                  showCursor: true,
                                  initialValue: widget.currentContact.title,
                                  onChanged: (value) {
                                    setState(() {
                                      title = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.clear),
                                    labelText: '제목',
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return '한 글자 이상 입력해 주세요';
                                    }
                                    else if (value.trimLeft() != value) {
                                      return '앞에 공백을 제거해 주세요';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 25),
                                TextFormField(
                                  cursorColor: Colors.orange,
                                  cursorWidth: 3,
                                  // 커서 노출 여부
                                  showCursor: true,
                                  initialValue: widget.currentContact.mainText,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 40,
                                  onChanged: (value) {
                                    setState(() {
                                      mainText = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: '내용을 입력해 주세요',
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 하단: 저장 및 취소
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            label: Text('저장'),
                            icon: Icon(Icons.check),
                            onPressed: () {
                              final formKeyState = _formKey.currentState!;
                              // note: 범주 변경하고, 제목이나, 내용 변경하지 않으면 변경된 범주가 저장되지 않는다
                              if(widget.currentContact.title == title && widget.currentContact.mainText == mainText && widget.currentContact.selectedCategory != _dropdownValue) {
                                HiveHelperMemo().updateMemo(_dropdownValue!, mainText!, index: widget.index, title: title, createdAt: time);
                                Navigator.of(context).pop();
                              }
                              // note: 이전 입력 값과, 변경한 값(title, mainText)이 둘 다 같은 경우, 변경 사항이 없으므로 저장 눌러도 그대로 저장되도록 한다.
                              else if(widget.currentContact.title == title && widget.currentContact.mainText == mainText) {
                                Navigator.of(context).pop();
                              }
                              // note: 위 해당 사항 없으면 validation 검사하고 저장한다
                              else if (formKeyState.validate()) {
                                formKeyState.save();
                                HiveHelperMemo().updateMemo(_dropdownValue!, mainText!, index: widget.index, title: title, createdAt: time);
                                Navigator.of(context).pop();
                              }
                            },
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
              );
            },
          ),
        ),
      ),
    );
  }
}
