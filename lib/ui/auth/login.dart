import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/repository/storage_methods.dart';
import 'package:swapxchange/ui/auth/auth_funtions.dart';
import 'package:swapxchange/ui/auth/phoneauth/enter_phone.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/styles.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  AuthRepo _authRepo = AuthRepo();
  RepoStorage _storageRepo = RepoStorage();

  _facebookSignIn() async {
    setState(() => _isLoading = true);

    _authRepo.facebookSignIn(
      loginSuccess: (user) async {
        //--> Download Image and save it if not empty and haven't been saved earlier
        if (user.photoURL!.isEmpty || !user.photoURL!.contains('facebook')) {
          _authenticateUser(user);
        } else {
          File? imgFile = await _storageRepo.downloadFileFromUrl(user.photoURL!);
          if (imgFile == null) {
            _authenticateUser(user);
          } else {
            String? imgUrl = await RepoStorage().uploadFile(imgFile);
            if (imgUrl == null) {
              _authenticateUser(user);
            } else {
              //Update the image URL on the User Obj
              User? _user = FirebaseAuth.instance.currentUser;
              await _user!.updateProfile(photoURL: imgUrl).timeout(Duration(seconds: 5));
              await _user.reload().timeout(Duration(seconds: 5));
              _user = FirebaseAuth.instance.currentUser;
              _authenticateUser(_user!);
            }
          }
        }
      },
      onProgress: () {
        setState(() => _isLoading = true);
      },
      onCancelled: () {
        AlertUtils.toast('Operation cancelled');
        setState(() => _isLoading = false);
      },
      onFailed: () {
        AlertUtils.toast('Facebook signin failed');
        setState(() => _isLoading = false);
      },
    );
  }

  _authenticateUser(User user) {
    AuthUtils.authenticateUser(
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
    // setState(() => _isLoading = false);
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.jpg',
              width: Get.width / 3,
            ),
            SizedBox(height: 2),
            Text(
              'Get Started',
              style: H1Style,
            ),
            SizedBox(height: 32),
            PrimaryButton(
              btnText: 'CONTINUE WITH PHONE NUMBER',
              onClick: () {
                if (!_isLoading)
                  Get.to(
                    () => EnterPhone(),
                  );
              },
            ),
            SizedBox(height: 16),
            SecondaryButton(
              onClick: _facebookSignIn,
              isLoading: _isLoading,
            ),
            Container(
              margin: EdgeInsets.only(top: 24),
              child: Text.rich(
                TextSpan(
                  text: 'By signing up or logging in, you agree to our ',
                  style: StyleNormal.copyWith(fontSize: 12),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                        text: 'Licence Agreement',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        )),
                    // can add more TextSpans here...
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                    // color: kColorAsh
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
