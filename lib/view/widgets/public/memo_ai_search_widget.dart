import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

String apiKey = dotenv.get('API_KEY');
String apiUrl = dotenv.get('API_URL');

// note: 메모장 내부에 검색창
class MemoAiSearchWidget extends StatefulWidget {
  const MemoAiSearchWidget({super.key});

  @override
  State<MemoAiSearchWidget> createState() => _MemoAiSearchWidgetState();
}

class _MemoAiSearchWidgetState extends State<MemoAiSearchWidget> {
  final TextEditingController _textController = TextEditingController();

  String? searchControllerText;
  String? prompt;
  String? generatedText;
  bool isLoading = false;

  // note: 입력값 받아서 Chatgpt에게 질문하고, 답변을 출력하는 함수
  Future<String> generateText(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        // "model": "gpt-3.5-turbo",
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": prompt}
        ],
        "max_tokens": 500,
        "temperature": 0.7,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
      }),
    );

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> newResponse = jsonDecode(utf8.decode(response.bodyBytes));
      return newResponse['choices'][0]['message']['content'];
    } else if (response.statusCode == 429) {
      throw Exception('Quota exceeded. Please check your plan and billing details.');
    } else {
      throw Exception('Failed to load response :(');
    }
  }

  void fetchGeneratedText(String prompt) async {
    setState(() {
      isLoading = true;
    });

    try {
      String result = await generateText(prompt);
      if (mounted) {
        setState(() {
          generatedText = result;
        });
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void searchControllerTextFunc(value) {
    setState(() {
      searchControllerText = value;
    });
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      '복사 완료',
      '내용이 클립 보드에 복사 되었습니다.',
    );
  }

  void onSubmitAi() {
    setState(() {
      prompt = searchControllerText;
    });
    if (prompt != null) {
      fetchGeneratedText(prompt!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 검색창
          SizedBox(
            child: Form(
              child: TextFormField(
                // note: 엔터 이벤트 처리 (textInputAction, onFieldSubmitted)
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value) => onSubmitAi(),
                autofocus: false,
                controller: _textController,
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 1),
                  ),
                  prefixIconColor: Colors.grey,
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => onSubmitAi(),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: Wrap(
                      children: [
                        IconButton(
                          icon: searchControllerText != null ? Icon(Icons.close) : const SizedBox.shrink(),
                          onPressed: () {
                            setState(() {
                              _textController.clear();
                              searchControllerTextFunc(null);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  suffixIconColor: Colors.grey,
                  hintText: 'AI에게 질문 내용을 작성 해주세요',
                  hintStyle: const TextStyle(fontSize: 20),
                ),
                cursorColor: Colors.grey,
                onChanged: (value) {
                  // 변경 전: 자음 한개씩 가져오는게 아닌, 전체를 가져오도록 변경
                  searchControllerTextFunc(value);
                },
              ),
            ),
          ),
          isLoading
              ? CircularProgressIndicator()
              : generatedText == null
                  ? SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        Get.snackbar(
                          '검색 내용을 복사 하시겠습니까?',
                          '',
                          mainButton: TextButton(
                            child: Text('확인'),
                            onPressed: () {
                              copyToClipboard(generatedText!);
                              Get.back();
                            },
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 100,
                              child: SingleChildScrollView(child: Text(generatedText!)),
                            ),
                          ),
                          TextButton(
                            child: Text('복사'),
                            onPressed: () {
                              copyToClipboard(generatedText!);
                            },
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }
}
