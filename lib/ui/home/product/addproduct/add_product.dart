import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/enum/product_state.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/ui/home/product/addproduct/upload/image_listview.dart';
import 'package:swapxchange/ui/home/product/addproduct/upload/upload_home.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/image_upload_utilities.dart';
import 'package:swopswap/enum/product_state.dart';
import 'package:swopswap/extention/strings_extention.dart';
import 'package:swopswap/models/category.dart';
import 'package:swopswap/models/image_product.dart';
import 'package:swopswap/models/product.dart';
import 'package:swopswap/models/sub_category.dart';
import 'package:swopswap/provider/product_provider.dart';
import 'package:swopswap/provider/user_provider.dart';
import 'package:swopswap/repository/category_methods.dart';
import 'package:swopswap/repository/image_methods.dart';
import 'package:swopswap/repository/product_methods.dart';
import 'package:swopswap/screens/add_product/select_category.dart';
import 'package:swopswap/screens/add_product/select_product_suggestion.dart';
import 'package:swopswap/screens/add_product/select_sub_category.dart';
import 'package:swopswap/screens/add_product/textfield_modal.dart';
import 'package:swopswap/screens/add_product/upload/image_listview.dart';
import 'package:swopswap/screens/add_product/upload/upload_home.dart';
import 'package:swopswap/screens/view_product/view_product.dart';
import 'package:swopswap/screens/widgets/loading_spinner.dart';
import 'package:swopswap/utils/alert_utils.dart';
import 'package:swopswap/utils/colors.dart';
import 'package:swopswap/utils/image_upload_utilities.dart';
import 'package:swopswap/utils/utilities.dart';

class AddProduct extends StatefulWidget {
  AddProduct({this.isEditing = false, this.product});

  final bool isEditing;
  final Product? product;

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  UserController userProvider = UserController.to;
  Product? product;
  AddProductController addController = AddProductController.to;
  List<ProductImage> imageProducts = [];
  Category _category;
  SubCategory _subCategory;
  List<Category> _productSuggestions = [];
  bool _acceptedTerms = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  _initialize() async {
    if (!widget.isEditing) {
      addController.create();
    } else {
      addController.updateProduct(widget.product!);
    }
  }

