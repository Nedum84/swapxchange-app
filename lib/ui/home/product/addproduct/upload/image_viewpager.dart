import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/view_image.dart';
import 'package:swapxchange/utils/colors.dart';

class ImageViewpager extends StatelessWidget {
  ImageViewpager(
      {required this.imageProducts,
      this.deleteImage,
      this.makeCover,
      this.currentScrolled,});

  final List<ProductImage> imageProducts;
  final Function(ProductImage)? deleteImage;
  final Function(ProductImage)? makeCover;
  final Function(ProductImage)? currentScrolled;
  PageController controller = PageController();

  bool isScrolled = false;

  @override
  Widget build(BuildContext context) {
    int pageIndex =
        imageProducts.indexWhere((element) => element.isCurrent == true);
    // controller = PageController(initialPage: pageIndex??0);
    // print('f =$pageIndex');

    return PageView.builder(
        // onPageChanged: (newPage)=> currentScrolled(imageProducts[newPage]),
        controller: controller,
        itemCount: imageProducts.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (builder, index) {
          if (!isScrolled && index != pageIndex) {
            Timer(Duration(microseconds: 500), () {
              controller.animateToPage(pageIndex,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            });
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
                  child:CachedImage(
                          imageProducts[index].imagePath!,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        )),
              (index==0)?Container():Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                      color: KColors.PRIMARY,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: GestureDetector(
                      onTap: () => makeCover!(imageProducts[index]),
                      child: Text('set as cover image'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 100,
                  margin: EdgeInsets.only(bottom: 24),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: GestureDetector(
                    onTap: () => deleteImage!(imageProducts[index]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        Icon(
                          Icons.delete_rounded,
                          color: Colors.blueGrey[100],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
