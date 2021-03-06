import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/user_prefs.dart';

class UserController extends GetxController {
  static UserController to = Get.find();
  AppUser? _appUser;
  List<AppUser> users = [];

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

  Future<AppUser?> getUser({var userId}) async {
    AppUser? user;
    user = users.firstWhereOrNull((element) => element.userId == userId || element.uid == userId);
    if (user == null) {
      user = await AuthRepo.findByUserId(userId: userId);
      //Update the users repo
      if (user != null) {
        updateUsers(user);
      }
    }

    if (user != null) {
      return user;
    }
  }

  void updateUsers(AppUser user) {
    users.add(user);
    // update();
  }
}
