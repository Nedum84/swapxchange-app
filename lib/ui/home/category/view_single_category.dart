import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/ui/home/search/search_filters_container.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';
import 'package:swapxchange/ui/widgets/no_data_found.dart';
import 'package:swapxchange/ui/widgets/product_item.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';

class ViewSingleCategory extends StatefulWidget {
  final Category category;
  const ViewSingleCategory({Key? key, required this.category}) : super(key: key);

  @override
  _ViewSingleCategoryState createState() => _ViewSingleCategoryState();
}

class _ViewSingleCategoryState extends State<ViewSingleCategory> {
  SubCategoryController subCategoryController = SubCategoryController.to;
  bool isLoading = false;
  int limit = 10;
  int offset = 0;
  List<Product> products = [];
  List<SubCategory> subCategoryList = [];
  SubCategory? selectedSubCategory;

  ScrollController? controller = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    _fetchProductsCats();
    super.initState();
  }

  _setSubCategoryList() async {
    final getList = await subCategoryController.fetchByCategoryId(catId: widget.category.categoryId!);
    if (getList.length > 0)
      setState(() {
        // selectedSubCategory = getList[0];
        subCategoryList = getList;
      });
  }

  _fetchProductsSubCats() async {
    setState(() => isLoading = true);
    offset = products.length;
    if (subCategoryList.length == 0) await _setSubCategoryList(); //Fetch subcategory list(s before proceeding...

    // If there's no sub category, return oooo...
    if (subCategoryList.isEmpty) {
      setState(() => isLoading = false);
      return;
    }
    final items = await RepoProduct.findBySubCategory(subCatId: selectedSubCategory!.subCategoryId!, offset: offset, limit: limit);
    if (items!.isNotEmpty) products.addAll(items);

    setState(() => isLoading = false);
  }

  _fetchProductsCats() async {
    setState(() => isLoading = true);
    offset = products.length;
    if (subCategoryList.length == 0) await _setSubCategoryList(); //Fetch subcategory list(s before proceeding...

    final items = await RepoProduct.findByCategory(catId: widget.category.categoryId!, offset: offset, limit: limit);
    if (items!.isNotEmpty) products.addAll(items);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants.APPBAR_HEIGHT),
        child: CustomAppbar(
          makeTransparent: true,
          title: widget.category.categoryName!,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Constants.PADDING),
        child: Column(
          children: [
            Container(
              height: 40,
              child: (subCategoryList.length == 0)
                  ? Container()
                  : ListView.separated(
                      itemCount: subCategoryList.length + 1,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        SubCategory? subCat;

                        Color textColor;
                        if (index == 0) {
                          textColor = selectedSubCategory == null ? KColors.PRIMARY : KColors.TEXT_COLOR.withOpacity(.6);
                        } else {
                          subCat = subCategoryList[index - 1];
                          textColor = selectedSubCategory == subCat ? KColors.PRIMARY : KColors.TEXT_COLOR.withOpacity(.6);
                        }
                        return index == 0
                            ? SearchFilterItem(
                                textColor: textColor,
                                text: "ALL",
                                onClick: () {
                                  setState(() {
                                    selectedSubCategory = null;
                                    products.clear();
                                  });
                                  _fetchProductsCats();
                                },
                              )
                            : SearchFilterItem(
                                textColor: textColor,
                                text: subCat?.subCategoryName?.toUpperCase() ?? "",
                                onClick: () {
                                  setState(() {
                                    selectedSubCategory = subCat;
                                    products.clear();
                                  });
                                  _fetchProductsSubCats();
                                },
                              );
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(width: 16),
                    ),
            ),
            Expanded(
              child: (products.length != 0)
                  ? NotificationListener(
                      onNotification: handleScrollNotification,
                      child: GridView.builder(
                        controller: controller,
                        padding: EdgeInsets.all(0),
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 0,
                        ),
                        itemBuilder: (context, index) {
                          return ProductItem(product: products[index]);
                        },
                      ),
                    )
                  : Container(
                      child: Center(
                        child: (isLoading)
                            ? Padding(
                                padding: EdgeInsets.all(16.0),
                                child: LoadingProgressMultiColor(),
                              )
                            : NoDataFound(
                                btnText: 'Refresh',
                                subTitle: 'No product found',
                                onBtnClick: _fetchProductsSubCats,
                              ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (!isLoading) {
        if (controller!.position.extentAfter < 500) {
          _fetchProductsSubCats();
        }
      }
    }
    return false;
  }
}
