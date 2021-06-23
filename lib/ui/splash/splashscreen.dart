import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/controllers/coins_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/repository/repo_category.dart';
import 'package:swapxchange/repository/repo_sub_category.dart';
import 'package:swapxchange/ui/auth/auth_funtions.dart';
import 'package:swapxchange/ui/auth/login.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthRepo _authRepo = AuthRepo();

  bool isError = false;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  _initialize() async {
    setState(() => isError = false);
    await Future.delayed(Duration(seconds: 2));

    final u = _authRepo.getCurrentUser();
    if (u == null) {
      Get.offAll(() => Login());
    } else {
      authenticateUser(u);
    }
  }

  void authenticateUser(User user) async {
    _authRepo.addDataToDb(
      firebaseUser: user,
      onSuccess: (appUser, tokens) {
        _fetchData(user);
      },
      onError: (er) {
        setState(() => isError = true);
        AlertUtils.toast("$er");
        print(er);
      },
    );
  }

  _fetchData(User user) async {
    final cats = await RepoCategory.findAll();
    RepoSubCategory.findByCategoryId(catId: 3);
    final subCats = await RepoSubCategory.findAll();
    final coinsBalance = await CoinsController.to.getBalance();
    if (cats != null && subCats != null && coinsBalance != null) {
      CategoryController.to.setItems(items: cats);
      SubCategoryController.to.setItems(items: subCats);
      AuthFunctions.authenticateUser(
        user: user,
        onDone: () => setState(() => isError = false),
        onError: (er) {
          setState(() => isError = true);
          AlertUtils.toast("$er");
        },
      );
    } else {
      setState(() => isError = true);
    }
  }

  var colorizeColors = [
    KColors.TEXT_COLOR_LIGHT,
    KColors.TEXT_COLOR_DARK,
    KColors.TEXT_COLOR,
    KColors.SECONDARY,
    KColors.TEXT_COLOR,
    KColors.PRIMARY,
  ];

  var colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontFamily: 'Horizon',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: !isError
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo_text1.png',
                    width: Get.width / 1.5,
                  ),
                  AnimatedTextKit(
                    repeatForever: true,
                    isRepeatingAnimation: true,
                    pause: Duration(milliseconds: 50),
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Find & Swap Stuff nearby',
                        textStyle: StyleNormal.copyWith(fontSize: 16),
                        colors: colorizeColors,
                        speed: Duration(milliseconds: 500),
                      ),
                    ],
                  )
                ],
              )
            : NoInternetError(onReload: _initialize),
      ),
    );
  }
}

class NoInternetError extends StatelessWidget {
  final Function() onReload;

  const NoInternetError({Key? key, required this.onReload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.perm_scan_wifi_outlined,
            size: 64,
            color: KColors.TEXT_COLOR,
          ),
          Text(
            'No Connection',
            style: H1Style,
          ),
          Text(
            "An internet error occurred and we couldn't load the pages. Please, try again",
            style: StyleNormal,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          ButtonOutline2(
            title: 'Reload Page',
            onClick: onReload,
            py: 8,
          ),
        ],
      ),
    );
  }
}
