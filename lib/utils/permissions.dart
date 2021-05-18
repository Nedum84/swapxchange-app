import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission = await Permission.camera.status;
    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.camera].request();

      return permissionStatus[Permission.camera] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> _getMicrophonePermission() async {
    PermissionStatus permission = await Permission.microphone.status;
    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.microphone].request();
      return permissionStatus[Permission.microphone] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } else if (cameraPermissionStatus == PermissionStatus.restricted &&
        microphonePermissionStatus == PermissionStatus.restricted) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  //file permissions
  static Future<PermissionStatus> _getFileStoragePermission() async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.storage, Permission.photos].request();
      return permissionStatus[Permission.storage] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  static Future<bool> filePermissionsGranted() async {
    PermissionStatus filePermissionStatus = await _getFileStoragePermission();

    if (filePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.storage.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this app. The only way to change the permission's status now is to let the user manually enable it in the system settings.
        openAppSettings();
      }
      print('Permission is Needed to proceed');
      return false;
    }
  }

  //location permissions
  static Future<PermissionStatus> _getLocationPermission() async {
    PermissionStatus permission = await Permission.location.status;
    if (permission != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.location, Permission.locationAlways].request();
      return permissionStatus[Permission.location] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  static Future<bool> locationPermission() async {
    PermissionStatus locationPermissionStatus = await _getLocationPermission();

    if (locationPermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.location.isPermanentlyDenied) {
        openAppSettings();
      }
      print('Permission is Needed to proceed');
      return false;
    }
  }

  static Future<bool> isLocationPermissionGranted() async {
    PermissionStatus permission = await Permission.location.status;
    return permission == PermissionStatus.granted;
  }
}
