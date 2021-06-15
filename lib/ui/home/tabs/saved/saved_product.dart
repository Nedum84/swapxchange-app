import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/components/dashboard_custom_appbar.dart';
import 'package:swapxchange/ui/home/product/addproduct/add_product.dart';
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
              icon: Icons.post_add,
              iconClick: () => Get.to(() => AddProduct()),
            ),
            NoProductWidget(title: "No product found"),
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
  final String title;

  const NoProductWidget({Key? key, required this.title}) : super(key: key);

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
              title,
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
