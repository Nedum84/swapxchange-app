import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:swapxchange/extensions/list_extensions.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/repository/repo_category.dart';

class CategoryController extends GetxController {
  static CategoryController to = Get.find();
  RxList<Category> categoryList = <Category>[].obs;
  RxBool isLoading = true.obs;

  void fetch() async {
    isLoading(true);
    var items = await RepoCategory.findAll();
    if (items!.isNotEmpty) categoryList(items);
    isLoading(false);
  }

  void setItems({required List<Category> items}) {
    categoryList(items);
  }

  Future<Category?> fetchById({required int catId}) async {
    Category? category;
    var item;
    item = categoryList.value.firstWhereOrNull((element) => element.categoryId == catId);
    if (item == null) {
      item = await RepoCategory.getCategoryById(catId: catId);
    }
    if (item != null) category = item;

    return category;
  }

  List<Category> hotDeals() {
    return categoryList.sortedDescBy((it) => it.noOfProducts!).toList();
  }

  void sort() {
    //---> ASC
    categoryList.value.sort((a, b) => a.categoryId!.compareTo(b.categoryId!));
    //---> DESC
    categoryList.value.sort((a, b) => b.categoryId!.compareTo(a.categoryId!));
    categoryList.value.sortedAscBy((it) => it.categoryId!);
    categoryList.value.sortedDescBy((it) => it.categoryId!);
  }
}
