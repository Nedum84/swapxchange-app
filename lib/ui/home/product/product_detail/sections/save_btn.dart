import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaveBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.mediaQueryPadding.top,
      right: context.mediaQueryPadding.left + 4,
      child: CircleAvatar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
        child: IconButton(
          onPressed: () => null,
          icon: Icon(
            Icons.favorite,
            color: Colors.white30,
          ),
        ),
      ),
    );
  }
}
