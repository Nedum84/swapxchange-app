import 'package:flutter/material.dart';
import 'package:swapxchange/ui/splash/sliver_header.dart';

class SliverHeader3 extends ElSliverPersistentHeaderDelegate {
  @override
  // TODO: implement maxExtent
  double get maxExtent => 400;

  @override
  // TODO: implement minExtent
  double get minExtent => 80;

  @override
  Widget build(BuildContext context, double shrinkOffset) {
    return SliverToBoxAdapter(
      child: Column(
        children: List.generate(50, (index) {
          return Container(
            height: 72,
            color: Colors.blue[200],
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(8),
            child: Text('Item $index'),
          );
        }),
      ),
    );
  }
}
