import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/category_controller.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/helper/banner_ad_widget.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/view/widgets/category/add_category_widget.dart';

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
  late bool _isFavorite = false;
  late bool _isCheckedTodo = false;
  final settingsController = Get.find<SettingsController>();
  final memoController = Get.find<MemoController>();
  final categoryController = Get.find<CategoryController>();

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
    DropdownButton<String> dropdownButtonWidget(controllerCategoryList) {
      return DropdownButton(
        style: const TextStyle(color: Colors.green),
        underline: Container(height: 2, color: Colors.green[100]),
        value: null,
        hint: Text(_dropdownValue),
        onChanged: dropdownCallback,
        items: controllerCategoryList.toList().map<DropdownMenuItem<String>>((value) {
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
          body: Obx(
            () => Stack(
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
                              child: dropdownButtonWidget(categoryController.categoryList),
                            ),
                            // 범주 생성 버튼
                            IconButton(
                              // IconButton 간격 줄이기 위해 패딩과 마진값을 제거
                              // visualDensity: VisualDensity.compact,
                              visualDensity: const VisualDensity(horizontal: -4),
                              onPressed: () => showAddPopupDialog(context),
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
                                  CustomPaint(
                                    painter: GridPainter(),
                                    child: TextFormField(
                                      cursorColor: Colors.orange,
                                      cursorWidth: 3,
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
                                  ),
                                  const SizedBox(height: 20),
                                  CustomPaint(
                                    painter: GridPainter(),
                                    child: TextFormField(
                                      maxLength: 5000,
                                      cursorColor: Colors.orange,
                                      cursorWidth: 3,
                                      // 커서 노출 여부
                                      showCursor: true,
                                      initialValue: "",
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 100,
                                      onChanged: (value) {
                                        mainText = value;
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
                                      style: TextStyle(
                                        color: settingsController.isThemeMode.isTrue ? Colors.white : Colors.black,
                                        fontSize: settingsController.fontSizeSlider.toDouble(),
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
                    BannerAdWidget(),
                    // 하단: 할일체크 및 즐겨찾기 및 저장 및 취소
                    Row(
                      children: [
                        // 할일체크
                        TextButton(
                          child: _isCheckedTodo == false
                              ? const Icon(Icons.check_box_outline_blank, color: null)
                              : const Icon(Icons.check_box, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _isCheckedTodo = !_isCheckedTodo;
                            });
                          },
                        ),
                        // 즐겨찾기
                        TextButton(
                          child: _isFavorite == false ? const Icon(Icons.star_border_sharp, color: null) : const Icon(Icons.star, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          },
                        ),
                        // 저장 및 취소
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('저장'),
                            onPressed: () {
                              final formKeyState = _formKey.currentState!;
                              if (formKeyState.validate()) {
                                formKeyState.save();
                                memoController.addCtr(
                                  createdAt: time,
                                  title: title,
                                  mainText: mainText,
                                  selectedCategory: _dropdownValue,
                                  isFavoriteMemo: _isFavorite,
                                  isCheckedTodo: _isCheckedTodo,
                                );
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('취소'),
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('변경 사항을 취소 하시겠습니까?'),
                                actions: <Widget>[
                                  // 예: 누르면, 메모장을 빠져나간다.
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 여기서 팝 처리하고 대화 상자를 닫습니다.
                                      Navigator.of(context).pop(); // 이전 페이지로 돌아갑니다.
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
            ),
          ),
        ),
      ),
    );
  }
}
