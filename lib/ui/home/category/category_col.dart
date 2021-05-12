import 'package:flutter/material.dart';
import 'package:swapxchange/ui/home/tabs/home/top_deals.dart';
import 'package:swapxchange/utils/colors.dart';

class CategoryCol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: 10,
          itemBuilder: (context, index) {
            Color? txtColor =
                index != 2 ? KColors.TEXT_COLOR.withOpacity(.2) : null;
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              child: CategoryBtn(
                textColor: txtColor,
                showShadow: index != 2 ? false : true,
                title: 'Agriculture',
              ),
            );
          },
        ),
      ),
    );
  }
}
