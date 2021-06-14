import 'package:get/get.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/utils/helpers.dart';

class AddProductController extends GetxController {
  static AddProductController to = Get.find();
  Product? _product;
  Category? category;
  SubCategory? subCategory;
  List<ProductImage> imageList = <ProductImage>[];
  List<Category> suggestions = <Category>[];
  bool isEditing = false;
  bool isLoading = false;
  bool isAcceptedTerms = false;

  Product? get product => _product;

  void initialize(Product product) async {
    //-> Category
    final Category? cat = await CategoryController.to.fetchById(catId: product.category!);
    if (cat != null) setCategory(cat);
    //--> Sub cat
    final SubCategory? subCat = await SubCategoryController.to.fetchById(subCatId: product.subCategory!);
    if (subCat != null) setSubCategory(subCat);
    //--> Images
    if (product.images != null) setImgList(product.images!);
    //--> Set product
    updateProduct(product);
  }

  void create() {
    final currentUser = UserController.to.user!;
    Product product = Product(
      userId: currentUser.userId,
      orderId: Helpers.genRandString(),
      userAddress: currentUser.address,
      userAddressLat: currentUser.addressLat,
      userAddressLong: currentUser.addressLong,
      userAddressCity: currentUser.state,
      price: 0,
      productStatus: ProductStatus.ACTIVE_PRODUCT_STATUS,
      images: [],
      productName: "",
      productDescription: "",
      suggestions: [],
      productSuggestion: "",
      uploadPrice: 100,
    );
    updateProduct(product);
  }

  void updateProduct(Product product) {
    _product = product;
    update();
  }

  void setImgList(List<ProductImage> pImg) {
    imageList = pImg;
    update();
  }

  //Update the product Images with the product ID
  void updateImgWithProductId(Product product) {
    List<ProductImage> newList = [];
    imageList.forEach((element) {
      element.productId = product.productId;
      newList.add(element);
    });
    imageList = newList;
    update();
  }

  void setCategory(Category cat) {
    category = cat;
    _product!.category = cat.categoryId;
    setSubCategory(null);
    update();
  }

  void setSubCategory(SubCategory? subCat) {
    subCategory = subCat;
    _product!.subCategory = subCat?.subCategoryId ?? 0;
    update();
  }

  void setEditing(bool value) {
    isEditing = value;
    update();
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  void setAcceptedTerm() {
    isAcceptedTerms = !isAcceptedTerms;
    update();
  }

  void updateSuggestions(Category category) {
    bool isSelected = suggestions.indexWhere((element) => element.categoryId == category.categoryId) != -1;
    if (isSelected) {
      suggestions.removeWhere((element) => element.categoryId == category.categoryId);
    } else {
      suggestions.add(category);
    }
    final sugs = suggestions.map((e) => e.categoryId).toString().replaceAll("(", "").replaceAll(")", "");
    _product!.productSuggestion = sugs;
    update();
  }

  void reset() {
    _product = null;
    setEditing(false);
    isAcceptedTerms = false;
    category = null;
    subCategory = null;
    suggestions = [];
    imageList = [];
    setLoading(false);
  }
}
