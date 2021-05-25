import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

import 'category_col.dart';
import 'sub_category_col.dart';

class BrowseCategory extends StatefulWidget {
  @override
  _BrowseCategoryState createState() => _BrowseCategoryState();
}

class _BrowseCategoryState extends State<BrowseCategory> {
  SubCategoryController subCategoryController = SubCategoryController.to;
  CategoryController categoryController = CategoryController.to;
  bool isLoading = false;
  List<Category> categories = [];
  List<SubCategory> subCategoryList = [];
  Category? selectedCategory;

  ScrollController? controller = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    _fetchCategories();
    super.initState();
  }

  _fetchSubCategoryList() async {
    final getList = await subCategoryController.fetchByCategoryId(catId: selectedCategory!.categoryId!);
    setState(() => subCategoryList = getList);
  }

  _fetchCategories() async {
    setState(() => isLoading = true);
    final items = await categoryController.categoryList;
    selectedCategory = items[0];
    if (items.isNotEmpty) categories.addAll(items);

    if (categories.length != 0) await _fetchSubCategoryList(); //Fetch subcategory list(s before proceeding...

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Text(
          'Categories',
          style: H1Style,
        ),
        leading: null,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          )
        ],
      ),
      body: (categories.length == 0)
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(Constants.PADDING),
              child: SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: CategoryCol(
                          categories: categories,
                          selected: selectedCategory!,
                          onSelect: (sel) {
                            setState(() => selectedCategory = sel);
                            _fetchSubCategoryList();
                          }),
                    ),
                    SizedBox(width: 16),
                    Flexible(
                      flex: 5,
                      child: SubCategoryCol(subCats: subCategoryList),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
