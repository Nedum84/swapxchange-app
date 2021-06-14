import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/controllers/add_product_controller.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/view_image.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class ImageViewpager extends StatelessWidget {
  ImageViewpager({
    this.deleteImage,
    this.makeCover,
  });

  final Function(ProductImage)? deleteImage;
  final Function(ProductImage)? makeCover;
  PageController controller = PageController();

  bool isScrolled = false;

  goto(int index) {
    Timer(Duration(microseconds: 300), () {
      controller.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddProductController>(builder: (addController) {
      final imageProducts = addController.imageList;
      int pageIndex = imageProducts.indexWhere((element) => element.isCurrent == true);

      return PageView.builder(
        controller: controller,
        itemCount: imageProducts.length,
        physics: BouncingScrollPhysics(),
        onPageChanged: (index) {
          if (!imageProducts[index].isCurrent) {
            // final mkCurrent = ImageUploadUtilities.makeImageCurrent(imageProducts[index]);
            // addController.setImgList(mkCurrent);
          }
        },
        itemBuilder: (builder, index) {
          if (!isScrolled && index != pageIndex) {
            goto(pageIndex);
            isScrolled = true;
          }

          return Stack(
            children: [
              GestureDetector(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewImage(
                            curStep: pageIndex,
                            imageProducts: imageProducts,
                          ),
                        ),
                      ),
                  child: CachedImage(
                    imageProducts[index].imagePath!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  )),
              (index == 0)
                  ? Container()
                  : Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 30),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(color: KColors.PRIMARY, borderRadius: BorderRadius.all(Radius.circular(25))),
                        child: InkWell(
                          onTap: () => makeCover!(imageProducts[index]),
                          child: Text(
                            'set as cover image',
                            style: StyleNormal.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(bottom: 24),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: InkWell(
                    onTap: () => deleteImage!(imageProducts[index]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Delete',
                          style: TextStyle(color: KColors.TEXT_COLOR),
                        ),
                        Icon(
                          Icons.delete_rounded,
                          color: KColors.TEXT_COLOR,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
