import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/helper/banner_ad_widget.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/category.dart';
import 'package:simple_note/model/memo.dart';
import 'package:simple_note/repository/local_data_source/category_repository.dart';
import 'package:simple_note/view/widgets/category/add_category_widget.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:image_picker/image_picker.dart';

class UpdateMemoPage extends StatefulWidget {
  const UpdateMemoPage({required this.index, required this.sortedCard, super.key});

  final int index;
  final MemoModel sortedCard;

  @override
  State<UpdateMemoPage> createState() => _UpdateMemoPageState();
}

class _UpdateMemoPageState extends State<UpdateMemoPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final settingsController = Get.find<SettingsController>();
  final memoController = Get.find<MemoController>();

  late DateTime time;
  late String title;
  late String? mainText;
  late String? _dropdownValue;
  late bool _isFavorite;
  late bool _isCheckedTodo;
  bool _showScrollToTopButton = false;

  File? pickedImage;
  bool _isImageVisible = true;

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
    // pickedImage = File(widget.sortedCard.imagePath);
    // pickedImage = widget.sortedCard.imagePath != null ? File(widget.sortedCard.imagePath!) : null;
    pickedImage = widget.sortedCard.imagePath != null ? File(widget.sortedCard.imagePath!) : null;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickedImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImageFile = await imagePicker.pickImage(
      source: source,
      // 이미지 퀄리티 및 해상도 조절
      maxWidth: 1920, // 최대 너비 설정
      maxHeight: 1080, // 최대 높이 설정
      imageQuality: 100, // 이미지 품질을 최대로 설정
    );

    if (pickedImageFile != null) {
      setState(() {
        pickedImage = File(pickedImageFile.path);
        _updateMemo(imagePath: pickedImage);
      });
    }
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

  // *** note: 두 상태가 변경될 때 memoController.updateCtr 메서드를 함께 호출하여, 동시에 상태를 업데이트하도록 할 수 있습니다. 이를 위해서는 _updateMemo 메서드를 개선함 ***
  void _updateMemo({
    final bool? isFavoriteMemo,
    final bool? isCheckedTodo,
    final File? imagePath,
  }) {
    memoController.updateCtr(
      index: widget.index,
      createdAt: time,
      title: title,
      mainText: mainText,
      selectedCategory: _dropdownValue,
      isFavoriteMemo: isFavoriteMemo ?? _isFavorite,
      isCheckedTodo: isCheckedTodo ?? _isCheckedTodo,
      // imagePath: imagePath,
      // imagePath: File(widget.sortedCard.imagePath!),
      // imagePath: widget.sortedCard.imagePath != null ? File(widget.sortedCard.imagePath!) : null,
      // imagePath: imagePath,
      // imagePath: imagePath ?? pickedImage,
      // note: fix: 아.. 위에 지우지 말 것!
      imagePath: pickedImage != null ? File(imagePath!.path) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          Expanded(
                            child: Text(FormatDate().formatDotDateTimeKor(widget.sortedCard.createdAt), style: const TextStyle(fontSize: 20)),
                          ),
                          Expanded(
                            // note: 이하 box 사용중이므로 controller로 변경은 일단 대기
                            child: ValueListenableBuilder(
                              valueListenable: Hive.box<CategoryModel>(CategoryBox).listenable(),
                              builder: (context, Box<CategoryModel> box, _) {
                                return TextButton(
                                  // TextButton 간격 줄이기 위해 패딩과 마진값을 제거
                                  style: TextButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: null,
                                  child: dropdownButtonWidget(box),
                                );
                              },
                            ),
                          ),
                          IconButton(
                            // IconButton 간격 줄이기 위해 패딩과 마진값을 제거
                            // visualDensity: VisualDensity.compact,
                            visualDensity: const VisualDensity(horizontal: -4),
                            onPressed: () => showAddPopupDialog(context),
                            icon: const Icon(Icons.category),
                            iconSize: 32,
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
                    onNotification: (scrollNotification) => true,
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
                                        return '반드시 제목을 입력해 주세요(Please be sure to enter a title)';
                                      } else if (value.trimLeft() != value) {
                                        return '앞에 공백을 제거해 주세요';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),
                                // note: 이미지 없는 경우
                                // todo: 추후 refectoring: add_memo 182~ 라인부터 동일하다.
                                if (pickedImage == null)
                                  Container(
                                    height: 60.0,
                                    // TextFormField의 높이와 일치하도록 설정
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey, // 테두리 색상
                                        width: 1.0, // 테두리 두께
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4.0), // 테두리 모서리 둥글기
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Center(child: Text('대표 이미지 확대 또는 축소')),
                                    ),
                                  ),

                                // note: 이미지 추가 시, 제목과 내용 사이에 이미지 위치한다
                                // note: 이미지 있는 경우이며 확대 상태
                                if (pickedImage != null && _isImageVisible == true)
                                  // if (pickedImage != null)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isImageVisible = !_isImageVisible;
                                      });
                                    },
                                    child: AnimatedOpacity(
                                      // 이미지가 있고, 클릭한 상태가 있다면
                                      opacity: 1.0,
                                      duration: Duration(seconds: 1),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey, width: 2.0),
                                        ),
                                        child: Image.file(
                                          pickedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),

                                // note: 이미지 있는 경우이며 축소 상태
                                if (pickedImage != null && _isImageVisible == false)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isImageVisible = !_isImageVisible;
                                      });
                                    },
                                    child: AnimatedOpacity(
                                      // 이미지가 있고, 클릭한 상태가 있다면
                                      opacity: 1.0,
                                      duration: Duration(seconds: 1),
                                      child: Container(
                                        // TextFormField의 높이
                                        height: 60.0,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey, width: 1.0),
                                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Center(child: Text('이미지 축소 상태 입니다. 클릭하여 확대하기.')),
                                        ),
                                      ),
                                    ),
                                  ),

                                // note: 내용
                                const SizedBox(height: 20),
                                CustomPaint(
                                  painter: GridPainter(),
                                  child: TextFormField(
                                    maxLength: 5000,
                                    cursorColor: Colors.orange,
                                    cursorWidth: 3,
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
                                      color: settingsController.isThemeMode.isFalse ? Colors.white : Colors.black,
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

                  // 배너
                  const BannerAdWidget(),
                  // 하단: 즐찾 및 저장 및 취소
                  Row(
                    children: [
                      IconButton(
                        // 아이콘 버튼 내부의 패딩 제거
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        // 기본 제약조건 제거
                        visualDensity: const VisualDensity(horizontal: -4.0),
                        icon: _isCheckedTodo == false ? const Icon(Icons.check_box_outline_blank) : const Icon(Icons.check_box, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _isCheckedTodo = !_isCheckedTodo;
                          });
                          _updateMemo(isCheckedTodo: _isCheckedTodo, imagePath: pickedImage);
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: _isFavorite == false ? const Icon(Icons.star_border_sharp, color: null) : const Icon(Icons.star, color: Colors.red),
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
                              setState(() {
                                formKeyState.save();
                                _updateMemo(imagePath: pickedImage);
                              });
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
              // note: 이미지 등록 버튼
              Positioned(
                bottom: 100,
                right: 70,
                child: IconButton.filledTonal(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: Text('이미지 변경 및 삭제 기능'),
                        content: Row(
                          children: [
                            TextButton(
                              child: const Text('변경'),
                              onPressed: () {
                                _pickedImage(ImageSource.gallery);
                                Get.back();
                              },
                            ),
                            TextButton(
                              child: const Text('촬영'),
                              onPressed: () {
                                _pickedImage(ImageSource.camera);
                                Get.back();
                              },
                            ),
                            TextButton(
                              child: const Text('제거'),
                              onPressed: () {
                                setState(() {
                                  pickedImage = null;
                                  _updateMemo(imagePath: null);
                                  Get.back();
                                });
                              },
                            ),
                            TextButton(
                              child: const Text('닫기'),
                              onPressed: Get.back,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.image),
                ),
              ),
              // note: 상단, 하단 이동하는 하단 우측 버튼
              Positioned(
                bottom: 100,
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

  // ui에 나타낼 _dropdownValue 변경함
  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
      // fix: _updateMemo();
      // 현재의 pickedImage를 전달
      _updateMemo(imagePath: pickedImage);
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
}
