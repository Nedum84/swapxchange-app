import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/ui/components/product_item.dart';
import 'package:swapxchange/ui/home/tabs/home/top_deals.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

import 'home_app_bar.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HomeAppBar(),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(0),
              children: [
                TopDeals(),
                SizedBox(height: 16),
                Text('Latest', style: H1Style),
                SizedBox(height: 16),
                GridView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: 10,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
