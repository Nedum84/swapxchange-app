import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/repository/repo_product_search.dart';

class ProductSearchController extends GetxController {
  static ProductSearchController to = Get.find();
  int offset = 0;
  final int limit = 10;
  RxList<Product> productList = <Product>[].obs;
  RxBool isLoading = true.obs;
  RxBool resetList = false.obs;
  RxString queryString = "".obs;
  RxBool hideSearchSuggestion = true.obs;
  RxList searchSuggestions = [].obs;
  RxString searchFilter = SearchFilters.BEST_MATCH.obs;

  ScrollController? controller = ScrollController(keepScrollOffset: true);
  FocusNode textFieldFocus = FocusNode();
  TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    textController.text = queryString.value;
    resetList(true);
    // fetchProducts();
    super.onInit();
  }

  setQueryString(str) {
    queryString(str);
    update();
    _getSuggestions();
  }

  _getSuggestions() async {
    List<String>? list = [];
    if (queryString.value.isEmpty) {
      hideSearchSuggestion(true);
      update();
    } else {
      list = await RepoProductSearch.findSearchSuggestions(query: queryString.value);
      if (list.length != 0) hideSearchSuggestion(false);
      update();
    }
    searchSuggestions(list);
    update();
  }

  void fetchProducts() async {
    hideSearchSuggestion(true);
    isLoading(true);
    offset = resetList.value ? 0 : productList.length;
    String query = queryString.value.isEmpty ? "none" : queryString.value;
    var items = await RepoProductSearch.findBySearch(query: query, filters: searchFilter.value, offset: offset, limit: limit);
    if (items!.length != 0) {
      if (resetList.value) {
        productList(items);
      } else {
        productList.addAll(items);
      }
    }
    isLoading(false);
    update();
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (!isLoading.value) {
        if (before == max) {
          resetList(false);
          fetchProducts();
        }
      }
    }
    return false;
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (!isLoading.value && productList.length > 0) {
        if (controller!.position.extentAfter < 500) {
          resetList(false);
          fetchProducts();
        }
      }
    }
    return false;
  }

  final List<String> filters = [
    SearchFilters.BEST_MATCH,
    SearchFilters.NEWEST,
    SearchFilters.OLDEST,
    SearchFilters.PRICE_HIGH,
    SearchFilters.PRICE_LOW,
  ];
}

class SearchFilters {
  static const String BEST_MATCH = "best-match";
  static const String PRICE_HIGH = "price-high";
  static const String PRICE_LOW = "price-low";
  static const String NEWEST = "newest";
  static const String OLDEST = "oldest";
}
