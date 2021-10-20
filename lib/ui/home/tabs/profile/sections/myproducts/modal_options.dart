import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/my_product_controller.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/ui/home/product/addproduct/add_product.dart';
import 'package:swapxchange/ui/home/product/addproduct/widgets/bottomsheet_container.dart';
import 'package:swapxchange/ui/home/product/product_detail/product_detail.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class ModalOptions extends StatelessWidget {
  final Product product;

  const ModalOptions({Key? key, required this.product}) : super(key: key);

  _onEdit() async {
    AddProductController.to.setEditing(true);
    AddProductController.to.initialize(product);
    Get.back();
    await Get.to(() => AddProduct());
    AddProductController.to.reset();
  }

  _onDelete() {
    AlertUtils.confirm(
      'This will permanently remove this product from your listing',
      title: 'Delete Product!',
      positiveBtnText: 'DELETE',
      okCallBack: () async {
        product.productStatus = ProductStatus.DELETED_PRODUCT_STATUS;
        AlertUtils.showProgressDialog(title: 'Deleting...');
        final updateProduct = await RepoProduct.updateProduct(product: product);
        AlertUtils.hideProgressDialog();
        if (updateProduct != null) {
          AlertUtils.toast('Product deleted');
          Get.back();
          MyProductController.to.removeProduct(product);
        }
      },
    );
  }

  _onUnPublish() {
    AlertUtils.confirm(
      'This will temporarily hide this product from your public listing until you decide to publish it again',
      title: 'Hide Product!',
      positiveBtnText: 'PROCEED',
      okCallBack: () async {
        product.productStatus = ProductStatus.UNPUBLISHED_PRODUCT_STATUS;
        AlertUtils.showProgressDialog(title: 'Processing...');
        final updateProduct = await RepoProduct.updateProduct(product: product);
        AlertUtils.hideProgressDialog();
        if (updateProduct != null) {
          AlertUtils.toast('Product unpublished temporarily');
          Get.back();
          MyProductController.to.updateProduct(product);
        }
      },
    );
  }

  _onPublish() {
    AlertUtils.confirm(
      'This will make your product publicly visible for swap/sell',
      title: 'Publish Product!',
      positiveBtnText: 'PUBLISH',
      okCallBack: () async {
        product.productStatus = ProductStatus.ACTIVE_PRODUCT_STATUS;
        AlertUtils.showProgressDialog(title: 'Processing...');
        final updateProduct = await RepoProduct.updateProduct(product: product);
        AlertUtils.hideProgressDialog();
        if (updateProduct != null) {
          AlertUtils.toast('Product published successfully');
          Get.back();
          MyProductController.to.updateProduct(product);
        }
      },
    );
  }

  _onMarkSold() {
    AlertUtils.confirm(
      'By clicking on PROCEED, you agree that you have successfully sold/exchanged your product on SwapXchange.',
      title: 'Confirm!',
      positiveBtnText: 'PROCEED',
      okCallBack: () async {
        product.productStatus = ProductStatus.COMPLETED_PRODUCT_STATUS;
        AlertUtils.showProgressDialog(title: 'Confirming...');
        final updateProduct = await RepoProduct.updateProduct(product: product);
        AlertUtils.hideProgressDialog();
        if (updateProduct != null) {
          AlertUtils.toast('Product sold successfully');
          Get.back();
          MyProductController.to.updateProduct(product);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      title: 'Quick Actions',
      child: Expanded(
        child: ListView(
          children: [
            OptionsItem(
              title: "View product",
              icon: Icons.preview,
              onClick: () {
                Get.back();
                Get.to(() => ProductDetail(product: product));
              },
            ),
            //Product not blocked and not completed
            if (product.productStatus != ProductStatus.BLOCKED_PRODUCT_STATUS && product.productStatus != ProductStatus.COMPLETED_PRODUCT_STATUS)
              OptionsItem(
                title: "Edit product",
                icon: Icons.edit,
                onClick: _onEdit,
              ),
            if (product.productStatus != ProductStatus.COMPLETED_PRODUCT_STATUS)
              OptionsItem(
                title: "Delete product",
                icon: Icons.delete,
                onClick: _onDelete,
              ),
            //Product not blocked, not completed and active
            if (product.productStatus != ProductStatus.BLOCKED_PRODUCT_STATUS && product.productStatus != ProductStatus.COMPLETED_PRODUCT_STATUS)
              if (product.productStatus == ProductStatus.ACTIVE_PRODUCT_STATUS)
                OptionsItem(
                  title: "Unpublish/Hide product",
                  icon: Icons.padding,
                  onClick: _onUnPublish,
                ),
            //Product not blocked, not completed and not active
            if (product.productStatus != ProductStatus.BLOCKED_PRODUCT_STATUS && product.productStatus != ProductStatus.COMPLETED_PRODUCT_STATUS)
              if (product.productStatus == ProductStatus.UNPUBLISHED_PRODUCT_STATUS)
                OptionsItem(
                  title: "Publish product",
                  icon: Icons.padding,
                  onClick: _onPublish,
                ),
            //Product not blocked, not completed and active
            if (product.productStatus != ProductStatus.BLOCKED_PRODUCT_STATUS && product.productStatus != ProductStatus.COMPLETED_PRODUCT_STATUS)
              if (product.productStatus == ProductStatus.ACTIVE_PRODUCT_STATUS)
                OptionsItem(
                  title: "Mark product as Sold",
                  icon: Icons.compass_calibration,
                  onClick: _onMarkSold,
                ),
          ],
        ),
      ),
    );
  }
}

class OptionsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onClick;

  const OptionsItem({Key? key, required this.title, required this.icon, required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onClick,
      trailing: Icon(
        icon,
        color: KColors.TEXT_COLOR_DARK,
      ),
      title: Text(
        title,
        style: StyleNormal.copyWith(fontSize: 16, color: KColors.TEXT_COLOR_DARK),
      ),
    );
  }
}
