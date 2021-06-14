import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class ImageListView extends StatelessWidget {
  ImageListView({
    required this.onImageClick,
    required this.addImageClick,
    this.showIndicator = true,
  });

  final Function(ProductImage) onImageClick;
  final Function addImageClick;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(
      builder: (controller) {
        final imageProducts = controller.imageList;
        int pageIndex = imageProducts.indexWhere((element) => element.isCurrent == true);

        return ListView.builder(
          itemCount: imageProducts.length != 0 ? (imageProducts.length + 1) : 1,
          scrollDirection: Axis.horizontal,
          itemBuilder: (builder, index) {
            return Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: KColors.WHITE_GREY,
                border: Border.all(
                  width: 1,
                  color: (index == pageIndex && showIndicator) ? KColors.PRIMARY : Colors.transparent,
                ),
              ),
              child: (index == imageProducts.length)
                  ? InkWell(
                      onTap: () => addImageClick(),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: KColors.TEXT_COLOR,
                            ),
                            Text(
                              'ADD PHOTO',
                              style: StyleNormal.copyWith(fontSize: 10),
                            )
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () => onImageClick(imageProducts[index]),
                      child: Container(
                        child: CachedImage(imageProducts[index].imagePath!),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
