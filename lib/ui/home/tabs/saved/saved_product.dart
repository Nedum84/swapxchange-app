import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/saved_product_controller.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/components/dashboard_custom_appbar.dart';
import 'package:swapxchange/ui/components/product_item.dart';
import 'package:swapxchange/ui/home/category/browse_category.dart';
import 'package:swapxchange/ui/home/product/addproduct/add_product.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class SavedProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SavedProductController>(builder: (savedProductController) {
      final products = savedProductController.productList;

      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: RefreshIndicator(
            onRefresh: () async {
              return savedProductController.fetchAll(reset: true);
            },
            color: KColors.PRIMARY,
            strokeWidth: 3,
            child: Column(
              children: [
                DashboardCustomAppbar(
                  title: 'Saved Products',
                  icon: Icons.post_add,
                  iconClick: () => Get.to(() => AddProduct()),
                ),
                Expanded(
                  child: (products.length != 0)
                      ? NotificationListener(
                          onNotification: savedProductController.handleScrollNotification,
                          child: GridView.builder(
                            controller: savedProductController.controller,
                            padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
                            itemCount: products.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 4,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 0,
                            ),
                            itemBuilder: (context, index) {
                              return ProductItem(
                                product: products[index],
                              );
                            },
                          ),
                        )
                      : Container(
                          child: Center(
                            child: (savedProductController.isLoading.value)
                                ? Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  )
                                : NoProductWidget(title: "No product found"),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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
                  onClick: () {
                    AddProductController.to.setEditing(false);
                    Get.to(() => AddProduct());
                  },
                ),
                SizedBox(width: 8),
                ButtonOutline(
                  icon: Icons.search_sharp,
                  title: 'Browse Items',
                  onClick: () => Get.to(() => BrowseCategory()),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
