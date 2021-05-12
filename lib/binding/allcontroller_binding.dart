import 'package:get/get.dart';
import 'package:swapxchange/controllers/bottom_menu_controller.dart';
import 'package:swapxchange/controllers/product_controller.dart';

class AllControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
    Get.lazyPut<BottomMenuController>(() => BottomMenuController());
  }
}
