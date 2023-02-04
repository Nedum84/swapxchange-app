import 'package:flutter/material.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/styles.dart';

class SwapSuggestBtn extends StatelessWidget {
  final Function() onClick;

  const SwapSuggestBtn({Key? key, required this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 6,
      left: 6,
      child: InkWell(
        onTap: onClick,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: KColors.PRIMARY.withOpacity(.8),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 12,
                child: Icon(
                  Icons.sync_outlined,
                  color: KColors.TEXT_COLOR,
                ),
              ),
              Text(
                ' suggest',
                style: StyleNormal.copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
