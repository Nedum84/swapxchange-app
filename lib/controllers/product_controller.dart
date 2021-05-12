import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/ui/repository/repo_product.dart';

class ProductController extends GetxController {
  RxList<Product> productList = <Product>[].obs;
  // List<Product> postsList = List<Product>().obs;
  RxBool isLoading = true.obs;
  Rx<ErrorResponse> apiError =
      ErrorResponse(message: 'Internet error', type: 0).obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void updateProduct(int index, Product p) {
    var product = productList.firstWhere((element) => element.id == p.id);

    var product2 = productList[index];
    product.userId = Random().nextInt(123434343);
    product.title = "You manh ${product.userId}";
    productList.refresh();
    // update(); // ← rebuilds any GetBuilder<TabX> widget
  }

  StreamController<List<Product>> _streamController =
      StreamController<List<Product>>();
  @override
  onClose() {
    _streamController.sink;
  }

  fetchProducts() {
    productList.bindStream(_streamController.stream);

    isLoading(true);
    RepoProduct.getProducts(
      onSuccess: (posts) {
        // productList.addAll(posts);
        productList(posts);
        isLoading.value = false;
        // isLoading(false);
      },
      onError: (error) {
        isLoading.value = false;
        apiError.value = error;
        print(error.message.toString());
      },
    );
  }

  RxInt _inc = 2.obs;
  int get inc => _inc.value;
  void increment() => _inc++;
}
