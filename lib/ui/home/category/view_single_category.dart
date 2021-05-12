import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/components/custom_appbar.dart';
import 'package:swapxchange/ui/components/product_item.dart';
import 'package:swapxchange/ui/home/search/product_search.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';

class ViewSingleCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(Constants.PADDING)
            .copyWith(top: context.mediaQueryPadding.top),
        child: Column(
          children: [
            CustomAppbar(title: 'Agriculture'),
            Container(
              height: 40,
              child: ListView.separated(
                itemCount: 20,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Color textColor = index == 2
                      ? KColors.PRIMARY
                      : KColors.TEXT_COLOR.withOpacity(.6);
                  return SearchFilterItem(
                    textColor: textColor,
                    text: 'WRIST WATCH',
                    onClick: () => null,
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(width: 16),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(0),
                itemCount: 50,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 0,
                ),
                itemBuilder: (context, index) {
                  return ProductItem();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
