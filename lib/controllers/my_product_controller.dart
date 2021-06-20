import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/dio/error_catch.dart';
import 'package:swapxchange/repository/repo_product.dart';

class MyProductController extends GetxController {
  static MyProductController to = Get.find();
  int offset = 0;
  final int limit = 10;
  RxList<Product> productList = <Product>[].obs;
  RxBool isLoading = true.obs;
  Rx<ErrorResponse> apiError = ErrorResponse(message: 'Internet error', type: 0).obs;

  ScrollController? controller = ScrollController();

  @override
  void onInit() {
    fetchAll();
    super.onInit();
  }

  void updateProduct(Product p) {
    var index = productList.indexWhere((element) => element.productId == p.productId);
    productList[index] = p;
    update();
  }

  void removeProduct(Product p) {
    productList.removeWhere((element) => element.productId == p.productId);
    update();
  }

  void fetchAll({bool reset = false}) async {
    isLoading(true);
    offset = reset ? 0 : productList.length;
    var items = await RepoProduct.findMyProducts(offset: offset, limit: limit);
    if (items!.length != 0) {
      if (reset) productList.clear(); //Reset the list for hot reload
      productList.addAll(items);
      update();
    }
    isLoading(false);
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (!isLoading.value) {
        if (controller!.position.extentAfter < 500) {
          fetchAll();
        }
      }
    }
    return false;
  }
}
