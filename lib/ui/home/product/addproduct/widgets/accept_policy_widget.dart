import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/utils/colors.dart';

class AcceptPolicyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(builder: (addController) {
      return Container(
        child: (addController.isEditing)
            ? Container()
            : ListTile(
                leading: Checkbox(
                  activeColor: KColors.PRIMARY,
                  value: addController.isAcceptedTerms,
                  onChanged: (newVal) {
                    addController.setAcceptedTerm();
                  },
                ),
                title: Text.rich(
                  TextSpan(
                    text: 'By publishing your product, you agree to our ',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Ad submission rule',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                      TextSpan(text: ' and ', style: TextStyle()),
                      TextSpan(
                          text: 'Prohibited Products',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                      // can add more TextSpans here...
                    ],
                  ),
                  style: TextStyle(
                      // color: kColorAsh
                      ),
                ),
              ),
      );
    });
  }
}
