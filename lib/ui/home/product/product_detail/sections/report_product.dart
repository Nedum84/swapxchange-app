import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/models/reported_product_model.dart';
import 'package:swapxchange/repository/repo_reported_product.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class ReportProduct extends StatelessWidget {
  final Product product;
  ReportProduct({Key? key, required this.product}) : super(key: key);

  TextEditingController _textFieldController = TextEditingController();
  FocusNode textFieldFocusName = FocusNode();

  _submitReport() async {
    textFieldFocusName.unfocus();
    final msg = _textFieldController.text.toString().trim();
    if (msg.isEmpty) {
      AlertUtils.toast('Enter report message');
      return;
    }

    AlertUtils.showProgressDialog(title: null);
    final reportedProduct = ReportedProductModel(
      productId: product.productId,
      uploadedBy: product.userId,
      reportedMessage: msg,
    );

    final addFeedback = await RepoReportedProduct.addReportedProductModel(reported_product: reportedProduct);
    if (addFeedback != null) {
      AlertUtils.toast('Product report submitted');
      Get.back();
      _textFieldController.clear();
    } else {
      AlertUtils.toast('Error occurred, try again');
    }

    AlertUtils.hideProgressDialog();
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Report product'),
            content: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5), width: 1),
              ),
              child: TextField(
                controller: _textFieldController,
                focusNode: textFieldFocusName,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                style: TextStyle(
                  color: KColors.TEXT_COLOR_DARK,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: Colors.blueGrey,
                decoration: InputDecoration(
                  hintText: 'Report #${product.productName}...',
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
            actions: <Widget>[
              new TextButton(
                child: new Text(
                  'SUBMIT',
                  style: StyleNormal.copyWith(
                    color: KColors.TEXT_COLOR_DARK,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: _submitReport,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ButtonOutline2(
      titleColor: KColors.RED,
      title: 'Report this',
      onClick: () => _displayDialog(context),
    );
  }
}
