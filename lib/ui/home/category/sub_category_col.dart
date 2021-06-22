import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/sub_category_model.dart';
import 'package:swapxchange/ui/home/subcategory/view_products.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class SubCategoryCol extends StatelessWidget {
  final List<SubCategory> subCats;

  const SubCategoryCol({Key? key, required this.subCats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Constants.PADDING / 2,
        horizontal: Constants.PADDING,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [Constants.SHADOW_LIGHT],
        borderRadius: BorderRadius.circular(4),
      ),
      child: subCats.length == 0
          ? Center(child: Text('No subcategory found'))
          : ListView.separated(
              padding: EdgeInsets.all(0),
              itemCount: subCats.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SubCategoryItem(subCat: subCats[index]);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
            ),
    );
  }
}

class SubCategoryItem extends StatelessWidget {
  final SubCategory subCat;

  const SubCategoryItem({Key? key, required this.subCat}) : super(key: key);

  _goto() {
    Get.to(() => ViewSubCatProducts(subcategory: subCat));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _goto,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${subCat.subCategoryName}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: StyleNormal,
                  ),
                  Text(
                    '${subCat.noOfProducts} items',
                    style: StyleCategorySubTitle,
                  ),
                ],
              ),
            ),
            SizedBox(width: 4),
            CircleAvatar(
              backgroundColor: Color(0xffE4E5E8),
              radius: 10,
              child: Icon(
                Icons.arrow_forward_ios,
                color: KColors.TEXT_COLOR,
                size: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
