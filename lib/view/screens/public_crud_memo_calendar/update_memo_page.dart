import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/repository/local_data_source/category_repository.dart';
import 'package:simple_note/repository/local_data_source/memo_repository.dart';
import 'package:simple_note/view/widgets/category/add_category_widget.dart';
import 'package:simple_note/controller/memo_controller.dart';

class UpdateMemoPage extends StatefulWidget {
  const UpdateMemoPage({required this.index, required this.sortedCard, super.key});

  final int index;

  // err: final MemoModel currentContact; 처리하면 MemoModel만 사용하게 되므로 TrashCanModel은 사용할 수 없다.. 일단 제거하고 진행하기
  final MemoModel sortedCard;

  @override
  State<UpdateMemoPage> createState() => _UpdateMemoPageState();
}

class _UpdateMemoPageState extends State<UpdateMemoPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime time;
  late String title;
  late String? mainText;
  late String? _dropdownValue;
  late bool _isFavorite = false;
  late bool _isCheckedTodo = false;

  bool _showScrollToTopButton = false;
  final ScrollController _scrollController = ScrollController();
  final settingsController = Get.find<SettingsController>();
  final memoController = Get.find<MemoController>();
  var memoBox = Hive.box<MemoModel>(MemoBox);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    time = widget.sortedCard.createdAt;
    title = widget.sortedCard.title;
    mainText = widget.sortedCard.mainText;
    _dropdownValue = widget.sortedCard.selectedCategory;
    _isFavorite = widget.sortedCard.isFavoriteMemo!;
    _isCheckedTodo = widget.sortedCard.isCheckedTodo!;
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

  // *** note: 두 상태가 변경될 때 memoController.updateCtr 메서드를 함께 호출하여, 동시에 상태를 업데이트하도록 할 수 있습니다. 이를 위해서는 _updateMemo 메서드를 개선함 ***
  void _updateMemo({
    bool? isFavoriteMemo,
    bool? isCheckedTodo,
  }) {
    memoController.updateCtr(
      index: widget.index,
      createdAt: time,
      title: title,
      mainText: mainText,
      selectedCategory: _dropdownValue,
      isFavoriteMemo: isFavoriteMemo ?? _isFavorite,
      isCheckedTodo: isCheckedTodo ?? _isCheckedTodo,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ui에 나타낼 _dropdownValue 변경함
    void dropdownCallback(String? selectedValue) {
      if (selectedValue is String) {
        setState(() {
          _dropdownValue = selectedValue;
        });
        _updateMemo();
      }
    }

    DropdownButton<String> dropdownButtonWidget(Box<CategoryModel> box) {
      return DropdownButton(
        style: const TextStyle(color: Colors.green),
        underline: Container(height: 2, color: Colors.green[100]),
        value: null,
        // ui에 나타낼 _dropdownValue 나타냄
        hint: Text('$_dropdownValue', overflow: TextOverflow.ellipsis),
        onChanged: dropdownCallback,
        items: box.values.toList().map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value.categories,
            // todo: 아래 test3 고민하기
            child: Text(value.categories ?? 'test3'),
          );
        }).toList(),
        iconSize: 35,
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Stack(
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
                              FormatDate().formatDotDateTimeKor(widget.sortedCard.createdAt),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          // 범주
                          Expanded(
                            child: ValueListenableBuilder(
                                valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
                                builder: (context, Box<CategoryModel> box, _) {
                                  // if (box.values.isEmpty) return Center(child: Text('test update memo'));
                                  return TextButton(
                                    // TextButton 간격 줄이기 위해 패딩과 마진값을 제거
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {},
                                    child: dropdownButtonWidget(box),
                                  );
                                }),
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

                  // 중단: 입력창 (제목/내용): 스크롤 버튼 처리하기 위한 설정
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      return true;
                    },
                    child: Expanded(
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
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
                                    // 커서 노출 여부
                                    showCursor: true,
                                    initialValue: widget.sortedCard.title,
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
                                      } else if (value.trimLeft() != value) {
                                        return '앞에 공백을 제거해 주세요';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 25),
                                CustomPaint(
                                  painter: GridPainter(),
                                  child: TextFormField(
                                    maxLength: 5000,
                                    cursorColor: Colors.orange,
                                    cursorWidth: 3,
                                    // 커서 노출 여부
                                    showCursor: true,
                                    initialValue: widget.sortedCard.mainText,
                                    keyboardType: TextInputType.multiline,
                                    // 입력값 무제한 설정하는 방법 - maxLines: null
                                    maxLines: widget.sortedCard.mainText != null ? 100 : null,
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
                                    style: TextStyle(
                                      color: settingsController.isThemeMode.isTrue ? Colors.white : Colors.black,
                                      fontSize: settingsController.fontSizeSlider.toDouble(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 하단: 즐찾 및 저장 및 취소
                  Row(
                    children: [
                      IconButton(
                        // 아이콘 버튼 내부의 패딩 제거
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        // 기본 제약조건 제거
                        visualDensity: VisualDensity(horizontal: -4.0),
                        icon: _isCheckedTodo == false ? const Icon(Icons.check_box_outline_blank) : const Icon(Icons.check_box, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _isCheckedTodo = !_isCheckedTodo;
                          });
                          _updateMemo(isCheckedTodo: _isCheckedTodo);
                        },
                      ),
                      // 즐겨 찾기
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        // visualDensity: VisualDensity(horizontal: -4.0),
                        icon: _isFavorite == false
                            ? const Icon(Icons.star_border_sharp, color: null)
                            : const Icon(
                                Icons.star,
                                color: Colors.red,
                              ),
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          _updateMemo(isFavoriteMemo: _isFavorite);
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          child: const Text('저장'),
                          onPressed: () {
                            final formKeyState = _formKey.currentState!;
                            // note: 이전 입력 값과, 변경한 값(title, mainText)이 둘 다 같은 경우, 변경 사항이 없으므로 저장 눌러도 그대로 저장되도록 한다.
                            if (widget.sortedCard.title == title && widget.sortedCard.mainText == mainText) {
                              Navigator.of(context).pop();
                            }
                            // note: 위 해당 사항 없으면 validation 검사하고 저장한다
                            else if (formKeyState.validate()) {
                              formKeyState.save();
                              _updateMemo();
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
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
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
    );
  }
}
