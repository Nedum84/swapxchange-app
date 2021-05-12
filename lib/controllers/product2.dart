import 'package:get/get.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/ui/repository/repo_product.dart';

class PostsController extends GetxController {
  List<Product> postsList = [];
  bool isLoading = true;
  @override
  void onInit() {
    RepoProduct.getProducts(
      onSuccess: (posts) {
        postsList.addAll(posts);
        isLoading = false;
        update();
      },
      onError: (error) {
        isLoading = false;
        update();
        print("Error");
      },
    );
    super.onInit();
  }
}
