import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/enum/storage_enum.dart';
import 'package:swapxchange/models/app_user.dart';
import 'package:swapxchange/repository/auth_repo.dart';
import 'package:swapxchange/repository/storage_methods.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/choose_image_from.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/styles.dart';

class EditProfile extends StatelessWidget {
  AppUser user = UserController.to.user!;
  TextEditingController nameController = TextEditingController(text: UserController.to.user!.name ?? "");
  TextEditingController emailController = TextEditingController(text: UserController.to.user!.email ?? "");
  TextEditingController phoneController = TextEditingController(text: UserController.to.user!.mobileNumber ?? "");
  FocusNode textFieldFocusName = FocusNode();
  FocusNode textFieldFocusEmail = FocusNode();
  FocusNode textFieldFocusPhone = FocusNode();

  _hideKeyboard() {
    textFieldFocusName.unfocus();
    textFieldFocusEmail.unfocus();
    textFieldFocusPhone.unfocus();
  }

  _update() async {
    _hideKeyboard();
    final name = nameController.text.toString().trim();
    final email = emailController.text.toString().trim();
    final phone = phoneController.text.toString().trim();

    var nameSplit = name.split(' ');
    if (name.isEmpty) {
      AlertUtils.toast('Enter your name');
    } else if (nameSplit.length < 2 || nameSplit[1].isEmpty) {
      AlertUtils.toast('Enter your full name');
    } else if (email.isEmpty) {
      AlertUtils.toast('Enter your email address');
    } else if (phone.isEmpty && FirebaseAuth.instance.currentUser!.providerData[0].providerId != "phone") {
      AlertUtils.toast('Enter your phone number');
    } else {
      AppUser cUser = user;
      cUser.email = email;
      cUser.mobileNumber = phone;
      cUser.name = name;

      AlertUtils.showProgressDialog(title: null);
      AuthRepo().updateUserDetails(
        appUser: cUser,
        onSuccess: (appUser) {
          AlertUtils.hideProgressDialog();
          if (appUser != null) {
            UserController.to.setUser(appUser);
            AlertUtils.toast('Profile details saved successfully');
          }
        },
        onError: (er) {
          AlertUtils.hideProgressDialog();
          AlertUtils.toast('$er');
          print("$er");
        },
      );
    }
  }

  void selectImage(ImageSource source) async {
    _hideKeyboard();
    File? selectedImage = await Helpers.pickImage(source: source);
    if (selectedImage != null) {
      AlertUtils.showProgressDialog(title: 'Updating photo...');
      String? imgUrl = await RepoStorage().uploadFile(selectedImage, StorageEnum.PROFILE);
      if (imgUrl != null) {
        // delete previous image
        await RepoStorage().delete(user.profilePhoto!, StorageEnum.PROFILE);
        // AuthRepo().getCurrentUser()!.updateProfile(photoURL: imgUrl); //Adding to the authentication table
        AppUser cUser = UserController.to.user!;
        cUser.profilePhoto = imgUrl;
        AuthRepo().updateUserDetails(
          appUser: cUser,
          onSuccess: (appUser) {
            AlertUtils.hideProgressDialog();
            if (appUser != null) {
              UserController.to.setUser(appUser);
              AlertUtils.toast('Profile photo saved successfully');
            }
          },
          onError: (er) {
            AlertUtils.hideProgressDialog();
            AlertUtils.alert('$er');
            print("$er");
          },
        );
      } else {
        AlertUtils.toast('Error occurred while uploading your image.');
      }
    }
  }

  _showFileChooser() {
    Get.bottomSheet(
      ChooseImageFrom(
        imageSource: (source) => selectImage(source),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(
          makeTransparent: true,
          title: '',
          actionBtn: [
            Align(
              child: ButtonSmall(
                onClick: _update,
                text: 'update',
                bgColor: KColors.PRIMARY,
                textColor: Colors.white,
              ),
            ),
            SizedBox(width: 16)
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: Constants.PADDING).copyWith(top: context.mediaQueryPadding.top),
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          boxShadow: [Constants.SHADOW],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: GetBuilder<UserController>(builder: (userController) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedImage(
                              userController.user!.profilePhoto,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              alt: ImagePlaceholder.User,
                            ),
                          );
                        }),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: _showFileChooser,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.3),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.white30,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: nameController,
                      focusNode: textFieldFocusName,
                      keyboardType: TextInputType.name,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: KColors.TEXT_COLOR_DARK,
                        fontWeight: FontWeight.w600,
                      ),
                      cursorColor: Colors.blueGrey,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: StyleNormal.copyWith(
                          color: KColors.TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
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
                  Text(
                    'Your name',
                    style: StyleNormal.copyWith(
                      color: KColors.TEXT_COLOR_LIGHT,
                    ),
                  ),
                  SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: emailController,
                      focusNode: textFieldFocusEmail,
                      keyboardType: TextInputType.emailAddress,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: KColors.TEXT_COLOR_DARK,
                        fontWeight: FontWeight.w600,
                      ),
                      cursorColor: Colors.blueGrey,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        hintStyle: StyleNormal.copyWith(
                          color: KColors.TEXT_COLOR,
                          fontWeight: FontWeight.w500,
                        ),
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
                  Text(
                    'Email address',
                    style: StyleNormal.copyWith(
                      color: KColors.TEXT_COLOR_LIGHT,
                    ),
                  ),
                  if (FirebaseAuth.instance.currentUser!.providerData[0].providerId != "phone")
                    Column(
                      children: [
                        SizedBox(height: 32),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: phoneController,
                            focusNode: textFieldFocusPhone,
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: KColors.TEXT_COLOR_DARK,
                              fontWeight: FontWeight.w600,
                            ),
                            cursorColor: Colors.blueGrey,
                            decoration: InputDecoration(
                              hintText: 'Phone number',
                              hintStyle: StyleNormal.copyWith(
                                color: KColors.TEXT_COLOR,
                                fontWeight: FontWeight.w500,
                              ),
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
                        Text(
                          'Phone number',
                          style: StyleNormal.copyWith(
                            color: KColors.TEXT_COLOR_LIGHT,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
