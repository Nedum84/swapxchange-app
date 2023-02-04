import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';
import 'package:swapxchange/ui/widgets/step_progress_view.dart';
import 'package:swapxchange/ui/widgets/view_image.dart';

class ImageCarousel extends StatefulWidget {
  ImageCarousel({required this.imageProducts});

  final List<ProductImage> imageProducts;

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _curStep = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.size.height / 3,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (newPage) => setState(() => _curStep = newPage),
            itemCount: widget.imageProducts.length,
            itemBuilder: (build, index) {
              return CachedImage(
                widget.imageProducts[index].imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                onClick: () => Get.to(
                  () => ViewImage(imageProducts: widget.imageProducts, curStep: _curStep),
                ),
              );
            },
          ),
          if (widget.imageProducts.length > 1)
            Positioned(
              bottom: 20,
              child: StepProgressView(
                itemSize: widget.imageProducts.length,
                width: MediaQuery.of(context).size.width,
                curStep: _curStep,
                activeColor: Colors.white,
                // inActiveColor: Colors.black87.withOpacity(.3),
              ),
            ),
        ],
      ),
    );
  }
}
