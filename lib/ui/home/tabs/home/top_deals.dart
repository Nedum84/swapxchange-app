import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/category_controller.dart';
import 'package:swapxchange/models/category_model.dart';
import 'package:swapxchange/ui/home/category/browse_category.dart';
import 'package:swapxchange/ui/home/category/view_single_category.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class TopDeals extends StatelessWidget {
  _goto(Category category) {
    Get.to(() => ViewSingleCategory(category: category));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (controller) {
      final hotCats = controller.hotDeals();
      if (controller.categoryList.isEmpty) return Container();
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Deals',
            style: H1Style,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CategoryBtn(
                  imagePath: hotCats[0].categoryIcon ?? "",
                  title: hotCats[0].categoryName ?? "",
                  onClick: () => _goto(hotCats[0]),
                ),
              ),
              Expanded(
                child: CategoryBtn(
                  imagePath: hotCats[1].categoryIcon ?? "",
                  title: hotCats[1].categoryName ?? "",
                  onClick: () => _goto(hotCats[1]),
                ),
              ),
              Expanded(
                child: CategoryBtn(
                  imagePath: hotCats[2].categoryIcon ?? "",
                  title: hotCats[2].categoryName ?? "",
                  onClick: () => _goto(hotCats[2]),
                ),
              ),
              Expanded(child: SeeAllBtn(title: 'See All')),
            ],
          )
        ],
      );
    });
  }
}

class CategoryBtn extends StatelessWidget {
  final String title;
  final bool showShadow;
  final Color? textColor;
  final Function()? onClick;
  final double? size;
  final double? textSize;
  final double padding;
  final int maxLines;
  final String imagePath;

  const CategoryBtn({
    Key? key,
    required this.title,
    this.showShadow = true,
    this.textColor,
    this.onClick,
    this.size,
    this.textSize,
    required this.imagePath,
    this.padding = 16,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            height: size ?? Get.width / 6,
            width: size ?? Get.width / 6,
            padding: EdgeInsets.all(padding),
            margin: EdgeInsets.only(bottom: 2, top: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: showShadow ? [Constants.SHADOW] : [],
              border: Border.all(
                color: textColor != null ? KColors.TEXT_COLOR_LIGHT.withOpacity(.2) : Colors.transparent,
              ),
              color: Colors.white,
            ),
            child: Align(
              alignment: Alignment.center,
              child: CachedImage(
                imagePath,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Text(
            title,
            style: StyleNormal.copyWith(
              color: textColor != null ? textColor : KColors.TEXT_COLOR,
              fontSize: textSize ?? 14,
            ),
            maxLines: maxLines,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4)
        ],
      ),
    );
  }
}

class SeeAllBtn extends StatelessWidget {
  final String title;

  const SeeAllBtn({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => BrowseCategory()),
      child: Column(
        children: [
          Container(
            height: Get.width / 6,
            width: Get.width / 6,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [Constants.SHADOW],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_forward_ios,
                color: KColors.PRIMARY,
              ),
            ),
          ),
          Text(
            title,
            style: StyleNormal,
          )
        ],
      ),
    );
  }
}