  void gotoImageUpload({bool showAddImageDialog = false}) async {
    var newImgList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadHome(
          imageProducts: imageProducts,
          showAddImageDialog: showAddImageDialog,
        ),
      ),
    );
    if (newImgList != null) {
      setState(() {
        imageProducts = newImgList;
      });
    }
  }

  _validateDetails() async {
    setState(() => showSpinner = true);

    if (imageProducts.length == 0) {
      _showError('Upload at least one photo of your product');
    } else if (product.productName.isEmptyString()) {
      _showError('Enter your product name');
    } else if (_category == null) {
      _showError('Choose your product category');
    } else if (_subCategory == null) {
      _showError('Choose your product sub category');
    } else if (product.price == null || product.price == 0) {
      _showError('Enter the price/value of your product');
    } else if (!_acceptedTerms && !widget.isEditing) {
      _showError('You must accept our terms before publishing your product');
    } else {
      // if(await ImageMethods.uploadMultipleImageProduct(imageProducts: imageProducts)){
      //   product.category = _category.categoryId;
      //   product.subCategory = _subCategory.subCategoryId;
      //   product.productSuggestion = _productSuggestions.map((e) => e.categoryId).toString();
      //   product.timestamp = (!widget.isEditing)?DateTime.now().microsecondsSinceEpoch : product.timestamp;
      //   product.userId = '698690cv';
      //   ProductMethods.postProduct(product: product).then((value){
      //     if(value) _showError('Successfully published your product');
      //   }).catchError((er) => print(er));
      // }

      setState(() => showSpinner = true);
      imageProducts.forEach((imageProduct) async {
        ImageMethods.uploadSingleImageProduct(imageProduct: imageProduct).then((value) {
          if (imageProducts.last == imageProduct) {
            //Submit after the last Image upload
            product.category = _category.categoryId;
            product.subCategory = _subCategory.subCategoryId;
            product.productSuggestion = (_productSuggestions.isNotEmpty) ? _productSuggestions.map((e) => e.categoryId).toString() : "";
            product.timestamp = (!widget.isEditing) ? DateTime.now().microsecondsSinceEpoch : product.timestamp;
            product.userId = userProvider.getUser.uid;
            product.productDescription = (productProvider.product.productDescription.isEmptyString()) ? '' : productProvider.product.productDescription;
            product.userAddress = userProvider.getUser.address;
            product.userAddressLat = userProvider.getUser.addressLat;
            product.userAddressLong = userProvider.getUser.addressLong;
            product.productCondition = ProductCondition.FAIRLY_USED;
            product.productStatus = ProductStatus.ACTIVE;

            ProductMethods.postProduct(product: product).then((value) {
              if (value) {
                setState(() => showSpinner = false);

                if (widget.isEditing) {
                  AlertUtils.toast('Your product was successfully edited');
                  Navigator.pop(context, product);
                } else {
                  AlertUtils.toast('Successfully published your product');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProduct(
                        product: product,
                      ),
                    ),
                  );
                }
              }
            }).catchError((er) {
              print(er);
              setState(() => showSpinner = false);
            });
          }
        }).catchError((error) {
          print('Error: ' + error.toString());
          setState(() => showSpinner = false);
        });
      });
    }
  }

  _showError(String er) {
    AlertUtils.alert(er, context: context);
    setState(() => showSpinner = false);
  }

  Widget _suggestedList() {
    return Container(
      margin: EdgeInsets.only(top: 4),
      height: 24,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _productSuggestions.length,
        itemBuilder: (build, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            margin: EdgeInsets.only(right: 4),
            decoration: BoxDecoration(color: Colors.grey.withOpacity(.3), borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Text(_productSuggestions[index].categoryName),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: Colors.blueGrey,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          MaterialButton(
            onPressed: () => _validateDetails(),
            child: Row(
              children: [
                Text(
                  'Publish',
                  style: TextStyle(color: Colors.blueGrey),
                ),
                Icon(Icons.check, color: Colors.blueGrey)
              ],
            ),
          )
        ],
        title: Center(
          child: Text(
            '${(widget.isEditing) ? 'Edit' : 'New'} Product',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blueGrey[100]!.withOpacity(0.6),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: 120,
              color: Colors.white,
              child: ImageListView(
                imageProducts: imageProducts,
                onImageClick: (imageProduct) {
                  imageProducts = ImageUploadUtilities.makeImageCurrent(imageProduct, imageProducts);
                  gotoImageUpload(showAddImageDialog: false);
                },
                addImageClick: () => gotoImageUpload(showAddImageDialog: true),
                showIndicator: false,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                onTap: () => showTextFieldModal(ProductState.productName),
                title: Text('What do you want to swap?'),
                subtitle: (!product.productName!.isEmptyString())
                    ? Text(
                        product.productName,
                      )
                    : null,
                trailing: Icon(Icons.analytics_outlined, color: Colors.blueGrey[800]!.withOpacity(0.4)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                onTap: () => showSelectCategory(),
                title: Text('Category'),
                subtitle: (_category != null)
                    ? Text(
                        _category.categoryName!,
                      )
                    : null,
                trailing: Icon(Icons.arrow_right_alt, color: Colors.blueGrey[800]!.withOpacity(0.4)),
              ),
            ),
            SizedBox(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                onTap: () => showSelectSubCategory(),
                title: Text('Sub Category'),
                subtitle: (_subCategory != null)
                    ? Text(
                        //only show when not empty(or 0)
                        _subCategory.subCategoryName!,
                      )
                    : null,
                trailing: Icon(Icons.arrow_right_alt, color: Colors.blueGrey[800]!.withOpacity(0.4)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              color: Colors.white,
              child: ListTile(
                onTap: () => showTextFieldModal(ProductState.price),
                title: Text('Price'),
                subtitle: Text(
                  'Provide a realistic price and we will suggest to you relevant offers for swap. The price won\'t be shown to anybody',
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Text(
                  (product.price != 0 && product.price != null) ? '₦${product.price}' : '₦',
                  style: TextStyle(color: Colors.blueGrey[800]!.withOpacity(0.4)),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              color: Colors.white,
              child: ListTile(
                onTap: () => showTextFieldModal(ProductState.productDescription),
                title: Text('Describe your product'),
                subtitle: Text(
                  (!product.productDescription.isEmptyString()) ? product.productDescription : 'Eg. size, colour, age, etc.',
                  style: TextStyle(fontSize: 13),
                ),
                trailing: Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.blueGrey[800].withOpacity(0.4)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              color: Colors.white,
              child: ListTile(
                onTap: () => showProductSuggestions(),
                title: Text('Send Suggestion'),
                subtitle: (!_productSuggestions.isNotEmpty)
                    ? Text(
                        'Choose what you would like to exchange your product for',
                        style: TextStyle(fontSize: 13),
                      )
                    : _suggestedList(),
                trailing: Icon(Icons.margin, color: Colors.blueGrey[800].withOpacity(0.4)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (!widget.isEditing)
              ListTile(
                leading: Checkbox(
                  activeColor: kColorAccent,
                  value: _acceptedTerms,
                  onChanged: (newVal) {
                    setState(() {
                      _acceptedTerms = !_acceptedTerms;
                    });
                  },
                ),
                title: Text.rich(
                  TextSpan(
                    text: 'By publishing your product, you agree to our ',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Ad submission rule',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                      TextSpan(text: ' and ', style: TextStyle()),
                      TextSpan(
                          text: 'Prohibited Products',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          )),
                      // can add more TextSpans here...
                    ],
                  ),
                  style: TextStyle(
                      // color: kColorAsh
                      ),
                ),
              ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: GestureDetector(
                onTap: () => _validateDetails(),
                child: Container(
                  width: 250,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.00)),
                    color: kColorPrimary,
                  ),
                  child: Text(
                    'Publish',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void showTextFieldModal(ProductState productState) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TextFieldModal(productState: productState),
            )));
  }

  void showSelectCategory() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SelectCategory(
              currentCategory: _category,
              selectedCategory: (selectedCategory) {
                setState(() {
                  _category = selectedCategory;
                  _subCategory = null;
                });
                Navigator.of(context).pop();
              },
            ));
  }

  void showSelectSubCategory() {
    if (_category == null) return;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SelectSubCategory(
              currentCategory: _category,
              currentSubCategory: _subCategory,
              selectedSubCategory: (selectedSubCategory) {
                setState(() {
                  _subCategory = selectedSubCategory;
                });
                Navigator.of(context).pop();
              },
            ));
  }

  //My suggestions
  void showProductSuggestions() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => SelectProductSuggestion(
              productSuggestions: _productSuggestions,
              updatedSuggestions: (suggestions) {
                setState(() {
                  _productSuggestions = suggestions; //Optional since the original list send to the dialog is being update real time
                });
                Navigator.of(context).pop();
              },
            ));
  }
}
