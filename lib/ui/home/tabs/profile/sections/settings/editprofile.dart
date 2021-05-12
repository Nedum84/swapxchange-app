import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/components/custom_appbar.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class EditProfile extends StatelessWidget {
  TextEditingController fullnameController = TextEditingController();
  FocusNode textFieldFocusName = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY2,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: Constants.PADDING)
            .copyWith(top: context.mediaQueryPadding.top),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
              child: CustomAppbar(
                title: '',
                actionBtn: ButtonSmall(
                  onClick: () => print('Hey'),
                  text: 'update',
                  bgColor: KColors.PRIMARY,
                  textColor: Colors.white,
                ),
              ),
            ),
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'images/swapx.jpeg',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.5),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.white30,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: fullnameController,
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
                        contentPadding: EdgeInsets.only(
                            left: 8, bottom: 2, top: 2, right: 8),
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
                      border: Border.all(
                          color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
                      color: Colors.white,
                    ),
                    child: TextField(
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
                        contentPadding: EdgeInsets.only(
                            left: 8, bottom: 2, top: 2, right: 8),
                      ),
                    ),
                  ),
                  Text(
                    'Email address',
                    style: StyleNormal.copyWith(
                      color: KColors.TEXT_COLOR_LIGHT,
                    ),
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
