import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/controllers/coins_controller.dart';
import 'package:swapxchange/controllers/my_product_controller.dart';
import 'package:swapxchange/controllers/product_controller.dart';
import 'package:swapxchange/controllers/saved_product_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/models/tokens.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/repository/repo_category.dart';
import 'package:swapxchange/repository/repo_sub_category.dart';
import 'package:swapxchange/ui/auth/onboarding/grant_permission.dart';
import 'package:swapxchange/ui/auth/phoneauth/enter_name.dart';
import 'package:swapxchange/ui/home/tabs/dashboard/dashboard.dart';
import 'package:swapxchange/utils/user_prefs.dart';

class AuthUtils {
  static AuthRepo _authRepo = AuthRepo();

  static void redirect(Tokens? tokens, AppUser? appUser) {
    if (tokens != null) {
      //--> Set up user on the controller
      UserController.to.setUser(appUser!);
      //-->Save tokens
      UserPrefs.setTokens(tokens: tokens);
      if (appUser.name!.isEmpty) {
        Get.to(() => EnterName());
      } else if (appUser.address!.isEmpty) {
        Get.to(() => GrantPermission());
      } else {
        ProductController.to.fetchAll(reset: true);
        MyProductController.to.fetchAll(reset: true);
        SavedProductController.to.fetchAll(reset: true);

        Get.offAll(() => Dashboard());
      }
    }
  }

  static void authenticateUser({required User user, required Function onDone, required Function(String error) onError}) async {
    _authRepo.addDataToDb(
      firebaseUser: user,
      onSuccess: (appUser, tokens) async {
        //Fetching defaults state data
        final isCatEmpty = CategoryController.to.categoryList.isEmpty;
        final isSubCatEmpty = SubCategoryController.to.subCategoryList.isEmpty;
        final isCoinsEmpty = CoinsController.to.myCoins == null;
        if (isCatEmpty || isSubCatEmpty || isCoinsEmpty) {
          final cats = await RepoCategory.findAll();
          final subCats = await RepoSubCategory.findAll();
          final coinsBalance = await CoinsController.to.getBalance();
          if (cats != null && subCats != null && coinsBalance != null) {
            CategoryController.to.setItems(items: cats);
            SubCategoryController.to.setItems(items: subCats);
            //Done & proceed
            onDone();
            AuthUtils.redirect(tokens, appUser);
          } else {
            onError("Network error");
          }
        } else {
          onDone();
          AuthUtils.redirect(tokens, appUser);
        }
      },
      onError: (er) {
        onError("$er");
      },
    );
  }
}
