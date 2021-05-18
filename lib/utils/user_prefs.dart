import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/tokens.dart';

class UserPrefs {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//Keys
  static String USER_ID = "UserId";
  static String USER_DETAILS = "UserDetails";
  static String USER_TOKENS = "UserTokens";

  // user id
  void setUID({required String userId}) async {
    // SharedPreferences _prefs = await  SharedPreferences.getInstance();
    (await _prefs).setString(USER_ID, userId);
  }

  Future<String?> getUID() async {
    return (await _prefs).getString(USER_ID);
  }

  // all the user details
  void setUDetails({required AppUser appUser}) async {
    var user = appUser.toMap();
    var uDetails = jsonEncode(user);
    (await _prefs).setString(USER_DETAILS, uDetails);
  }

  Future<AppUser> getUDetails() async {
    var appUser = (await _prefs).getString(USER_DETAILS);
    return AppUser.fromMap(jsonDecode(appUser!));
  }

  // Tokens
  static void setTokens({required Tokens tokens}) async {
    var t = tokens.toMap();
    var tks = jsonEncode(t);
    (await _prefs).setString(USER_TOKENS, tks);
  }

  static Future<Tokens> getTokens() async {
    var tks = (await _prefs).getString(USER_TOKENS);
    return Tokens.fromMap(jsonDecode(tks!));
  }

  // logout
  Future<bool> clear() async {
    return (await _prefs).clear();
  }
}
