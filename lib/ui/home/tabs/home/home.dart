import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:swapxchange/controllers/product_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/ui/components/loading_overlay.dart';
import 'package:swapxchange/ui/components/product_item.dart';
import 'package:swapxchange/ui/home/tabs/home/top_deals.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

import 'home_app_bar.dart';

class Home extends StatefulWidget {
  // var user = UserController.to.user;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserController userController = UserController.to;
  final ProductController productController = ProductController.to;
  final PagingController<int, Product> _pagingController = PagingController(firstPageKey: 0);

  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    // _pagingController.addPageRequestListener((pageKey) {
    //   _fetchPage(
    //     pageKey,
    //   );
    // });

    print("Hello more...");
    controller = new ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    // print(controller?.position.extentAfter);
    // if (controller!.position.extentAfter < 500) {
    // print("load more...");
    // productController.fetchAll(offset: 2, limit: 10);
    // setState(() {
    //   items.addAll(new List.generate(42, (index) => 'Inserted $index'));
    // });
    // }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await productController.fetchAll(offset: pageKey);
      final isLastPage = newItems.length < productController.pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (controller!.position.extentAfter < 200) {
        print('Load more nah!!!');
      }
    }
    return false;
  }

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
            child: NotificationListener(
              onNotification: _handleScrollNotification,
              child: ListView(
                controller: controller,
                shrinkWrap: true,
                // physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(0),
                children: [
                  TopDeals(),
                  SizedBox(height: 16),
                  Text('Latest', style: H1Style),
                  InkWell(
                    onTap: () => Get.back(),
                    // onDoubleTap: () => CategoryController.to.fetch(),
                    // onLongPress: () => SubCategoryController.to.fetchByCategoryId(catId: 2),
                    child: Text('data'),
                  ),
                  SizedBox(height: 16),
                  // PagedGridView<int, Product>(
                  //   shrinkWrap: true,
                  //   physics: ClampingScrollPhysics(),
                  //   pagingController: _pagingController,
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2,
                  //     childAspectRatio: 3 / 4,
                  //     mainAxisSpacing: 8,
                  //     crossAxisSpacing: 0,
                  //   ),
                  //   builderDelegate: PagedChildBuilderDelegate<Product>(
                  //     itemBuilder: (context, item, index) {
                  //       return ProductItem(
                  //         product: item,
                  //       );
                  //     },
                  //   ),
                  // ),
                  GetX<ProductController>(
                    init: ProductController(),
                    builder: (pController) {
                      return LoadingOverlay(
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
