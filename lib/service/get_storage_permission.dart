import 'package:permission_handler/permission_handler.dart';

Future<bool> getStoragePermission() async {
  PermissionStatus permissionStatus = await Permission.storage.status;
  if (permissionStatus != PermissionStatus.granted) {
    permissionStatus = await Permission.storage.request();
    if (permissionStatus != PermissionStatus.granted) {
      permissionStatus = await Permission.storage.request();
      if (permissionStatus != PermissionStatus.granted) {
        permissionStatus = await Permission.storage.request();
      }
    }
  }
  if (permissionStatus == PermissionStatus.granted) {
    return true;
  }
  return false;
}
