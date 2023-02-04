import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/sub_category_controller.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/ui/home/product/addproduct/widgets/bottomsheet_container.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class SelectSubCategory extends StatelessWidget {
  final addController = AddProductController.to;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      subtitle: 'Select sub category',
      title: addController.category!.categoryName!,
      child: Expanded(
        child: FutureBuilder(
          future: SubCategoryController.to.fetchByCategoryId(catId: addController.category!.categoryId!),
          builder: (BuildContext context, AsyncSnapshot<List<SubCategory>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty || snapshot.data!.length == 0) {
                return Center(
                  child: Text(
                    'No subcategory found',
                    style: StyleNormal.copyWith(fontSize: 18),
                  ),
                );
              }
              var subCats = snapshot.data;

              return ListView.separated(
                itemCount: subCats!.length,
                itemBuilder: (context, index) {
                  final subCat = subCats[index];
                  final isSelected = addController.subCategory?.subCategoryId == subCat.subCategoryId;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      addController.setSubCategory(subCat);

                      Navigator.of(context).pop();
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: KColors.TEXT_COLOR_LIGHT,
                    ),
                    title: Text(
                      subCat.subCategoryName ?? "",
                      style: StyleNormal.copyWith(
                        fontSize: 16,
                        color: isSelected ? KColors.TEXT_COLOR_DARK : KColors.TEXT_COLOR,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(color: KColors.TEXT_COLOR.withOpacity(.3)),
              );
            }
            return Center(child: LoadingProgressMultiColor());
          },
        ),
      ),
    );
  }
}
