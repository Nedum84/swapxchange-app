import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/coins_controller.dart';
import 'package:swapxchange/controllers/my_product_controller.dart';
import 'package:swapxchange/enum/product_state.dart';
import 'package:swapxchange/models/coins_model.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/repository/repo_product_image.dart';
import 'package:swapxchange/ui/components/custom_button.dart';
import 'package:swapxchange/ui/home/product/addproduct/select_category.dart';
import 'package:swapxchange/ui/home/product/addproduct/select_product_suggestion.dart';
import 'package:swapxchange/ui/home/product/addproduct/select_sub_category.dart';
import 'package:swapxchange/ui/home/product/addproduct/textfield_modal.dart';
import 'package:swapxchange/ui/home/product/addproduct/upload/image_listview.dart';
import 'package:swapxchange/ui/home/product/addproduct/upload/upload_home.dart';
import 'package:swapxchange/ui/home/product/addproduct/widgets/accept_policy_widget.dart';
import 'package:swapxchange/ui/home/product/addproduct/widgets/add_item.dart';
import 'package:swapxchange/ui/home/product/product_detail/product_detail.dart';
import 'package:swapxchange/ui/home/tabs/profile/sections/wallet/how_to_get_coins.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/image_upload_utilities.dart';
import 'package:swapxchange/utils/styles.dart';

class AddProduct extends GetView<AddProductController> {
  void gotoImageUpload({bool showAddImageDialog = false}) async {
    Get.to(() => UploadHome(showAddImageDialog: showAddImageDialog));
  }

  _validateAndSubmit() async {
    final CoinsModel? myCoins = CoinsController.to.myCoins!;

    if (controller.imageList.length == 0) {
      _showError('Upload at least one photo of your product');
    } else if (controller.product!.productName!.isEmpty) {
      _showError('Enter your product name');
    } else if (controller.category == null) {
      _showError('Choose your product category');
    } else if (controller.subCategory == null) {
      _showError('Choose your product sub category');
    } else if (controller.product!.price == null || controller.product!.price == 0) {
      _showError('Enter the price/value of your product');
    } else if (controller.suggestions.length == 0) {
      _showError('Enter at least one suggestions');
    } else if (!controller.isAcceptedTerms && !controller.isEditing) {
      _showError('You must accept our terms before publishing your product');
    } else if (myCoins != null && myCoins.balance! < CoinsController.uploadAmount) {
      AlertUtils.alert(
        'Insufficient balance, You must have at least ${CoinsController.uploadAmount} Coins to upload a product',
        title: 'Get Coins',
        okBtnTxt: 'GET COINS',
        okBtnCallback: () {
          Get.to(() => HowToGetCoins());
        },
      );
    } else {
      controller.setLoading(true);
      if (controller.isEditing) {
        final updateProduct = await RepoProduct.updateProduct(product: controller.product!);
        if (updateProduct != null) {
          controller.updateProduct(updateProduct);
          _updateImages(updateProduct);
        } else {
          _showError("Error occurred! try again");
        }
      } else {
        final createProduct = await RepoProduct.createProduct(product: controller.product!);
        if (createProduct != null) {
          controller.updateProduct(createProduct);
          _updateImages(createProduct);
        } else {
          _showError("Error occurred! try again");
        }
      }
    }
  }

  _showError(String er) {
    AlertUtils.toast(er);
    controller.setLoading(false);
  }

  _updateImages(Product product) async {
    // update my balance
    await CoinsController.to.getBalance();

    controller.updateImgWithProductId(product);
    //Iterate over the images
    controller.imageList.forEach((pImg) async {
      RepoProductImage.upsertProductImage(productImage: pImg).then((value) async {
        if (controller.imageList.last == pImg) {
          final newProduct = await RepoProduct.getById(productId: product.productId!);
          if (controller.isEditing) {
            MyProductController.to.updateProduct(newProduct!);
            AlertUtils.toast('Your product was successfully edited');
            //redirect after the last Image upload & reset controller to defaults
            controller.reset();
            Get.back(result: newProduct, closeOverlays: true);
          } else {
            AlertUtils.toast('Successfully published your product');
            //redirect after the last Image upload & reset controller to defaults
            controller.reset();
            Get.off(() => ProductDetail(product: newProduct!));
          }
        }
      }).catchError((error) {
        print('Error: ' + error.toString());
        controller.setLoading(false);
      });
    });
  }

