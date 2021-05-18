import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapxchange/models/app_user.dart';

const U_ID = "user_id";
const U_NAME = "user_name";
const U_DETAILS = "user_details";

class PrefsAppUser {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // user id
  void setUID({required String userId}) async {
    (await _prefs).setString(U_ID, userId);
  }

  Future<String> getUID() async {
    return (await _prefs).getString(U_ID)!;
  }

  // user name
  void setUName({required String userName}) async {
    (await _prefs).setString(U_NAME, userName);
  }

  Future<String> getUName() async {
    return (await _prefs).getString(U_NAME)!;
  }

  // all the user details
  void setUDetails({required AppUser appUser}) async {
    var user = appUser.toMap();
    var uDetails = jsonEncode(user);
    (await _prefs).setString(U_DETAILS, uDetails);
  }

  Future<AppUser> getUDetails() async {
    var appUser = (await _prefs).getString(U_DETAILS);
    return AppUser.fromMap(jsonDecode(appUser!));
  }

  // logout
  Future<bool> signOut() async {
    return (await _prefs).clear();
  }
}
