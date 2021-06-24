import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/repository/repo_sub_category.dart';
import 'package:swapxchange/ui/admin/subcategory/add_subcategory.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class AdminSubCategory extends StatefulWidget {
  final Category category;

  const AdminSubCategory({Key? key, required this.category}) : super(key: key);
  @override
  _AdminSubCategoryState createState() => _AdminSubCategoryState();
}

class _AdminSubCategoryState extends State<AdminSubCategory> {
  List<SubCategory> subCategories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  void _fetchData() async {
    if (subCategories.length == 0) setState(() => isLoading = true);
    final data = await RepoSubCategory.findByCategoryId(catId: widget.category.categoryId!);
    if (data != null) {
      subCategories.clear();
      subCategories.addAll(data);
    }
    setState(() => isLoading = false);
  }

  _gotoAddCategory({SubCategory? subCat}) async {
    final goto = await Get.to(() => AddSubCategory(subCategory: subCat, category: widget.category));
    if (goto != null) {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: KColors.TEXT_COLOR_DARK,
          ),
          onPressed: () => Get.back(),
        ),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sub Categories',
              style: H1Style,
            ),
            Text(
              '${widget.category.categoryName}',
              style: StyleNormal.copyWith(),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _gotoAddCategory,
            icon: Icon(Icons.add, color: KColors.TEXT_COLOR_DARK),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchData(),
        color: KColors.PRIMARY,
        strokeWidth: 3,
        child: Container(
          child: isLoading && subCategories.length == 0
              ? Center(child: CircularProgressIndicator())
              : subCategories.length == 0
                  ? Center(child: Text('Nothing found'))
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: subCategories.length,
                      itemBuilder: (context, index) {
                        final item = subCategories[index];

                        return Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: CachedImage(item.subCategoryIcon, height: 30, width: 30),
                            title: Text("${item.subCategoryName}"),
                            trailing: InkWell(
                              onTap: () => _gotoAddCategory(subCat: item),
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
