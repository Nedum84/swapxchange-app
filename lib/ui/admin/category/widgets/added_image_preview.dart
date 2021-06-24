import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/view_image.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class AddedImagePreview extends StatelessWidget {
  final Function() onDoubleClick;
  final String imgUrl;

  const AddedImagePreview({Key? key, required this.onDoubleClick, required this.imgUrl}) : super(key: key);

  _viewImage() {
    Get.to(
      () => ViewImage(
        curStep: 0,
        imageProducts: [
          ProductImage(imagePath: imgUrl, productId: 0, id: 0, idx: 0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _viewImage,
      onDoubleTap: onDoubleClick,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            CachedImage(
              imgUrl,
              width: double.infinity,
            ),
            Container(color: Colors.black.withOpacity(.5)),
            Align(
              alignment: Alignment.center,
              child: Text(
                "TAP TO VIEW\n DOUBLE TAP TO REPLACE",
                textAlign: TextAlign.center,
                style: StyleNormal.copyWith(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
