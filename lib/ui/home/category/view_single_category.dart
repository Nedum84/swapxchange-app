import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/repository/repo_product.dart';
import 'package:swapxchange/ui/components/custom_appbar.dart';
import 'package:swapxchange/ui/components/product_item.dart';
import 'package:swapxchange/ui/home/search/search_filters_container.dart';
import 'package:swapxchange/ui/widgets/no_data_found.dart';
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
    _fetchProducts();
    super.initState();
  }

  _setSubCategoryList() async {
    final getList = await subCategoryController.fetchByCategoryId(catId: widget.category.categoryId!);
    setState(() {
      selectedSubCategory = getList[0];
      subCategoryList = getList;
    });
  }

  _fetchProducts() async {
    setState(() => isLoading = true);
    offset = products.length;
    if (subCategoryList.length == 0) await _setSubCategoryList(); //Fetch subcategory list(s before proceeding...
    final items = await RepoProduct.findBySubCategory(subCatId: selectedSubCategory!.subCategoryId!, offset: offset, limit: limit);
    if (items!.isNotEmpty) products.addAll(items);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(Constants.PADDING).copyWith(top: context.mediaQueryPadding.top),
        child: Column(
          children: [
            CustomAppbar(title: widget.category.categoryName!),
            Container(
              height: 40,
              child: (subCategoryList.length == 0)
                  ? Container()
                  : ListView.separated(
                      itemCount: subCategoryList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final subCat = subCategoryList[index];

                        Color textColor = selectedSubCategory == subCat ? KColors.PRIMARY : KColors.TEXT_COLOR.withOpacity(.6);
                        return SearchFilterItem(
                          textColor: textColor,
                          text: subCat.subCategoryName?.toUpperCase() ?? "",
                          onClick: () {
                            setState(() {
                              selectedSubCategory = subCat;
                              products.clear();
                            });
                            _fetchProducts();
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
                                child: CircularProgressIndicator(),
                              )
                            : NoDataFound(
                                btnText: 'Refresh',
                                subTitle: 'No product found',
                                onBtnClick: _fetchProducts,
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
          _fetchProducts();
        }
      }
    }
    return false;
  }
}
