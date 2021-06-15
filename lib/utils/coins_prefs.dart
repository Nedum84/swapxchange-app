import 'package:shared_preferences/shared_preferences.dart';

const LAST_DAILY_CREDIT_DAY = "last_credit_day";

class PrefsAppUser {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Last day daily credit (coins) was given to user
  void setLastDayCredit({required String day}) async {
    (await _prefs).setString(LAST_DAILY_CREDIT_DAY, day);
  }

  Future<String?> getLastDayCredit() async {
    return (await _prefs).getString(LAST_DAILY_CREDIT_DAY);
  }
}
