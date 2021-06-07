import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/enum/product_state.dart';
import 'package:swapxchange/utils/colors.dart';

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
    final product = addController.product.value;

    switch (productState) {
      case ProductState.productName:
        title = 'Name your Offer';
        textEditingController.text = product.productName!;
        break;
      case ProductState.price:
        title = 'Enter your price';
        textEditingController.text = (product.price != null) ? product.price.toString() : '';
        textInputType = TextInputType.number;
        break;
      case ProductState.productDescription:
        title = 'Describe your product';
        textEditingController.text = product.productDescription!;
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
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.blueGrey,
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.blueGrey.withOpacity(.2),
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
              child: FlatButton(
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  final product = addController.product;
                  if (productState == ProductState.productName) {
                    product.value.productName = textEditingController.text;
                  } else if (productState == ProductState.price) {
                    product.value.price = int.parse(textEditingController.text);
                  } else if (productState == ProductState.productDescription) {
                    product.value.productDescription = textEditingController.text;
                  }
                  addController.updateProduct(product.value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
