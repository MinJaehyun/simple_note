import 'dart:io' as io;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class DriveApiClient {
  static const _scopes = [drive.DriveApi.driveFileScope];

  static Future<AutoRefreshingAuthClient> getClient() async {
    var clientId = ClientId('YOUR_CLIENT_ID', 'YOUR_CLIENT_SECRET');
    return await clientViaUserConsent(clientId, _scopes, (url) {
      // 사용자가 이 URL을 방문하여 승인해야 합니다.
      print('Please go to the following URL and grant access:');
      print('  => $url');
      print('');
    });
  }

  static Future<void> uploadFile() async {
    var client = await getClient();
    var driveApi = drive.DriveApi(client);

    var fileToUpload = io.File('path_to_your_file');
    var media = drive.Media(fileToUpload.openRead(), fileToUpload.lengthSync());
    var driveFile = drive.File()..name = basename(fileToUpload.path);

    await driveApi.files.create(driveFile, uploadMedia: media);
    print('File uploaded successfully.');
  }
}