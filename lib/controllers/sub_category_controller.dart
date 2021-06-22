import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/repository/repo_sub_category.dart';

class SubCategoryController extends GetxController {
  static SubCategoryController to = Get.find();
  RxList<SubCategory> subCategoryList = <SubCategory>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  void setItems({required List<SubCategory> items}) {
    subCategoryList(items);
  }

  void fetch() async {
    isLoading(true);
    var items = await RepoSubCategory.findAll();
    if (items!.isNotEmpty) subCategoryList(items);
    isLoading(false);
  }

  Future<List<SubCategory>> fetchByCategoryId({required int catId}) async {
    List<SubCategory> list = [];
    List<SubCategory>? items = [];
    items = subCategoryList.where((element) => element.categoryId == catId).toList();
    if (items.length == 0) {
      items = await RepoSubCategory.findByCategoryId(catId: catId);
    }
    if (items!.isNotEmpty) list = items;
    update();
    return list;
  }

  Future<SubCategory?> fetchById({required int subCatId}) async {
    SubCategory? subCategory;
    var item;
    item = subCategoryList.firstWhereOrNull((element) => element.subCategoryId == subCatId);
    if (item == null) {
      item = await RepoSubCategory.getSubCategoryById(subCatId: subCatId);
    }
    if (item != null) subCategory = item;

    return subCategory;
  }
}
