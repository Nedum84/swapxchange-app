import 'package:get/get.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/user_prefs.dart';

class UserController extends GetxController {
  static UserController to = Get.find();
  AppUser? _appUser;

  AppUser? get user => _appUser;

  void setUser(AppUser appUser) {
    _appUser = appUser;

    UserPrefs().setUID(userId: _appUser!.userId!); //Saving user details to share prefs
    update();
  }

  void refreshUser() async {
    AuthRepo.refreshMe(
      onSuccess: (appUser) {
        setUser(appUser!);
      },
      onError: (er) {
        AlertUtils.toast('$er');
      },
    );
  }
}
