import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/ui/home/product/product_detail/product_detail.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
        () => ProductDetail(),
        transition: Transition.topLevel,
        // transition: Transition.zoom,
        preventDuplicates: true,
        duration: Duration(milliseconds: 600),
      ),
      child: Container(
        padding: EdgeInsets.all(Constants.PADDING / 2),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [Constants.SHADOW_LIGHT],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'images/logo.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  color: KColors.TEXT_COLOR_LIGHT.withOpacity(.2),
                ),
              ),
            ),
            Text(
              'Leather Chair ',
              style: StyleProductTitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '₦302,547',
                    style: StyleProductPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                LocationBtn()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LocationBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          color: KColors.PRIMARY, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 10,
            color: Colors.white,
          ),
          Text(
            'Lagos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
