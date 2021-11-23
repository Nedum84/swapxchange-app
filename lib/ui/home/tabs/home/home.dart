import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/product_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/ui/home/tabs/home/top_deals.dart';
import 'package:swapxchange/ui/home/tabs/saved/saved_product.dart';
import 'package:swapxchange/ui/widgets/loading_overlay.dart';
import 'package:swapxchange/ui/widgets/product_item.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

import 'home_app_bar.dart';

class Home extends StatelessWidget {
  final UserController userController = UserController.to;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return ProductController.to.fetchAll(reset: true);
      },
      color: KColors.PRIMARY,
      strokeWidth: 3,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HomeAppBar(),
            Expanded(
              child: GetBuilder<ProductController>(
                init: ProductController(),
                builder: (pController) {
                  return NotificationListener(
                    onNotification: pController.handleScrollNotification,
                    child: pController.productList.length == 0 && pController.isLoading.value == false
                        ? LayoutBuilder(
                            builder: (context, constraints) => SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height: constraints.maxHeight,
                                child: NoProductWidget(title: 'No product found around your location'),
                              ),
                            ),
                          )
                        : ListView(
                            padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
                            controller: pController.controller,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              if (pController.productList.length > 0) TopDeals(),
                              SizedBox(height: 16),
                              InkWell(
                                onTap: () {
                                  ProductController.to.fetchAll(reset: true);
                                },
                                child: Text('Latest', style: H1Style),
                              ),
                              SizedBox(height: 16),
                              LoadingOverlay(
                                isLoading: pController.isLoading.value,
                                itemCount: pController.productList.length,
                                child: GridView.builder(
                                  // controller: controller,
                                  padding: EdgeInsets.all(0),
                                  itemCount: pController.productList.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 4,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 0,
                                  ),
                                  itemBuilder: (context, index) {
                                    return ProductItem(
                                      product: pController.productList[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
