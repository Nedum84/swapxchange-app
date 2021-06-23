import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/bottom_menu_controller.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/controllers/coins_controller.dart';
import 'package:swapxchange/controllers/my_product_controller.dart';
import 'package:swapxchange/controllers/product_controller.dart';
import 'package:swapxchange/controllers/product_search_controller.dart';
import 'package:swapxchange/controllers/saved_product_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/controllers/user_controller.dart';

class AllControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductController(), permanent: true);
    Get.put(MyProductController(), permanent: true);
    Get.put(SavedProductController(), permanent: true);
    Get.lazyPut<BottomMenuController>(() => BottomMenuController());
    Get.put(SubCategoryController(), permanent: true);
    Get.put(CategoryController(), permanent: true);
    Get.put(UserController(), permanent: true);
    Get.put(ProductSearchController(), permanent: true);
    Get.put(AddProductController(), permanent: true);
    Get.put(CoinsController(), permanent: true);
  }
}
