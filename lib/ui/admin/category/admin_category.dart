import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/repository/repo_category.dart';
import 'package:swapxchange/ui/admin/category/add_category.dart';
import 'package:swapxchange/ui/admin/subcategory/admin_subcategory.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';

class AdminCategory extends StatefulWidget {
  @override
  _AdminCategoryState createState() => _AdminCategoryState();
}

class _AdminCategoryState extends State<AdminCategory> {
  List<Category> categories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  void _fetchData() async {
    if (categories.length == 0) setState(() => isLoading = true);
    final data = await RepoCategory.findAll();
    if (data != null) {
      categories.clear();
      categories.addAll(data);
    }
    setState(() => isLoading = false);
  }

  _gotoAddCategory({Category? category}) async {
    final goto = await Get.to(() => AddCategory(category: category));
    if (goto != null) {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants.APPBAR_HEIGHT),
        child: CustomAppbar(
          makeTransparent: true,
          title: 'Categories',
          actionBtn: [
            IconButton(
              onPressed: _gotoAddCategory,
              icon: Icon(Icons.add, color: KColors.TEXT_COLOR_DARK),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchData(),
        color: KColors.PRIMARY,
        strokeWidth: 3,
        child: Container(
          child: isLoading && categories.length == 0
              ? Center(child: LoadingProgressMultiColor())
              : categories.length == 0
                  ? Center(child: Text('No category found'))
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final item = categories[index];

                        return Container(
                          color: Colors.white,
                          child: ListTile(
                            onTap: () => Get.to(() => AdminSubCategory(category: item)),
                            leading: CachedImage(item.categoryIcon, height: 30, width: 30),
                            title: Text("${item.categoryName}"),
                            trailing: InkWell(
                              onTap: () => _gotoAddCategory(category: item),
                              child: Icon(Icons.edit),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 8),
                    ),
        ),
      ),
    );
  }
}
