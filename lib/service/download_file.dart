
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';

import '../common/commonWidget/snackbar.dart';
import '../utils/color_utils.dart';
import '../utils/const_utils.dart';
import '../utils/variable_utils.dart';
import 'get_storage_permission.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> firebaseDownloadFile(
  String url,
  int microsecondsSinceEpoch,
) async {
  if (url == '') {
    showSnackBar(
        message: VariableUtils.fileNotExists, snackColor: ColorUtils.red);
    return;
  }

  showSnackBar(message: VariableUtils.fileDownloading);
  final storagePermissionStatus = await getStoragePermission();
  if (!storagePermissionStatus) {
    showSnackBar(
        message: VariableUtils.enableStoragePermission,
        snackColor: ColorUtils.red);
    return;
  }
  try {
    Dio dio = Dio();
    String savePath = (await getDownloadPath()) ?? '';
    if (savePath == "") {
      showSnackBar(
          message: VariableUtils.fileDownloadFailed,
          snackColor: ColorUtils.red);
      return;
    }

    savePath = savePath + '/' + ConstUtils.kGetFileName(url);

    final response = await dio.download(url, savePath);

    if (response.statusCode == 200) {
      showSnackBar(
        message: VariableUtils.fileDownloadSuccess,
      );
      openFile(savePath, url);
    } else {
      showSnackBar(
          message: VariableUtils.fileDownloadFailed,
          snackColor: ColorUtils.red);
    }
  } on Exception catch (e) {
    showSnackBar(
        message: VariableUtils.fileDownloadFailed, snackColor: ColorUtils.red);
    if (kDebugMode) {
      print('ERROR :=>$e');
    }
  }
}

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getTemporaryDirectory();
    }
  } catch (err) {
    showSnackBar(message: 'Something went to wrong try again later .....');
  }
  return directory?.path;
}

Future<void> openFile(String path, String link) async {
  await OpenFile.open(
    path,
  ).then((value) {
    if (value.type != ResultType.done) {
      launchUrl(Uri.parse(link));
    }
  }).catchError((e) {
    log('ERROR :=>$e');
  });
}
