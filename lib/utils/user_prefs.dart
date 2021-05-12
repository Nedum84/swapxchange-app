import 'package:get_storage/get_storage.dart';

class UserPrefs {
  static final pref = GetStorage('UserPref');

  //Keys
  static String USER_ID = "USER_ID";

  static setUserId({String newId = "23"}) async {
    var userId = await pref.write(USER_ID, newId);
    return userId;
  }

  static String get getUserId => pref.read(USER_ID) ?? "NULL";

  static clear() {
    pref.erase();
  }
}
