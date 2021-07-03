import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/my_product_controller.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/myproducts/modal_options.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/ui/widgets/no_data_found.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class MyProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyProductController>(builder: (myProductController) {
      final products = myProductController.productList;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Constants.APPBAR_HEIGHT),
          child: CustomAppbar(
            title: 'My Products',
            actionBtn: [
              IconButton(
                onPressed: () => myProductController.fetchAll(reset: true),
                icon: Icon(
                  Icons.refresh,
                  color: KColors.TEXT_COLOR_DARK,
                ),
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            return myProductController.fetchAll(reset: true);
          },
          color: KColors.PRIMARY,
          strokeWidth: 3,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
            child: Column(
              children: [
                Expanded(
                  child: (products.length != 0)
                      ? NotificationListener(
                          onNotification: myProductController.handleScrollNotification,
                          child: ListView.separated(
                            controller: myProductController.controller,
                            padding: EdgeInsets.all(0),
                            itemCount: products.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MyProductItem(product: products[index]);
                            },
                            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 12),
                          ),
                        )
                      : Container(
                          child: Center(
                            child: (myProductController.isLoading.value)
                                ? Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  )
                                : NoDataFound(
                                    btnText: 'Refresh',
                                    subTitle: 'No product found',
                                    onBtnClick: () => myProductController.fetchAll(),
                                  ),
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

class MyProductItem extends StatelessWidget {
  final Product product;

  const MyProductItem({Key? key, required this.product}) : super(key: key);

  Widget _productStatus(ProductStatus status) {
    String text = "";
    Color bgColor;
    if (status == ProductStatus.UNPUBLISHED_PRODUCT_STATUS) {
      text = "unpublished";
      bgColor = KColors.TEXT_COLOR_LIGHT.withOpacity(0.6);
    } else if (status == ProductStatus.PENDING_APPROVAL_PRODUCT_STATUS) {
      text = "pending";
      bgColor = KColors.TEXT_COLOR_ACCENT;
    } else if (status == ProductStatus.ACTIVE_PRODUCT_STATUS) {
      text = "active";
      bgColor = KColors.PRIMARY.withOpacity(0.6);
    } else if (status == ProductStatus.COMPLETED_PRODUCT_STATUS) {
      text = 'completed';
      bgColor = KColors.PRIMARY;
    } else if (status == ProductStatus.DELETED_PRODUCT_STATUS) {
      text = "deleted";
      bgColor = KColors.RED;
    } else if (status == ProductStatus.BLOCKED_PRODUCT_STATUS) {
      text = "blocked";
      bgColor = KColors.RED;
    } else {
      text = "unpublished";
      bgColor = KColors.TEXT_COLOR_LIGHT;
    }

    return ButtonSmall(
      onClick: () => null,
      text: text,
      bgColor: bgColor,
      textColor: Colors.white,
      py: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.bottomSheet(ModalOptions(
        product: product,
      )),
      child: Container(
        padding: EdgeInsets.all(Constants.PADDING / 2),
        height: 300,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [Constants.SHADOW_LIGHT],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: CachedImage(
                  product.images!.length > 0 ? '${product.images!.first.imagePath}' : "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  alt: ImagePlaceholder.NoImage,
                  // color: KColors.TEXT_COLOR_LIGHT.withOpacity(.2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${product.productName}",
                    style: StyleProductTitle.copyWith(color: KColors.TEXT_COLOR_DARK),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
                _productStatus(product.productStatus!),
                Icon(
                  Icons.more_horiz,
                  color: KColors.TEXT_COLOR,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
