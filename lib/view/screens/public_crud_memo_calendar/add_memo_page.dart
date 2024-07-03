import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/category_controller.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/helper/banner_ad_widget.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/view/widgets/category/add_category_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddMemoPage extends StatefulWidget {
  const AddMemoPage({super.key});

  @override
  State<AddMemoPage> createState() => _AddMemoPageState();
}

class _AddMemoPageState extends State<AddMemoPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final memoController = Get.find<MemoController>();
  final categoryController = Get.find<CategoryController>();
  final settingsController = Get.find<SettingsController>();

  DateTime time = DateTime.now();
  String title = '';
  String mainText = '';
  late String _dropdownValue;
  late bool _isFavorite = false;
  late bool _isCheckedTodo = false;
  bool showScrollToTopButton = false; // #

  File? pickedImage;

  @override
  void initState() {
    super.initState();
    _dropdownValue = '미분류';
    _scrollController.addListener(_scrollListener); // #
  }

  Future<void> _pickedImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final XFile? pickedImageFile = await imagePicker.pickImage(
      source: source,
      imageQuality: 50,
      maxHeight: 150,
    );

    if (pickedImageFile != null) {
      setState(() {
        // 상태를 업데이트하여 이미지를 즉시 화면에 반영
        pickedImage = File(pickedImageFile.path);
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >= 200 && !showScrollToTopButton) {
      setState(() {
        showScrollToTopButton = true;
      });
    } else if (_scrollController.offset < 200 && showScrollToTopButton) {
      setState(() {
        showScrollToTopButton = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Obx(
            () => Stack(
              children: [
                Column(
                  children: [
                    // note: 상단: 시간 및 범주 메뉴
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 80,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                FormatDate().formatDefaultDateKor(DateTime.now()),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
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

                    // 중단: 입력창 (제목/내용)
                    // 스크롤러 적용을 위한 설정
                    NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) => true,
                      child: Expanded(
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                children: [
                                  // 제목
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
                                        labelText: '제목',
                                        hintText: '제목을 입력해 주세요',
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return '반드시 한 글자 이상 입력해 주세요(Please be sure to enter a title)';
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
                                  // note: 이미지 추가 시, 제목과 내용 사이에 이미지 위치한다
                                  if (pickedImage != null)
                                    GestureDetector(
                                      onTap: () {
                                        // 삭제할 건지? dialog 띄우고 삭제 누르면 삭제하기(pickedImage = null)
                                        Get.dialog(
                                          AlertDialog(
                                            title: Text('이미지를 제거 하시겠습니까?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    pickedImage = null;
                                                    Get.back();
                                                  });
                                                },
                                                child: const Text('제거'),
                                              ),
                                              TextButton(
                                                onPressed: Get.back,
                                                child: const Text('닫기'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Image.file(
                                          pickedImage!,
                                          width: 300,
                                          height: 300,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                  // note: 이미지 있는 경우와 없는 경우의 textformfield 설정
                                  if (pickedImage == null)
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: '대표 이미지를 넣으려면 하단 이미지 버튼을 클릭',
                                        labelStyle: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                        enabled: false,
                                        border: const OutlineInputBorder(),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ),

                                  // 내용
                                  const SizedBox(height: 20),
                                  CustomPaint(
                                    painter: GridPainter(),
                                    child: TextFormField(
                                      maxLength: 5000,
                                      cursorColor: Colors.orange,
                                      cursorWidth: 3,
                                      showCursor: true,
                                      initialValue: "",
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 100,
                                      onChanged: (value) {
                                        mainText = value;
                                      },
                                      decoration: InputDecoration(
                                        labelText: '내용',
                                        hintText: '내용을 입력해 주세요',
                                        border: const OutlineInputBorder(),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.orange,
                                          ),
                                        ),
                                        // note: 상단에 '내용' 위치 시킴
                                        alignLabelWithHint: true,
                                      ),
                                      style: TextStyle(
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
                    // 배너
                    const BannerAdWidget(),
                    // 하단: 할일체크 및 즐겨찾기 및 저장 및 취소
                    Row(
                      children: [
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
                        TextButton(
                          child: _isFavorite == false ? const Icon(Icons.star_border_sharp, color: null) : const Icon(Icons.star, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          },
                        ),
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
                                  imagePath: pickedImage,
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
                          title: Text('이미지를 생성하거나 삭제 해주세요'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _pickedImage(ImageSource.gallery);
                                Get.back();
                              },
                              child: const Text('사진 가져오기'),
                            ),
                            TextButton(
                              onPressed: () {
                                _pickedImage(ImageSource.camera);
                                Get.back();
                              },
                              child: const Text('사진 찍기'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  pickedImage = null;
                                  Get.back();
                                });
                              },
                              child: const Text('제거'),
                            ),
                          ],
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
                    icon: showScrollToTopButton ? const Icon(Icons.arrow_upward) : const Icon(Icons.arrow_downward),
                    onPressed: () {
                      showScrollToTopButton ? _scrollToTop() : _scrollToDown();
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

  void _scrollToTop() {
    _scrollController.animateTo(0.0, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  void _scrollToDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

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
          // todo: 아래 test 고민하기 ???
          child: Text(value.categories!.isEmpty ? 'test' : value.categories!),
        );
      }).toList(),
      iconSize: 35,
    );
  }
}
