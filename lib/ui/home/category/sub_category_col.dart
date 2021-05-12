import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class SubCategoryCol extends StatelessWidget {
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
      child: ListView.separated(
        padding: EdgeInsets.all(0),
        itemCount: 40,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return SubCategoryItem();
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );
  }
}

class SubCategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mobile phones',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StyleNormal,
                ),
                Text(
                  '12 items',
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
    );
  }
}
