import 'package:get/get.dart';

class ChatViewModel extends GetxController {
  String _localFile = '';

  String get localFile => _localFile;

  set setLocalFile(String value) {
    _localFile = value;
  }
}
