import 'package:flutter/material.dart';
import 'package:swapxchange/ui/home/tabs/saved/saved_product.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final int itemCount;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.itemCount = 0,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0 && !isLoading) {
      return NoProductWidget(title: 'No product found around your location');
    }
    if (isLoading && itemCount != 0) {
      return Center(
        child: LoadingProgressMultiColor(),
      );
    }
    return child;
  }
}
