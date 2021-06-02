import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/ui/home/product/product_detail/product_detail.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class SwapSuggestion extends StatelessWidget {
  final Product suggestedProduct;
  final Product myProduct;
  final bool openProduct;
  SwapSuggestion({required this.suggestedProduct, required this.myProduct, this.openProduct = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductExchangeWidget(
            onClick: () => {if (openProduct) Get.to(() => ProductDetail(product: suggestedProduct))},
            product: myProduct,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                '- - -',
                textAlign: TextAlign.center,
                style: StyleNormal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Icon(Icons.sync, color: KColors.TEXT_COLOR),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                '- - -',
                textAlign: TextAlign.center,
                style: StyleNormal,
              ),
            ),
          ),
          ProductExchangeWidget(
            onClick: () => {if (openProduct) Get.to(() => ProductDetail(product: suggestedProduct))},
            product: suggestedProduct,
          ),
        ],
      ),
    );
  }
}

class ProductExchangeWidget extends StatelessWidget {
  final Product product;
  final Function() onClick;

  const ProductExchangeWidget({Key? key, required this.product, required this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          CachedImage(
            ((product.images!.length != 0) ? product.images!.first.imagePath : '')!,
            width: 80,
            height: 80,
            radius: 6,
          ),
          SizedBox(height: 4),
          Container(
            width: 80,
            child: Text(
              product.productName!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: StyleNormal,
            ),
          ),
        ],
      ),
    );
  }
}
