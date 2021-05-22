import 'package:get/get.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/dio/error_catch.dart';
import 'package:swapxchange/repository/repo_product.dart';

class ProductController extends GetxController {
  static ProductController to = Get.find();
  final int pageSize = 10;
  RxList<Product> productList = <Product>[].obs;
  RxBool isLoading = true.obs;
  Rx<ErrorResponse> apiError = ErrorResponse(message: 'Internet error', type: 0).obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void updateProduct(int index, Product p) {
    var index = productList.indexWhere((element) => element.productId == p.productId);
    // productList[index] = p;
    productList[index].productName = "You manh ${p.userId}";
    productList.refresh();
    // update(); // ← rebuilds any GetBuilder<TabX> widget
  }

  fetchProducts() {
    isLoading(true);
    RepoProduct.getProducts(
      onSuccess: (products) {
        // productList.addAll(posts);
        productList(products);
        isLoading(false);
      },
      onError: (error) {
        isLoading.value = false;
        apiError.value = error;
        print(error.message.toString());
      },
    );
  }

  Future<List<Product>> fetchAll({int offset = 0, int limit = 10}) async {
    var items = await RepoProduct.findAll(offset: offset, limit: limit);
    if (items!.length == 0) [];
    return (items);
  }
}
