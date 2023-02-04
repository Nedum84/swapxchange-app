import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/ui/home/product/product_detail/product_detail.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/helpers.dart';
import 'package:swapxchange/utils/styles.dart';

class ProductItem extends StatelessWidget {
  final Product? product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  _goto() {
    Get.to(() => ProductDetail(product: product!));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _goto,
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
                child: CachedImage(
                  product!.images!.length > 0 ? '${product!.images!.first.imagePath}' : "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  alt: ImagePlaceholder.NoImage,
                  // color: KColors.TEXT_COLOR_LIGHT.withOpacity(.2),
                ),
              ),
            ),
            Text(
              "${product!.productName}",
              style: StyleProductTitle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '₦${Helpers.formatMoney(cash: product!.price!, withDot: false)}',
                    style: StyleProductPrice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                LocationBadge(product: product)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LocationBadge extends StatelessWidget {
  final Product? product;

  const LocationBadge({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(color: KColors.PRIMARY, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 10,
              color: Colors.white,
            ),
            Expanded(
              child: Text(
                '${product?.userAddressCity}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
