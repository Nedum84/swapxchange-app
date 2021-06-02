import 'package:flutter/material.dart';
import 'package:swapxchange/models/product_image.dart';
import 'package:swapxchange/ui/components/step_progress_view.dart';
import 'package:swapxchange/ui/widgets/cached_image.dart';

class ViewImage extends StatefulWidget {
  final int curStep;
  final List<ProductImage> imageProducts;

  ViewImage({this.curStep = 0, required this.imageProducts});
  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  int _curStep = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    setState(() {
      _curStep = widget.curStep;
    });
    _pageController = PageController(initialPage: _curStep);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
              controller: _pageController,
              physics: BouncingScrollPhysics(),
              onPageChanged: (newPage) {
                setState(() {
                  _curStep = newPage;
                });
              },
              itemCount: widget.imageProducts.length,
              itemBuilder: (build, index) {
                return Container(
                  child: CachedImage(
                    widget.imageProducts[index].imagePath!,
                    fit: BoxFit.contain,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 30),
              child: StepProgressView(
                itemSize: widget.imageProducts.length,
                width: MediaQuery.of(context).size.width,
                curStep: _curStep,
                activeColor: Colors.white,
                // inActiveColor: Colors.black87.withOpacity(.3),
              ),
            ),
          ),
          Positioned(
            top: 45,
            left: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
