import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/ui/auth/auth_funtions.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/ui/widgets/step_progress_view.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class EnterName extends StatefulWidget {
  @override
  _EnterNameState createState() => _EnterNameState();
}

class _EnterNameState extends State<EnterName> {
  TextEditingController fullnameController = TextEditingController();
  FocusNode textFieldFocusName = FocusNode();

  bool _isLoading = false;
  AuthRepo _authRepo = AuthRepo();
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _authRepo.getCurrentUser();
  }

  _updateName() async {
    String name = fullnameController.text.toString().trim();
    var nameSplit = name.split(' ');
    if (name.isEmpty) {
      AlertUtils.toast('Enter your name');
      return;
    } else if (nameSplit.length < 2 || nameSplit[1].isEmpty) {
      AlertUtils.toast('Enter your full name');
      return;
    }

    setState(() => _isLoading = true);
    try {
      _user = FirebaseAuth.instance.currentUser;
      await _user!.updateProfile(displayName: name).timeout(Duration(seconds: 5));
      await _user?.reload().timeout(Duration(seconds: 5));
      _user = FirebaseAuth.instance.currentUser;
      //Auth User
      _authenticate(_user!);
    } catch (e) {
      AlertUtils.toast('Something went wrong: $e');
    }
    setState(() => _isLoading = false);
  }

  _authenticate(User user) {
    AuthFunctions.authenticateUser(
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: KColors.PRIMARY,
          ),
          onPressed: () => Get.back(),
        ),
      ),
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
                  'Your Name',
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
                    controller: fullnameController,
                    focusNode: textFieldFocusName,
                    keyboardType: TextInputType.name,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    autofocus: true,
                    style: TextStyle(
                      color: KColors.TEXT_COLOR_DARK,
                      fontWeight: FontWeight.w600,
                    ),
                    cursorColor: Colors.blueGrey,
                    decoration: InputDecoration(
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
                  onClick: () => _updateName(),
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: StepProgressView(
              itemSize: 4,
              width: MediaQuery.of(context).size.width,
              curStep: 2,
              inActiveColor: KColors.TEXT_COLOR_LIGHT.withOpacity(.3),
              activeColor: KColors.PRIMARY,
            ),
          )
        ],
      ),
    );
  }
}
