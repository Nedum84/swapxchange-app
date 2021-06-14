import 'package:flutter/material.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/ui/home/product/addproduct/widgets/bottomsheet_container.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class SelectCategory extends StatelessWidget {
  final addController = AddProductController.to;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      title: 'Category',
      child: Expanded(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: CategoryController.to.categoryList.length,
          itemBuilder: (context, index) {
            final cat = CategoryController.to.categoryList[index];
            final isSelected = addController.category?.categoryId == cat.categoryId;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                addController.setCategory(cat);

                Navigator.of(context).pop();
              },
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: KColors.TEXT_COLOR_LIGHT,
              ),
              title: Text(
                cat.categoryName ?? "",
                style: StyleNormal.copyWith(
                  fontSize: 16,
                  color: isSelected ? KColors.TEXT_COLOR_DARK : KColors.TEXT_COLOR,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(color: KColors.TEXT_COLOR.withOpacity(.3)),
        ),
      ),
    );
  }
}
