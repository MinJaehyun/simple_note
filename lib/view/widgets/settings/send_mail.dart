import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';

class SendMail extends StatelessWidget {
  const SendMail({super.key});

  Future<void> sendMail() async {
    final Email email = Email(
      body: '',
      subject: '',
      recipients: ['krism2891@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      Get.snackbar('', '소중한 의견 감사합니다:)');
    } catch (error) {
      String title = "Gmail 앱에 등록된 계정만 문의를 하실 수 있습니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\nkrism2891@gmail.com";
      String message = "";
      Get.snackbar(title, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.mail),
      title: const Text('의견 보내기'),
      onTap: () async {
        sendMail();
      },
    );
  }
}
