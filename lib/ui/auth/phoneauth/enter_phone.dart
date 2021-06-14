import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/auth/auth_funtions.dart';
import 'package:swapxchange/ui/auth/phoneauth/verify_phone.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/components/step_progress_view.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class EnterPhone extends StatefulWidget {
  @override
  _EnterPhoneState createState() => _EnterPhoneState();
}

class _EnterPhoneState extends State<EnterPhone> {
  TextEditingController phoneNumberController = TextEditingController();

  FocusNode textFieldFocusPhone = FocusNode();

  bool _isLoading = false;
  AuthRepo _authRepo = AuthRepo();

  @override
  void initState() {
    super.initState();

    User? user = _authRepo.getCurrentUser();
    if (user != null) _authenticate(user);
  }

  _signInWithPhone() {
    String phoneNo = phoneNumberController.text.toString().trim();
    if (phoneNo.isEmpty) {
      AlertUtils.toast('Enter your phone number');
      return;
    } else if (phoneNo.length < 10) {
      AlertUtils.toast('Enter valid phone number');
      return;
    }
    //include country code
    phoneNo = '+234$phoneNo';

    setState(() => _isLoading = true);
    _authRepo.phoneNumberSignIn(
      phoneNumber: '$phoneNo',
      loginSuccess: (user) {
        _authenticate(user);
      },
      onCodeSent: (phoneVerificationId) {
        Get.to(
          () => VerifyOtp(
            phoneVerificationId: phoneVerificationId,
            phoneNo: phoneNo,
          ),
          transition: Transition.leftToRight,
        );
      },
      onCodeAutoRetrievalTimeout: (er) {
        AlertUtils.toast('Timeout: $er');
        setState(() => _isLoading = false);
      },
      onFailed: (er) {
        AlertUtils.toast('Error encountered: $er');
        print(er);
        setState(() => _isLoading = false);
      },
    );
  }

  _authenticate(User user) {
    Auth.authenticateUser(
      user: user,
      onDone: () {
        setState(() => _isLoading = false);
      },
      onError: (er) {
        setState(() => _isLoading = false);
        AlertUtils.toast("$er");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter Phone Number',
                  style: H1Style,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    controller: phoneNumberController,
                    focusNode: textFieldFocusPhone,
                    keyboardType: TextInputType.phone,
                    maxLines: 1,
                    maxLength: 11,
                    autofocus: true,
                    style: TextStyle(
                      color: KColors.TEXT_COLOR_DARK,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: Colors.blueGrey,
                    decoration: InputDecoration(
                      counterText: '',
                      prefixText: '+234 ',
                      prefixStyle: TextStyle(
                        color: KColors.TEXT_COLOR_DARK,
                        fontWeight: FontWeight.w600,
                      ),
                      // labelText: 'Enter phone',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8, bottom: 2, top: 2, right: 8),
                    ),
                  ),
                ),
                SizedBox(height: 64),
                PrimaryButton(
                  btnText: 'CONTINUE',
                  onClick: _signInWithPhone,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
          CustomBackButton(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: StepProgressView(
              itemSize: 4,
              width: MediaQuery.of(context).size.width,
              curStep: 0,
              inActiveColor: KColors.TEXT_COLOR_LIGHT.withOpacity(.3),
              activeColor: KColors.PRIMARY,
            ),
          )
        ],
      ),
    );
  }
}
