import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/components/dashboard_custom_appbar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class SavedProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            DashboardCustomAppbar(
              title: 'Saved Products',
              actionBtn: IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.post_add,
                  color: KColors.TEXT_COLOR_DARK,
                ),
                onPressed: () => null,
              ),
            ),
            NoProductWidget(),
            // Expanded(
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
            //     child: GridView.builder(
            //       padding: EdgeInsets.all(0),
            //       itemCount: 50,
            //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2,
            //         childAspectRatio: 3 / 4,
            //         mainAxisSpacing: 8,
            //         crossAxisSpacing: 0,
            //       ),
            //       itemBuilder: (context, index) {
            //         return ProductItem();
            //       },
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class NoProductWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No product found',
              style: H1Style.copyWith(
                fontSize: 18,
                color: KColors.TEXT_COLOR_DARK.withOpacity(.9),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonOutline(
                  icon: Icons.add,
                  title: 'Sell Product',
                  onClick: () => null,
                ),
                SizedBox(width: 8),
                ButtonOutline(
                  icon: Icons.search_sharp,
                  title: 'Browse Items',
                  onClick: () => null,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
