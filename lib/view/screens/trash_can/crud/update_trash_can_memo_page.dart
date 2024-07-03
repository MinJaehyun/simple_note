import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_note/controller/category_controller.dart';
import 'package:simple_note/controller/memo_controller.dart';
import 'package:simple_note/controller/settings_controller.dart';
import 'package:simple_note/controller/trash_can_memo_controller.dart';
import 'package:simple_note/helper/banner_ad_widget.dart';
import 'package:simple_note/helper/grid_painter.dart';
import 'package:simple_note/helper/string_util.dart';
import 'package:simple_note/model/trash_can.dart';
import 'package:simple_note/view/widgets/category/add_category_widget.dart';

class UpdateTrashCanMemoPage extends StatefulWidget {
  const UpdateTrashCanMemoPage({required this.index, required this.currentContact, super.key});

  final int index;
  final TrashCanModel currentContact;

  @override
  State<UpdateTrashCanMemoPage> createState() => _UpdateTrashCanMemoPageState();
}

class _UpdateTrashCanMemoPageState extends State<UpdateTrashCanMemoPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  final categoryController = Get.find<CategoryController>();
  final memoController = Get.find<MemoController>();
  final settingsController = Get.find<SettingsController>();
  final trashCanMemoController = Get.find<TrashCanMemoController>();

  late String title;
  late String? mainText;
  late DateTime time;
  late String? _dropdownValue;

  bool _showScrollToTopButton = false;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    title = widget.currentContact.title;
    mainText = widget.currentContact.mainText;
    time = widget.currentContact.createdAt;
    _dropdownValue = widget.currentContact.selectedCategory;
    pickedImage = widget.currentContact.imagePath != null ? File(widget.currentContact.imagePath!) : null;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Obx(
            () {
              if (categoryController.categoryList.isEmpty) return const Center(child: Text('test update memo'));
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
                              Expanded(
                                child: Text(
                                  FormatDate().formatDotDateTimeKor(widget.currentContact.createdAt),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {},
                                child: dropdownButtonWidget(categoryController.categoryList),
                              ),
                              IconButton(
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
                                        initialValue: widget.currentContact.title,
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
                                            return '반드시 한 글자 이상 입력해 주세요(Please be sure to enter a title)';
                                          } else if (value.trimLeft() != value) {
                                            return '앞에 공백을 제거해 주세요';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    const SizedBox(height: 20),
                                    // note: 이미지 추가 시, 제목과 내용 사이에 이미지 위치한다
                                    // if (widget.sortedCard.imagePath != null)
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
                                            // File(widget.sortedCard.imagePath!),
                                            width: 300,
                                            height: 300,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                    // note: 이미지 있는 경우와 없는 경우의 textformfield 설정
                                    // if (widget.sortedCard.imagePath == null)
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

                                    const SizedBox(height: 25),
                                    CustomPaint(
                                      painter: GridPainter(),
                                      child: TextFormField(
                                        maxLength: 5000,
                                        cursorColor: Colors.orange,
                                        cursorWidth: 3,
                                        showCursor: true,
                                        initialValue: widget.currentContact.mainText,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: widget.currentContact.mainText != null ? 100 : null,
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
                      const BannerAdWidget(),
                      // 하단: 저장 및 취소
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: const Text('저장'),
                              onPressed: () {
                                final formKeyState = _formKey.currentState!;
                                // note: 범주 변경하고, 제목이나, 내용 변경하지 않으면 변경된 범주가 저장되지 않는다
                                if (widget.currentContact.title == title &&
                                    widget.currentContact.mainText == mainText &&
                                    widget.currentContact.selectedCategory != _dropdownValue) {
                                  trashCanMemoController.updateCtr(
                                    index: widget.index,
                                    createdAt: time,
                                    title: title,
                                    mainText: mainText!,
                                    selectedCategory: _dropdownValue!,
                                    imagePath: pickedImage,
                                  );
                                  Navigator.of(context).pop();
                                }
                                // note: 이전 입력 값과, 변경한 값(title, mainText)이 둘 다 같은 경우, 변경 사항이 없으므로 저장 눌러도 그대로 저장되도록 한다.
                                else if (widget.currentContact.title == title && widget.currentContact.mainText == mainText) {
                                  Navigator.of(context).pop();
                                }
                                // note: 위 해당 사항 없으면 validation 검사하고 저장한다
                                else if (formKeyState.validate()) {
                                  formKeyState.save();
                                  trashCanMemoController.updateCtr(
                                    index: widget.index,
                                    createdAt: time,
                                    title: title,
                                    mainText: mainText!,
                                    selectedCategory: _dropdownValue!,
                                    isFavoriteMemo: false,
                                  );
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              child: const Text('복원'),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('메모를 복원 하시겠습니까?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('메모를 복원'),
                                      onPressed: () async {
                                        memoController.addCtr(
                                          createdAt: widget.currentContact.createdAt,
                                          title: title,
                                          mainText: mainText,
                                          selectedCategory: _dropdownValue!,
                                          isFavoriteMemo: false,
                                          imagePath: pickedImage,
                                        );
                                        // todo: 정렬된 인덱스 내려주는게 아닌 휴지통의 리스트의 인덱스를 내려줘야 한다?
                                        trashCanMemoController.deleteCtr(index: widget.index);
                                        setState(() {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('메모장 돌아가기'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              child: const Text('취소'),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('변경 사항을 취소 하시겠습니까?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('변경을 취소'),
                                    ),
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
              );
            },
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
    if (selectedValue != null) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  DropdownButton<String> dropdownButtonWidget(categoryList) {
    return DropdownButton(
      style: const TextStyle(color: Colors.green),
      underline: Container(height: 2, color: Colors.green[100]),
      value: null,
      // ui에 나타낼 _dropdownValue 나타냄
      hint: Text('$_dropdownValue'),
      onChanged: dropdownCallback,
      items: categoryList.map<DropdownMenuItem<String>>((value) {
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
