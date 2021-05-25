import 'package:flutter/material.dart';

class ShimmerBlock extends StatelessWidget {
  final double? height;
  final double? width;

  ShimmerBlock({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
