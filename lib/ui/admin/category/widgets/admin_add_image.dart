import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class AddImage extends StatelessWidget {
  final Function() onClick;

  const AddImage({Key? key, required this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              color: KColors.TEXT_COLOR,
            ),
            Text(
              'ADD BANNER',
              style: StyleNormal.copyWith(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
