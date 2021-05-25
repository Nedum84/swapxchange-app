import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/product_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/ui/components/loading_overlay.dart';
import 'package:swapxchange/ui/components/product_item.dart';
import 'package:swapxchange/ui/home/tabs/home/top_deals.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

import 'home_app_bar.dart';

class Home extends StatelessWidget {
  final UserController userController = UserController.to;
  final ProductController productController = ProductController.to;

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
            child: GetBuilder<ProductController>(
                init: ProductController(),
                builder: (pController) {
                  return NotificationListener(
                    onNotification: pController.handleScrollNotification,
                    child: ListView(
                      controller: pController.controller,
                      shrinkWrap: true,
                      // physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      children: [
                        TopDeals(),
                        SizedBox(height: 16),
                        Text('Latest', style: H1Style),
                        InkWell(
                          onTap: () => Get.back(),
                          child: Text(
                            'data',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                        SizedBox(height: 16),
                        LoadingOverlay(
                          isLoading: pController.isLoading.value,
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
                }),
          ),
        ],
      ),
    );
  }
}