  Widget _suggestedList() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      height: 24,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.suggestions.length,
        itemBuilder: (build, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            margin: EdgeInsets.only(right: 4),
            decoration: BoxDecoration(color: Colors.grey.withOpacity(.3), borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Text(controller.suggestions[index].categoryName!),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get.back(closeOverlays: true);
    return GetBuilder<AddProductController>(builder: (addController) {
      // addController.setLoading(false);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: CustomBackButton(
            color: KColors.TEXT_COLOR_DARK,
            isPositioned: false,
          ),
          title: Center(
            child: Text(
              '${(addController.isEditing) ? 'Edit' : 'New'} Product',
              style: H1Style,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: KColors.WHITE_GREY,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: 120,
                color: Colors.white,
                child: ImageListView(
                  onImageClick: (imageProduct) {
                    ImageUploadUtilities.makeImageCurrent(imageProduct);
                    gotoImageUpload(showAddImageDialog: false);
                  },
                  addImageClick: () => gotoImageUpload(showAddImageDialog: true),
                  showIndicator: false,
                ),
              ),
              SizedBox(height: 10),
              AddItem(
                onClick: () => showTextFieldModal(ProductState.productName),
                title: 'PRODUCT NAME',
                subtitle: addController.product?.productName,
              ),
              SizedBox(height: 10),
              AddItem(
                onClick: () => showTextFieldModal(ProductState.productDescription),
                title: 'DESCRIPTION',
                subtitle: (addController.product?.productDescription != null) ? addController.product!.productDescription : 'Eg. size, colour, age, etc.',
              ),
              SizedBox(height: 10),
              AddItem(
                onClick: () => showSelectCategory(),
                title: 'CATEGORY',
                subtitle: addController.category?.categoryName,
              ),
              SizedBox(height: 1),
              AddItem(
                onClick: () => showSelectSubCategory(),
                title: 'SUBCATEGORY',
                subtitle: addController.subCategory?.subCategoryName,
              ),
              SizedBox(height: 10),
              AddItem(
                onClick: () => showTextFieldModal(ProductState.price),
                title: 'PRODUCT VALUE',
                subtitle: 'Provide a realistic price and we will suggest to you relevant offers for swap. The price won\'t be shown to anybody',
                trailing: '₦${Helpers.formatMoney(cash: addController.product?.price ?? 0, withDot: false)}',
                subtitleFont: 10,
              ),
              SizedBox(
                height: 10,
              ),
              AddItem(
                onClick: () => showProductSuggestions(),
                title: 'SWAP SUGGESTIONS',
                subtitle2: (!addController.suggestions.isNotEmpty)
                    ? Text(
                        'Choose what you would like to exchange your product for',
                        style: TextStyle(fontSize: 13),
                      )
                    : _suggestedList(),
              ),
              SizedBox(height: 10),
              if (!addController.isEditing)
                AddItem(
                  onClick: () => Get.to(() => HowToGetCoins()),
                  title: 'AVAILABLE COINS',
                  subtitle: 'This upload will deduct ${CoinsController.uploadAmount} coins from your balance.',
                  subtitleFont: 10,
                  trailing: '${CoinsController.to.myCoins!.balance} Coins',
                ),
              SizedBox(height: 10),
              AcceptPolicyWidget(),
              SizedBox(height: 10),
              Center(
                child: PrimaryButton(
                  onClick: _validateAndSubmit,
                  btnText: 'Publish',
                  isLoading: controller.isLoading,
                  width: 250,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  void showTextFieldModal(ProductState productState) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
        child: TextFieldModal(productState: productState),
      ),
    ));
  }

  void showSelectCategory() {
    Get.bottomSheet(SelectCategory());
  }

  void showSelectSubCategory() {
    if (controller.category == null) return;
    Get.bottomSheet(SelectSubCategory());
  }

  //My suggestions
  void showProductSuggestions() {
    Get.bottomSheet(SelectProductSuggestion());
  }
}
