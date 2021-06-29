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
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/user_prefs.dart';

class AuthFunctions {
  static AuthRepo _authRepo = AuthRepo();

  static void redirect(Tokens? tokens, AppUser? appUser) async {
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
        //Fetching defaults state data
        final fetchData = await fetchDefaults();
        if (!fetchData) {
          final cats = await RepoCategory.findAll();
          final subCats = await RepoSubCategory.findAll();
          final coinsBalance = await CoinsController.to.getBalance();
          if (cats != null && subCats != null && coinsBalance != null) {
            CategoryController.to.setItems(items: cats);
            SubCategoryController.to.setItems(items: subCats);

            gotoDashboard();
          } else {
            AlertUtils.toast("Network error");
          }
        } else {
          gotoDashboard();
        }
      }
    }
  }

  static gotoDashboard() async {
    //Refresh balance either way
    await CoinsController.to.getBalance();
    //Done & proceed
    ProductController.to.fetchAll(reset: true);
    MyProductController.to.fetchAll(reset: true);
    SavedProductController.to.fetchAll(reset: true);

    Get.offAll(() => Dashboard());
  }

  static void authenticateUser({required User user, required Function onDone, required Function(String error) onError}) async {
    _authRepo.addDataToDb(
      firebaseUser: user,
      onSuccess: (appUser, tokens) async {
        //Done & proceed
        onDone();
        AuthFunctions.redirect(tokens, appUser);
      },
      onError: (er) {
        onError("$er");
      },
    );
  }

  static Future<bool> fetchDefaults() async {
    //Fetching defaults state data
    final isCatEmpty = CategoryController.to.categoryList.isEmpty;
    final isSubCatEmpty = SubCategoryController.to.subCategoryList.isEmpty;
    final isCoinsEmpty = CoinsController.to.myCoins == null;
    if (isCatEmpty || isSubCatEmpty || isCoinsEmpty) {
      final cats = await RepoCategory.findAll();
      final subCats = await RepoSubCategory.findAll();
      final coinsBalance = await CoinsController.to.getBalance();
      if (cats != null && subCats != null && coinsBalance != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
