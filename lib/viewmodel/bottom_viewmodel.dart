import 'package:get/get.dart';

class BottomViewModel extends GetxController {
  int _selectedBottomIndex = 0;

  int get selectedBottomIndex => _selectedBottomIndex;

  set selectedBottomIndex(int value) {
    _selectedBottomIndex = value;
    update();
  }

  bool _isDrawerOpen = false;

  bool get isDrawerOpen => _isDrawerOpen;

  void setIsDrawerOpen() {
    _isDrawerOpen = !_isDrawerOpen;
    update();
  }
}

class DrawerModel {
  String imageicon;
  String title;
  DrawerModel({required this.title, required this.imageicon});
}
