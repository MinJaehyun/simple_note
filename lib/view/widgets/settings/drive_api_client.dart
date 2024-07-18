// import 'dart:io' as io;
// import 'package:flutter/material.dart';
// import 'package:googleapis/drive/v3.dart' as drive;
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// const yourClientId = '731330359183-rsr2drhcapen3fh2lbiberrrd2f8ccua.apps.googleusercontent.com';
// const yourClientSecret = 'FF:36:23:22:6E:E2:9C:75:6B:82:7D:85:E1:84:8A:16:AB:09:9F:D9';
//
// // GoogleSignIn 객체 초기화
// final GoogleSignIn googleSignIn = GoogleSignIn(
//   scopes: [drive.DriveApi.driveFileScope],
// );
//
// class DriveApiClient {
//   // static const _scopes = [drive.DriveApi.driveFileScope];
//
//   // static Future<AutoRefreshingAuthClient> getClient() async {
//   //   var clientId = ClientId(yourClientId, yourClientSecret);
//   //   return await clientViaUserConsent(clientId, _scopes, (url) {
//   //     // 사용자가 이 URL을 방문하여 승인해야 합니다.
//   //     print('Please go to the following URL and grant access:');
//   //     print('  => $url');
//   //     print('');
//   //   });
//   // }
//   //
//   // static Future<void> uploadFile() async {
//   //   var client = await getClient();
//   //   var driveApi = drive.DriveApi(client);
//   //
//   //   var fileToUpload = io.File('/path/to/your/file.txt');
//   //   var media = drive.Media(fileToUpload.openRead(), fileToUpload.lengthSync());
//   //   var driveFile = drive.File()..name = basename(fileToUpload.path);
//   //
//   //   await driveApi.files.create(driveFile, uploadMedia: media);
//   //   print('File uploaded successfully.');
//   // }
//
//   Future<drive.DriveApi?> getDriveApi(BuildContext context) async {
//     final googleUser = await googleSignIn.signIn();
//     final headers = await googleUser?.authHeaders;
//     if (headers == null) {
//       await showMessage(context, "Sign-in first", "Error");
//       return null;
//     }
//
//     final client = GoogleAuthClient(headers);
//     final driveApi = drive.DriveApi(client);
//     return driveApi;
//   }
//
//   // showMessage 메서드 정의
//   static Future<void> showMessage(BuildContext context, String message, String title) async {
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> uploadToHidden() async {
//     try {
//       final driveApi = await getDriveApi(context);
//       if (driveApi == null) {
//         return;
//       }
//       // Not allow a user to do something else
//       showGeneralDialog(
//         context: context,
//         barrierDismissible: false,
//         transitionDuration: Duration(seconds: 2),
//         barrierColor: Colors.black.withOpacity(0.5),
//         pageBuilder: (context, animation, secondaryAnimation) => Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } finally {
//     // Remove a dialog
//     Navigator.pop(context);
//     }
//   }
//
// }
//
// class GoogleAuthClient extends http.BaseClient {
//   final Map<String, String> _headers;
//   final _client = new http.Client();
//
//   GoogleAuthClient(this._headers);
//
//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     request.headers.addAll(_headers);
//     return _client.send(request);
//   }
// }