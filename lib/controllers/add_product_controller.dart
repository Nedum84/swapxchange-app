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
  Rx<Product> _product = Product().obs;
  Rx<Category> category = Category().obs;
  Rx<SubCategory> subCategory = SubCategory().obs;
  RxList<ProductImage> imageList = <ProductImage>[].obs;
  RxList<Category> suggestions = <Category>[].obs;

  Rx<Product> get product => _product;

  void initialize(Product product) async {
    //-> Category
    final Category? cat = await CategoryController.to.fetchById(catId: product.category!);
    if (cat != null) category(cat);
    //--> Sub cat
    final SubCategory? subCat = await SubCategoryController.to.fetchById(subCatId: product.subCategory!);
    if (subCat != null) subCategory(subCat);
    //--> Images
    imageList(product.images);
    //--> Set product
    _product(product);
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
    );
    _product(product);
  }

  void updateProduct(Product product) {
    _product(product);
    update();
  }

  Future<Product?> fetchById({required int catId}) async {
    // Product? p;
    // var item;
    // item = categoryList.value.firstWhereOrNull((element) => element.categoryId == catId);
    // if (item == null) {
    //   item = await RepoAddProduct.getAddProductById(catId: catId);
    // }
    // if (item != null) category = item;
    //
    // return category;
  }
}
