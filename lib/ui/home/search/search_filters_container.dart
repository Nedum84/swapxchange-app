import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/product_search_controller.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class SearchFiltersContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: GetBuilder<ProductSearchController>(
          init: ProductSearchController(),
          builder: (controller) {
            return ListView.separated(
              itemCount: controller.filters.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String item = controller.filters[index];
                Color textColor = item == controller.searchFilter.value ? KColors.PRIMARY : KColors.TEXT_COLOR.withOpacity(.6);
                return SearchFilterItem(
                  textColor: textColor,
                  text: item.toUpperCase().replaceAll('-', ' '),
                  onClick: () {
                    controller.searchFilter(item);
                    controller.resetList(true);
                    controller.productList.clear();
                    controller.update();
                    controller.fetchProducts();
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 16),
            );
          }),
    );
  }
}

class SearchFilterItem extends StatelessWidget {
  final String text;
  final Function() onClick;
  final Color textColor;

  const SearchFilterItem({Key? key, required this.text, required this.onClick, required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        alignment: Alignment.center,
        child: Text(
          text,
          style: StyleNormal.copyWith(color: textColor),
        ),
      ),
    );
  }
}
