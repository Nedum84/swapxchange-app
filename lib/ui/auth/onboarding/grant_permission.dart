import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as pHandler;
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/components/step_progress_view.dart';
import 'package:swapxchange/ui/home/tabs/dashboard/dashboard.dart';
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
          _stepperActiveColor = KColors.SECONDARY;
        }
      });
    });
  }

  _grantLocationAccess() async {
    _gotoDashboard();
    return;
    setState(() => _isLoading = true);
    Permissions.locationPermission().then((isPermGranted) async {
      if (isPermGranted) {
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
          List<Placemark> addresses = await placemarkFromCoordinates(position.latitude, position.longitude);

          var placeMark = addresses.first;
          String address = "${placeMark.street} ${placeMark.subLocality}, ${placeMark.locality}";

          // address =
          //     "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}";

          _authRepo.updateAddress(
              address: address,
              address_lat: position.latitude,
              address_long: position.longitude,
              state: placeMark.subLocality!,
              onSuccess: (appUser) {
                controller.animateToPage(_curStep + 1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              },
              onError: (er) {
                AlertUtils.toast("$er");
              });
          setState(() => _isLoading = false);
        }).catchError((e) {
          print(e);
          AlertUtils.toast('$e');
          setState(() => _isLoading = false);
        });
      } else {
        pHandler.openAppSettings();
        setState(() => _isLoading = false);
        AlertUtils.toast("Access denied");
      }
    });
  }

  _gotoDashboard() {
    Get.to(() => Dashboard());
  }

  @override
  Widget build(BuildContext context) {
    // setState(() => _isLoading = false);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Container(
        child: PageView.builder(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, position) {
            if (position == 0) {
              return GrantPermContainer(
                imageString: 'images/location_access.png',
                textTitle: "Hi, Welcome!",
                textDisplay: "SwapXchange.ng is a platform for exchange/swap. Open access to your location and we'll show interesting offers close to you.",
                button: PrimaryButton(
                  onClick: () => _grantLocationAccess(),
                  btnText: 'Allow Access',
                  isLoading: _isLoading,
                ),
              );
            } else {
              return GrantPermContainer(
                imageString: 'images/file_access.png',
                textTitle: "Let's Go",
                textDisplay: "You definitely have unnecessary stuff. Offer it to users and get what you dream of. Browse items available for swap and make a deal. "
                    "So money is no longer needed.",
                button: PrimaryButton(
                  onClick: () => _gotoDashboard(),
                  btnText: "Great, I\'m in",
                  bgColor: KColors.SECONDARY,
                  textColor: KColors.TEXT_COLOR_DARK,
                  arrowColor: Colors.white,
                ),
              );
            }
          },
          itemCount: 3,
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
  });

  final String imageString;
  final String textTitle;
  final String textDisplay;
  final Widget button;

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
                // height: 70,
                width: 200,
              ),
              Text(
                textTitle,
                textAlign: TextAlign.center,
                style: H1Style,
              ),
              SizedBox(
                height: 10,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
