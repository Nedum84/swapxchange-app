import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/components/custom_appbar.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class ChangeLocation extends StatelessWidget {
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
                  SizedBox(height: 64),
                  Text(
                    'Choose location to swap',
                    style: H1Style,
                  ),
                  SizedBox(height: 12),
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
                        hintText: 'Your address...',
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Constants.PADDING, vertical: 2),
                    child: Text(
                      'All your offers will be published with this address. Other users will see the distance to this location.',
                      style: StyleNormal.copyWith(
                        color: KColors.TEXT_COLOR_LIGHT,
                      ),
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
