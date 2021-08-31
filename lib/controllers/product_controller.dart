import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/dio/error_catch.dart';
import 'package:swapxchange/repository/repo_product.dart';

class ProductController extends GetxController {
  static ProductController to = Get.find();
  int offset = 0;
  final int limit = 10;
  RxList<Product> productList = <Product>[].obs;
  RxBool isLoading = true.obs;
  Rx<ErrorResponse> apiError = ErrorResponse(message: 'Internet error', type: 0).obs;

  ScrollController? controller = ScrollController();

  String pageTitle = "";

  @override
  void onInit() {
    // fetchProducts();
    super.onInit();
  }

  void updateProduct(Product p) {
    var index = productList.indexWhere((element) => element.productId == p.productId);
    productList[index] = p;
    // productList.refresh();
    update(); // ← rebuilds any GetBuilder<TabX> widget

    // --> OR
    // var product = productList.firstWhere((element) => element.productId == p.productId);
    // product.productName = "You manh... ${p.userId}";
    // // productList.refresh();
    // update(); // ← rebuilds any GetBuilder<TabX> widget
  }

  fetchProducts() {
    isLoading(true);
    RepoProduct.getProducts(
      onSuccess: (products) {
        // productList.addAll(posts);
        productList(products);
        update();
        isLoading(false);
      },
      onError: (error) {
        isLoading(false);
        apiError.value = error;
        update();
        print(error.message.toString());
      },
    );
  }

  void fetchAll({bool reset = false}) async {
    isLoading(true);
    offset = reset ? 0 : productList.length;
    var items = await RepoProduct.findAll(offset: offset, limit: limit);
    if (items != null) {
      if (reset) productList.clear(); //Reset the list for hot reload
      productList.addAll(items);
      update();
    }
    isLoading(false);
  }

  bool handleScrollNotification(ScrollNotification notification) {
    //--> For infinite fetching...
    if (notification is ScrollEndNotification) {
      if (!isLoading.value && productList.length > 0 && productList.length >= limit) {
        if (controller!.position.extentAfter < 500) {
          fetchAll();
        }
      }
    }
    //--> For scroll  text change
    // if (notification is ScrollEndNotification) {
    if (controller!.position.extentBefore >= 200 && pageTitle == "") {
      pageTitle = "Latest";
      update();
    } else if (controller!.position.extentBefore < 200 && pageTitle.isNotEmpty) {
      pageTitle = "";
      update();
      // }
    }
    return false;
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        fetchAll();
        // print('Load more nah!!!');
        // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }
}
