import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/utils/colors.dart';

class ImageListView extends StatelessWidget {
  ImageListView({
    required this.imageProducts,
    required this.onImageClick,
    required this.addImageClick,
    this.showIndicator = true,
  });

  final List<ProductImage> imageProducts;
  final Function(ProductImage) onImageClick;
  final Function addImageClick;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
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
                color: Colors.blueGrey[100]!.withOpacity(0.7),
                border: Border.all(
                  width: 1,
                  color: (index == pageIndex && showIndicator) ? KColors.PRIMARY : Colors.transparent,
                )),
            child: (imageProducts == null || index == imageProducts.length)
                ? InkWell(
                    onTap: () => addImageClick(),
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          color: Colors.white70,
                        ),
                        Text(
                          'ADD PHOTO',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )
                      ],
                    )))
                : GestureDetector(
                    onTap: () => onImageClick(imageProducts[index]),
                    child: Container(
                      child: CachedImage(imageProducts[index].imagePath!),
                    ),
                  ),
          );
        });
  }
}
