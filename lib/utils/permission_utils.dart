import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> requestAndGetStatus(Permission permission) async {
  await permission.request();
  return await permission.status;
}

Future<bool> requestPermission(Permission permission) async {
  PermissionStatus result = await requestAndGetStatus(permission);
  if (result.isDenied) {
    result = await requestAndGetStatus(permission);
    if (result.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings. This is only for Android < API 30
      openAppSettings();
    }
  }
  // This covers all cases as permission_handler >= 6.0.0 only returns granted or denied for permission status
  return result.isGranted;
}

Future<bool> requestContactsPermission() async {
  bool contactsPermission = await requestPermission(Permission.contacts);
  return contactsPermission;
}
