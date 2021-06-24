import 'package:flutter/material.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/ui/home/tabs/home/top_deals.dart';
import 'package:swapxchange/utils/colors.dart';

class CategoryCol extends StatelessWidget {
  final List<Category> categories;
  final Category selected;
  final Function(Category category) onSelect;

  const CategoryCol({Key? key, required this.categories, required this.selected, required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final current = categories[index];
            Color? txtColor = selected.categoryId != current.categoryId ? KColors.TEXT_COLOR.withOpacity(.2) : null;
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              child: CategoryBtn(
                imagePath: current.categoryIcon ?? "",
                textColor: txtColor,
                showShadow: selected.categoryId != current.categoryId ? false : true,
                title: current.categoryName!,
                onClick: () => onSelect(current),
                textSize: 12,
              ),
            );
          },
        ),
      ),
    );
  }
}
