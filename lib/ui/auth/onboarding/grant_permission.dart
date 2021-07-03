import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/repository/repo_category.dart';
import 'package:swapxchange/repository/repo_sub_category.dart';
import 'package:swapxchange/ui/auth/auth_funtions.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/settings/change_location.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/ui/widgets/step_progress_view.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/permissions.dart';
import 'package:swapxchange/utils/styles.dart';

class GrantPermission extends StatefulWidget {
  @override
  _GrantPermissionState createState() => _GrantPermissionState();
}

class _GrantPermissionState extends State<GrantPermission> {
  PageController controller = PageController(initialPage: 0);
  var currentPageValue = 0.0;
  Color _stepperActiveColor = KColors.PRIMARY;

  int _curStep = 0;
  bool _isLoading = false;
  AuthRepo _authRepo = AuthRepo();

  @override
  void initState() {
    super.initState();
    pageViewListener();
  }

  void pageViewListener() {
    controller.addListener(() {
      setState(() {
        _curStep = controller.page!.toInt();
        if (_curStep == 0) {
          _stepperActiveColor = KColors.PRIMARY;
        } else if (_curStep == 1) {
          _stepperActiveColor = Color(0xffC85F07);
        }
      });
    });
  }

  _grantLocationAccess() async {
    setState(() => _isLoading = true);
    Permissions.locationPermission().then((isPermGranted) async {
      if (isPermGranted) {
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
          List<Placemark> addresses = await placemarkFromCoordinates(position.latitude, position.longitude);

          var placeMark = addresses.first;
          String address = "${placeMark.street} ${placeMark.subLocality}, ${placeMark.locality}";
          var city = placeMark.subLocality == null || placeMark.subLocality!.isEmpty ? placeMark.locality : placeMark.subLocality;

          // address =
          //     "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}";

          if (address.isEmpty) {
            AlertUtils.alert("Address couldn't be found, enter address manually");
            return;
          }

          _authRepo.updateAddress(
            address: address,
            address_lat: position.latitude,
            address_long: position.longitude,
            state: city ?? address,
            onSuccess: (appUser) {
              if (appUser != null) UserController.to.setUser(appUser);
              controller.animateToPage(_curStep + 1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
            },
            onError: (er) {
              AlertUtils.toast("$er");
            },
          );
          setState(() => _isLoading = false);
        }).catchError((e) {
          print(e);
          AlertUtils.toast('$e');
          setState(() => _isLoading = false);
        });
      } else {
        setState(() => _isLoading = false);
        AlertUtils.toast("Access denied");
      }
    });
  }

  _gotoDashboard() async {
    setState(() => _isLoading = true);
    final cats = await RepoCategory.findAll();
    final subCats = await RepoSubCategory.findAll();

    if (cats != null && subCats != null) {
      CategoryController.to.setItems(items: cats);
      SubCategoryController.to.setItems(items: subCats);

      //Done, fetch default persistent data & proceed
      AuthFunctions.gotoDashboard();
    } else {
      setState(() => _isLoading = false);
      AlertUtils.toast("Network error");
    }
  }

  _openManualAddress() async {
    final address = await Get.to(() => ChangeLocation());
    if (address != null) {
      _gotoDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Container(
        child: PageView.builder(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, position) {
            if (position == 0) {
              return GrantPermContainer(
                imageString: 'images/location-permission.png',
                textTitle: "Hi, Welcome!",
                textDisplay: "SwapXchange.ng is a platform for exchange/swap. Open access to your location and we'll show interesting offers close to you.",
                button: PrimaryButton(
                  onClick: () => _grantLocationAccess(),
                  btnText: 'Allow Access',
                  isLoading: _isLoading,
                ),
                secButton: InkWell(
                  onTap: _openManualAddress,
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                    child: Text(
                      'Enter address manually'.toUpperCase(),
                      style: StyleNormal.copyWith(
                        color: KColors.TEXT_COLOR_DARK,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return GrantPermContainer(
                imageString: 'images/exit.png',
                textTitle: "Let's Go",
                textDisplay: "You definitely have unnecessary stuff. Offer it to users and get what you dream of. Browse items available for swap and make a deal. "
                    "So money is no longer needed.",
                button: PrimaryButton(
                  onClick: () => _gotoDashboard(),
                  btnText: "Great, I\'m in",
                  bgColor: Color(0xffC85F07),
                  isLoading: _isLoading,
                  arrowColor: Color(0xffC85F07),
                ),
              );
            }
          },
          itemCount: 2,
          onPageChanged: (newPage) {},
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        // color: _color,
        child: StepProgressView(
          itemSize: 4,
          width: Get.size.width,
          curStep: 3,
          inActiveColor: KColors.TEXT_COLOR_LIGHT.withOpacity(.3),
          activeColor: _stepperActiveColor,
        ),
      ),
    );
  }
}

class GrantPermContainer extends StatelessWidget {
  GrantPermContainer({
    required this.imageString,
    required this.textTitle,
    required this.textDisplay,
    required this.button,
    this.secButton,
  });

  final String imageString;
  final String textTitle;
  final String textDisplay;
  final Widget button;
  final Widget? secButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imageString,
                height: 100,
                // width: 200,
              ),
              SizedBox(height: 16),
              Text(
                textTitle,
                textAlign: TextAlign.center,
                style: H1Style,
              ),
              SizedBox(height: 10),
              Text(
                textDisplay,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: KColors.TEXT_COLOR,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              button,
              secButton ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
