import 'package:flutter/material.dart';
import 'package:swapxchange/models/product_model.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/question_mark.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class TopbarSwapSuggestion extends StatelessWidget {
  final Product? product;
  final Product? offerProduct;

  const TopbarSwapSuggestion({Key? key, this.product, this.offerProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 4, left: 8, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[BoxShadow(color: Colors.black54, blurRadius: 1.0, offset: Offset(0.0, 0.2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      product?.productName ?? '',
                      textAlign: TextAlign.end,
                      style: StyleNormal.copyWith(fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 8),
                  CachedImage(
                    product?.images?.first.imagePath ?? "",
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                    radius: 12,
                    alt: ImagePlaceholder.QuestionMark,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Icon(
              Icons.sync,
              color: KColors.TEXT_COLOR_DARK.withOpacity(.5),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: [
                  (offerProduct != null && offerProduct!.images!.length > 0)
                      ? CachedImage(
                          offerProduct!.images!.first.imagePath!,
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                          radius: 12,
                          alt: ImagePlaceholder.QuestionMark,
                        )
                      : QuestionMark(
                          radius: 12,
                        ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      offerProduct?.productName ?? '',
                      style: StyleNormal.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
