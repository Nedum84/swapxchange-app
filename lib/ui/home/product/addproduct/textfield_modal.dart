import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/enum/product_state.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class TextFieldModal extends StatelessWidget {
  final ProductState productState;
  TextFieldModal({required this.productState});

  final addController = AddProductController.to;

  late String title;
  late TextEditingController textEditingController = TextEditingController();
  late TextInputType textInputType;
  late int textInputTypeMaxLength;

  void initialize() {
    textInputType = TextInputType.name;
    textInputTypeMaxLength = 1;
    final product = addController.product;

    switch (productState) {
      case ProductState.productName:
        title = 'Name your Offer';
        textEditingController.text = product!.productName!;
        break;
      case ProductState.price:
        title = 'Enter your price';
        textEditingController.text = "${product!.price!}";
        textInputType = TextInputType.number;
        break;
      case ProductState.productDescription:
        title = 'Describe your product';
        textEditingController.text = product!.productDescription!;
        textInputType = TextInputType.text;
        textInputTypeMaxLength = 4;
        break;
      default:
        title = 'Write below';
    }
  }

  @override
  Widget build(BuildContext context) {
    initialize();

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: H1Style.copyWith(
                fontSize: 22.0,
              ),
            ),
            SizedBox(height: 8),
            Divider(
              color: KColors.TEXT_COLOR.withOpacity(.3),
            ),
            TextField(
              keyboardType: textInputType,
              maxLines: textInputTypeMaxLength,
              autofocus: true,
              cursorColor: Colors.blueGrey,
              cursorHeight: 30,
              textAlign: TextAlign.center,
              controller: textEditingController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: KColors.PRIMARY,
              ),
              child: PrimaryButton(
                btnText: 'Continue',
                onClick: () {
                  final txt = textEditingController.text.toString().trim();
                  final product = addController.product;
                  if (productState == ProductState.productName) {
                    product!.productName = txt;
                  } else if (productState == ProductState.price) {
                    product!.price = int.tryParse(txt) ?? 0;
                  } else if (productState == ProductState.productDescription) {
                    product!.productDescription = txt;
                  }
                  addController.updateProduct(product!);
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
