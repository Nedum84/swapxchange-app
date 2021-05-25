import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/product_search_controller.dart';
import 'package:swapxchange/ui/components/product_item.dart';
import 'package:swapxchange/ui/home/search/search_appbar.dart';
import 'package:swapxchange/ui/home/search/search_filters_container.dart';
import 'package:swapxchange/utils/constants.dart';

import 'suggestions_container.dart';

class ProductSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(Constants.PADDING).copyWith(top: context.mediaQueryPadding.top),
        child: Column(
          children: [
            SearchAppBar(),
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      SearchFiltersContainer(),
                      Expanded(
                        child: GetBuilder<ProductSearchController>(
                          // init: ProductSearchController(),
                          builder: (productController) {
                            if (productController.isLoading.value) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (productController.productList.isEmpty) {
                              return Center(
                                child: Text('No Item found.'),
                              );
                            }
                            return NotificationListener(
                              onNotification: productController.handleScrollNotification,
                              child: GridView.builder(
                                controller: productController.controller,
                                padding: EdgeInsets.all(0),
                                itemCount: productController.productList.length,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                addAutomaticKeepAlives: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 4,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 0,
                                ),
                                itemBuilder: (context, index) {
                                  return ProductItem(
                                    product: productController.productList[index],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SuggestionsContainer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
