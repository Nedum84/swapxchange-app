import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/auth/auth_funtions.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/components/step_progress_view.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class VerifyOtp extends StatefulWidget {
  final String phoneVerificationId;
  final String phoneNo;

  VerifyOtp(
      {Key? key, required this.phoneVerificationId, required this.phoneNo})
      : super(key: key);

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController otpCodeController = TextEditingController();
  FocusNode textFieldFocusOtp = FocusNode();

  bool _isLoading = false;
  AuthRepo _authRepo = AuthRepo();
  String? _phoneVerificationId;

  Timer? timerTicker;
  int _currentTime = 0;
  int totalTimeMins = 60;

  @override
  void initState() {
    super.initState();
    _phoneVerificationId = widget.phoneVerificationId;
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timerTicker?.cancel();
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      timerTicker = timer;
      print(timer.tick);
      setState(() => _currentTime = timer.tick);

      if (timer.tick >= totalTimeMins) {
        timer.cancel();
      }
    });
  }

  _resendOtp() {
    setState(() => _isLoading = true);
    _authRepo.phoneNumberSignIn(
      phoneNumber: widget.phoneNo,
      loginSuccess: (user) {},
      onCodeSent: (phoneVerificationId) {
        _phoneVerificationId = phoneVerificationId;
        AlertUtils.toast('An OTP has been sent to your phone number');
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

  _verifyOtp() async {
    String otpCode = otpCodeController.text.toString().trim();
    if (otpCode.isEmpty) {
      AlertUtils.toast('Enter OTP code');
      return;
    } else if (otpCode.length < 5) {
      AlertUtils.toast('Incorrect OTP code');
      return;
    }

    setState(() => _isLoading = true);
    var user = await _authRepo.verifyOTP(
        otpCode: otpCode, verificationId: _phoneVerificationId!);
    if (user == null) {
      AlertUtils.toast('Incorrect OTP entered');
      setState(() => _isLoading = false);
    } else {
      _authenticate(user);
    }
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
                  'Enter Otp sent to ${widget.phoneNo}',
                  style: H1Style,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    controller: otpCodeController,
                    focusNode: textFieldFocusOtp,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    maxLength: 6,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: KColors.TEXT_COLOR_DARK,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: Colors.blueGrey,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 8, bottom: 2, top: 2, right: 8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                (_currentTime < totalTimeMins)
                    ? Text(
                        'Resend OTP in 00:${totalTimeMins - _currentTime}s',
                        style: TextStyle(color: KColors.TEXT_COLOR),
                      )
                    : resendOtp(),
                SizedBox(height: 64),
                PrimaryButton(
                  btnText: 'CONTINUE',
                  onClick: () => _verifyOtp(),
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
              curStep: 1,
              inActiveColor: KColors.TEXT_COLOR_LIGHT.withOpacity(.3),
              activeColor: KColors.PRIMARY,
            ),
          )
        ],
      ),
    );
  }

  Widget resendOtp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Did not receive OTP?',
          style: TextStyle(color: KColors.TEXT_COLOR),
        ),
        SizedBox(
          width: 4,
        ),
        ButtonSmall(
          text: 'Resend',
          onClick: _resendOtp,
        ),
      ],
    );
  }
}
