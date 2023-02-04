import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailBackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.mediaQueryPadding.top,
      left: context.mediaQueryPadding.left + 4,
      child: CircleAvatar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white30,
          ),
        ),
      ),
    );
  }
}
