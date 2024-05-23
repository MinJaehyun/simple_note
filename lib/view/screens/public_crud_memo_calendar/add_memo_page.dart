import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/hive_helper_memo.dart';
import 'package:simple_note/controller/hive_helper_category.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/view/screens/category/category_page.dart';

class AddMemoPage extends StatefulWidget {
  const AddMemoPage({super.key});

  @override
  State<AddMemoPage> createState() => _AddMemoPageState();
}

class _AddMemoPageState extends State<AddMemoPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime time = DateTime.now();
  String title = '';
  String mainText = '';
  late String _dropdownValue;
  bool _showScrollToTopButton = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _dropdownValue = '미분류';
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 200 && !_showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = true;
      });
    } else if (_scrollController.offset < 200 && _showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = false;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    void dropdownCallback(String? selectedValue) {
      if (selectedValue != null) {
        setState(() {
          _dropdownValue = selectedValue;
        });
      }
    }

    // todo: dropdownButtonWidget는 update_memo 와 동일한 구조 사용
    DropdownButton<String> dropdownButtonWidget(Box<CategoryModel> box) {
      return DropdownButton(
        style: const TextStyle(color: Colors.green),
        underline: Container(height: 2, color: Colors.green[100]),
        value: null,
        hint: Text(_dropdownValue),
        onChanged: dropdownCallback,
        items: box.values.toList().map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value.categories,
            // todo: 아래 test 고민하기
            child: Text(value.categories!.isEmpty ? 'test' : value.categories!),
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
              // if (box.values.isEmpty) return Center(child: Text('test add memo'));

              return Stack(
                children: [
                  Column(
                    children: [
                      // 상단: 시간 및 범주 메뉴
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              // 시간
                              Expanded(
                                child: Text(
                                  FormatDate().formatDefaultDateKor(DateTime.now()),
                                  style: const TextStyle(fontSize: 18),
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
                                child: dropdownButtonWidget(box),
                              ),
                              // 범주 생성 버튼
                              IconButton(
                                // IconButton 간격 줄이기 위해 패딩과 마진값을 제거
                                visualDensity: const VisualDensity(horizontal: -4),
                                // visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  // todo: 범주 생성 팝업 띄우려면? 위젯!
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return const CategoryPage();
                                    },
                                  ));
                                },
                                icon: const Icon(Icons.category),
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
                      // 스크롤러 적용을 위한 설정: NotificationListener<ScrollNotification>
                      NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          // print(scrollNotification.metrics.pixels); // 0 / 484.1428571428571
                          return true;
                        },
                        child: Expanded(
                          child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      cursorColor: Colors.orange,
                                      cursorWidth: 3,
                                      // 커서 노출 여부
                                      showCursor: true,
                                      initialValue: "",
                                      onChanged: (value) {
                                        setState(() {
                                          title = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
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
                                        // print('test' + '   asdf   '.trimLeft() + 'E');  //testasdf   E /String /앞 공백 제거
                                        else if (value.trimLeft() != value) {
                                          return '앞에 공백을 제거해 주세요';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      cursorColor: Colors.orange,
                                      cursorWidth: 3,
                                      // 커서 노출 여부
                                      showCursor: true,
                                      initialValue: "",
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 100,
                                      onChanged: (value) {
                                        setState(() {
                                          mainText = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
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
                                label: const Text('저장'),
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  final formKeyState = _formKey.currentState!;
                                  if (formKeyState.validate()) {
                                    formKeyState.save();
                                    HiveHelperMemo().addMemo(createdAt: time, title: title, mainText: mainText, selectedCategory: _dropdownValue);
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton.icon(
                                label: const Text('취소'),
                                icon: const Icon(Icons.close),
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('변경 사항을 취소 하시겠습니까?'),
                                    actions: <Widget>[
                                      // 예: 누르면, 메모장을 빠져나간다.
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('변경을 취소'),
                                      ),
                                      // 아니오: 누르면, 메모장으로 빠져나간다.
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('메모장 돌아가기'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // 상단, 하단 이동하는 하단 우측 버튼
                  Positioned(
                    bottom: 70,
                    right: 20,
                    child: IconButton.filledTonal(
                      hoverColor: Colors.orange,
                      focusColor: Colors.orangeAccent,
                      icon: _showScrollToTopButton ? const Icon(Icons.arrow_upward) : const Icon(Icons.arrow_downward),
                      onPressed: () {
                        _showScrollToTopButton ? _scrollToTop() : _scrollToDown();
                      },
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
