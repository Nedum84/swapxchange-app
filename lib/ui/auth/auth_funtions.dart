import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/tokens.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/auth/onboarding/grant_permission.dart';
import 'package:swapxchange/ui/auth/phoneauth/enter_name.dart';
import 'package:swapxchange/ui/home/tabs/dashboard/dashboard.dart';
import 'package:swapxchange/utils/user_prefs.dart';

class Auth {
  static AuthRepo _authRepo = AuthRepo();

  static void redirect(Tokens? tokens, AppUser? appUser) {
    if (tokens != null) {
      UserPrefs.setTokens(tokens: tokens);
      if (appUser!.name!.isEmpty) {
        Get.to(() => EnterName(), transition: Transition.leftToRight);
      } else if (appUser.address!.isEmpty) {
        Get.to(() => GrantPermission(), transition: Transition.leftToRight);
      } else {
        Get.offAll(() => Dashboard(), transition: Transition.leftToRight);
      }
    }
  }

  static void authenticateUser(
      {required User user,
      required Function onDone,
      required Function(String error) onError}) async {
    _authRepo.addDataToDb(
      firebaseUser: user,
      onSuccess: (appUser, tokens) {
        onDone();
        Auth.redirect(tokens, appUser);
      },
      onError: (er) {
        onError("$er");
      },
    );
  }
}
